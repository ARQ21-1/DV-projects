//----------------DISCRIPTION-----------------


module FIFO_memory #(parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 4)(
    output [DATA_WIDTH-1:0] rdata,        // Output data - data to be read
    input [DATA_WIDTH-1:0] wdata,         // Input data - data to be written
    input [ADDR_WIDTH-1:0] waddr, raddr,  // Write and read address
    input wclk_en, wfull, wclk          // Write clock enable, write full, write clock
    );

    localparam DEPTH = 1<<ADDR_WIDTH;     // Depth of the FIFO memory
    reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];// Memory array

    assign rdata = mem[raddr];          // Read data

    always @(posedge wclk)
        if (wclk_en && !wfull) mem[waddr] <= wdata; // Write data

endmodule
