package shared_package ;
    //AHB Parameters
  localparam HDATA_SIZE = 32,
   HADDR_SIZE = 32,

  // Test Parameters
  TIMERS     = 3  ;  //Number of timers
  localparam TIMER_UT = 32'd1;
  localparam PRSCL = 32'd9;
  localparam TIMEOUT = 64'd10;

/*
 * address    description                comment
 * 0x0   32   Prescale Register          Global Prescale register
 * 0x4   32   reserved                                         
 * 0x8   32   Interrupt Pending Register Pending interrupt p.timer
 * 0xC   32   Interrupt Enable Register  Enable interrupt p.timer
 * 0x10  64   'time' Register            'time[n]'
 * 0x18  64   'timecmp' Register         'timecmp[n]'
 */
  localparam [HADDR_SIZE-1:0] PRESCALE         = 'h0,
                              RESERVED         = 'h4,
                              IPENDING         = 'h8,
                              IENABLE          = 'hC,
                              TIME             = 'h10,
                              TIME_MSB         = 'h14,
                              TIMECMP          = 'h18,
                              TIMECMP_MSB      = 'h1C;

typedef enum {
  READ,
  WRITE,
  NO_OP
} command_t;


bit about_to_read;
bit use_predictor= 0 ;


typedef struct {
  command_t operation;
  logic [HADDR_SIZE-1:0] addr;
  logic [HDATA_SIZE-1:0] data;
} request_t;

localparam request_t NO_REQ = '{NO_OP, 'h0, 'h0};


 typedef enum bit [1:0] {
    IDLE,
    BUSY,
    NONSEQ,
    SEQ
  } HTRANS_t;

endpackage 