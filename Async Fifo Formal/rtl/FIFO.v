
module Async_FIFO #(parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 4)(
    output [DATA_WIDTH-1:0] rdata,       // Output data - data to be read
    output wfull,                   // Write full signal
    output rempty,                  // Read empty signal
    input [DATA_WIDTH-1:0] wdata,        // Input data - data to be written
    input winc, wclk, wrst_n,       // Write increment, write clock, write reset
    input rinc, rclk, rrst_n        // Read increment, read clock, read reset
    );

    wire [ADDR_WIDTH-1:0] waddr, raddr;
    wire [ADDR_WIDTH:0] wptr, rptr, wq2_rptr, rq2_wptr;

    two_ff_sync #(ADDR_WIDTH+1) sync_r2w (       // Read pointer syncronization to write clock domain
        .q2(wq2_rptr), 
        .din(rptr),
        .clk(wclk), 
        .rst_n(wrst_n)
    );

    two_ff_sync #(ADDR_WIDTH+1) sync_w2r (       // Write pointer syncronization to read clock domain
        .q2(rq2_wptr), 
        .din(wptr),
        .clk(rclk), 
        .rst_n(rrst_n)
    );

    FIFO_memory #(DATA_WIDTH, ADDR_WIDTH) fifomem(    // Memory module
        .rdata(rdata), 
        .wdata(wdata),
        .waddr(waddr), 
        .raddr(raddr),
        .wclk_en(winc), 
        .wfull(wfull),
        .wclk(wclk)
    );

    rptr_empty #(ADDR_WIDTH) rptr_empty(         // Read pointer and empty signal handling
        .rempty(rempty),
        .raddr(raddr),
        .rptr(rptr), 
        .rq2_wptr(rq2_wptr),
        .rinc(rinc), 
        .rclk(rclk),
        .rrst_n(rrst_n)
    );

    wptr_full #(ADDR_WIDTH) wptr_full(           // Write pointer and full signal handling
        .wfull(wfull), 
        .waddr(waddr),
        .wptr(wptr), 
        .wq2_rptr(wq2_rptr),
        .winc(winc), 
        .wclk(wclk),
        .wrst_n(wrst_n)
    );

endmodule
