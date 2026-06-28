# AHB3-Lite Timer — UVM Verification Environment

A UVM testbench built to verify the Roa Logic AHB3-Lite Timer IP — a RISC-V
`mtime`/`mtimecmp`-compatible timer peripheral with an AHB-Lite slave
interface. This is a from-scratch verification environment: agent, RAL
register model, custom AHB reg adapter, a cycle-by-cycle reference model,
and pipelined-access sequences, checked against the DUT every clock cycle.

## DUT under test

`rtl/ahb3lite_timer.sv` (third-party IP, Roa Logic, RoaLogic Non-Commercial
License — see file header) implements `TIMERS` independent timers sharing
one 64-bit `time` counter and one programmable global prescaler, with
per-timer compare registers and interrupt-pending/enable bits.

| Offset | Register   | Access | Description                          |
|--------|------------|--------|---------------------------------------|
| 0x00   | PRESCALE   | RW     | Global clock-divider value            |
| 0x04   | RESERVED   | RW     | Unused                                |
| 0x08   | IPENDING   | RO     | Per-timer interrupt-pending bits      |
| 0x0C   | IENABLE    | RW     | Per-timer interrupt-enable bits       |
| 0x10/14| TIME       | RW     | 64-bit free-running counter           |
| 0x18+8n/1C+8n | TIMECMP[n] | RW | 64-bit compare value, timer n        |

Configured for `HADDR_SIZE=32`, `HDATA_SIZE=32`, `TIMERS=3` (`tb/shared_package.sv`).

## Testbench architecture

```
tb_top (tb/top)
 └─ test (tb/test)
     └─ env (tb/env)
         ├─ agent
         │   ├─ sequencer
         │   ├─ driver    -> drives AHB signals onto the interface
         │   └─ monitor   -> samples the bus every clock, broadcasts to:
         │                     ├─ scoreboard (every cycle)
         │                     └─ coverage collector
         ├─ scoreboard    -> cycle-accurate reference model + checker
         ├─ coverage collector
         └─ uvm_reg_predictor (wired up, disabled by default — see below)
```

**Register layer (`tb/reg/`):** a `uvm_reg_block` (`PRESCALER`, `RESERVED`,
`IPENDING`, `IENABLE`, `TIME`, `TIMECMP`) mapped at the offsets above, with a
custom `reg_adapter` (`ahb_reg_adapter.sv`) translating between RAL's
`uvm_reg_bus_op` and the AHB-Lite signal set (`reg2bus`/`bus2reg`).
`set_auto_predict(0)` is set on the map, and `use_predictor` defaults to `0`
in `shared_package.sv` — register-write outcomes in the default test flow
are verified through the explicit reference model in the scoreboard rather
than RAL's built-in mirror, since the built-in predictor's prediction
update only matches one AHB beat per call and doesn't have a clean concept
of "ignore idle bus cycles" without an explicit gate in `bus2reg`. The
`uvm_reg_predictor` path is fully wired and can be turned on via
`use_predictor` if you want RAL mirror tracking active as well.

**Sequences (`tb/seq/`):**
- `reset_seq` — pulses `HRESETn` low for 5 cycles, then releases
- `base_seq` — idle/do-nothing cycles (`HSEL=0`) for a given cycle count
- `base_reg_seq` — RAL-based single-register access (`reg.write()`/`read()`
  with blocking response — used for the directed prescale/timecmp/interrupt
  enable flow in the test)
- `Txn_seq` + `pipe_txns()` — issues back-to-back AHB transactions without
  waiting for each one's response before sending the next, specifically to
  exercise the bus's pipelining (address phase of txn N+1 overlapping the
  data phase of txn N)

**Scoreboard / reference model (`tb/env/ahb_scoreboard.sv`):** a hand-written
cycle-accurate model — `write_to_reg`, `read_from_reg`, `timer_tick`,
`count_prescaled`, `check_interrupt` — mirrors the DUT's prescale-counter and
free-running-time behavior independently of RAL, and checks `HRESP`,
`HREADYOUT`, `HRDATA` (gated on a read actually being outstanding), and
`tint` against the DUT every single clock cycle, reporting per-signal
mismatch counts at `report_phase`.

**Coverage (`tb/env/ahb_coverage.sv`):** currently tracks interrupt
assertion and reset-attempted events; flagged in-code as "more to be added
later" — a natural next step is HTRANS/HSIZE cross-coverage and per-register
read/write coverage.

## Verification plan

`docs/ahb_timer_verification_plan.xlsx` — test plan, register map, coverage
plan, and TB architecture, tracked as a living document alongside the code.

## Running the sim

```
cd sim
vsim -do run.do          # or your simulator's equivalent invocation
```
`run.do` compiles via `filelist.f`, runs the full test, and produces
`coverage_report.txt` (branch coverage on the DUT) and `report.txt` (UVM
log) — both gitignored since they're regenerated per run.

## Known limitations / next steps

- Coverage collector only has two coverpoints today; register-access and
  HTRANS-type cross-coverage would meaningfully strengthen the plan.
- The 64-bit-register split-write path (`write_reg()` on `TIMECMP`/`TIME`
  issuing two 32-bit beats) is functionally covered by the scoreboard's
  cycle-by-cycle model, but RAL's own predictor path needs the access-gate
  fix in `bus2reg` before `use_predictor=1` is collision-free — that fix is
  scoped but not yet merged into this adapter.
- Only the `HDATA_SIZE==32` branch of the DUT is exercised; the 64-bit-bus
  branch is untested.
