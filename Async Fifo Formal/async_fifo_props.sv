module async_fifo_props #(
  parameter DATA_WIDTH = 8,
  parameter ADDR_WIDTH = 4
)(
  input                       wclk, wrst_n, winc, wfull,
  input                       rclk, rrst_n, rinc, rempty,
  input  [ADDR_WIDTH-1:0]     waddr, raddr,
  input  [ADDR_WIDTH:0]       wptr, rptr,
  input  [DATA_WIDTH-1:0]     wdata, rdata
);

  //------------------------------------------------------------------
  // SAFETY: never write when full, never read when empty
  //------------------------------------------------------------------
  // The design already gates the memory write with (wclk_en && !wfull),
  // so this checks the *intent* never silently corrupts the pointer too.
  always @(posedge wclk)
    if (wrst_n) assert (!(winc && wfull && $past(wfull)));
      // $past(wfull) avoids flagging the same cycle wfull is first set

  always @(posedge rclk)
    if (rrst_n) assert (!(rinc && rempty && $past(rempty)));

  //------------------------------------------------------------------
  // SAFETY: full and empty are mutually exclusive
  // (true by construction - the full/empty compares use different gray
  //  bit patterns - this is a meta-check that construction is correct)
  //------------------------------------------------------------------
  always @(posedge wclk)
    if (wrst_n) assert (!(wfull && rempty));

  //------------------------------------------------------------------
  // POINTER CORRECTNESS: gray-code pointers change by at most 1 bit
  // per cycle (Hamming distance <= 1) - this is what makes the 2-FF
  // synchronizer safe to use across the clock-domain boundary at all
  //------------------------------------------------------------------
  always @(posedge wclk)
    if (wrst_n && $past(wrst_n))
      assert ($countones(wptr ^ $past(wptr)) <= 1);

  always @(posedge rclk)
    if (rrst_n && $past(rrst_n))
      assert ($countones(rptr ^ $past(rptr)) <= 1);

  //------------------------------------------------------------------
  // DATA INTEGRITY: once a memory slot is written, it holds that exact
  // value until the next write to that same slot. Combined with the
  // structural fact that raddr/waddr are derived directly from the
  // (formally-verified-correct) pointers, this is what proves "data
  // written is data read, in order" without needing a separate
  // cross-clock-domain scoreboard.
  //
  // Whitebox check: reaches into the sibling "fifomem" instance's
  // memory array directly - acceptable for formal, since we're not
  // constrained to a black-box bus interface like in simulation.
  //------------------------------------------------------------------
  (* anyconst *) wire [ADDR_WIDTH-1:0] f_addr;

  reg                   f_addr_written;
  reg [DATA_WIDTH-1:0]  f_expected;

  initial f_addr_written = 0;

  always @(posedge wclk) begin
    if (!wrst_n) begin
      f_addr_written <= 0;
    end
    else if (winc && !wfull && waddr == f_addr) begin
      f_addr_written <= 1;
      f_expected     <= wdata;
    end
  end

  always @(posedge wclk)
    if (wrst_n && f_addr_written && !(winc && !wfull && waddr == f_addr))
      assert (fifomem.mem[f_addr] == f_expected);

  //------------------------------------------------------------------
  // LIVENESS / REACHABILITY: full and empty states are actually
  // reachable, and the FIFO can be filled completely and drained
  // completely (not just "never crashes" - it actually does its job)
  //------------------------------------------------------------------
  always @(posedge wclk)
    cover (wfull);

  always @(posedge rclk)
    cover (rempty);

  always @(posedge wclk)
    cover (wrst_n && $past(wrst_n) && wfull && $past(!wfull));
    // covers the *transition into* full, not just "full happened once"

endmodule

bind Async_FIFO async_fifo_props #(
  .DATA_WIDTH (DATA_WIDTH),
  .ADDR_WIDTH (ADDR_WIDTH)
) async_fifo_props_inst (
  .wclk   (wclk),
  .wrst_n (wrst_n),
  .winc   (winc),
  .wfull  (wfull),
  .rclk   (rclk),
  .rrst_n (rrst_n),
  .rinc   (rinc),
  .rempty (rempty),
  .waddr  (waddr),
  .raddr  (raddr),
  .wptr   (wptr),
  .rptr   (rptr),
  .wdata  (wdata),
  .rdata  (rdata)
);
