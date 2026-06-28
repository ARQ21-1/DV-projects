module two_ff_sync #(parameter WIDTH = 4)( 
    output reg [WIDTH-1:0] q2,   // Output of the second flip-flop
    input [WIDTH-1:0] din,       // Input data
    input clk, rst_n            // Clock and reset
    );

    reg [WIDTH-1:0] q1; // Output of the first flip-flop

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) 
            {q2, q1} <= 0;          // Reset the FIFO
        else 
            {q2, q1} <= {q1, din};  // Shift the data
    end 

endmodule


 

