import shared_package::*;
import ahb3lite_pkg::*;
interface IF (input bit clk);
//   //AHB Parameters
//   localparam HADDR_SIZE = 32,
//   localparam HDATA_SIZE = 32,

//   //Timer Parameters
//   localparam TIMERS     = 3    //Number of timers
	
// ============================================================================================ 
  logic                       HRESETn,
                              HCLK;
  assign HCLK = clk;                              

  //AHB Slave Interfaces (receive data from AHB Masters)
  //AHB Masters connect to these ports
  logic                       HSEL;
  logic      [HADDR_SIZE-1:0] HADDR;
  logic      [HDATA_SIZE-1:0] HWDATA;
  logic                       HWRITE;
  logic      [           2:0] HSIZE;
  logic      [           2:0] HBURST;
  logic      [           3:0] HPROT;
  logic      [           1:0] HTRANS;
  logic                       HREADY;

  logic                      HRESP;
  reg                        HREADYOUT;
  reg [HDATA_SIZE-1:0]       HRDATA;



  reg                        tint;  //Timer Interrupt
   
// ============================================================================================
    // Enum for easier waveform debugging
// ============================================================================================    
  
// ============================================================================================
    // Modport/s
// ============================================================================================    
    modport DUT (
        // All inputs
        input HCLK,HRESETn,HSEL,HADDR,HWDATA,HWRITE,HSIZE,HBURST,HPROT,HTRANS,HREADY, // 11
        // All outputs
        output HRESP,HREADYOUT,HRDATA,tint // 4
    );

endinterface