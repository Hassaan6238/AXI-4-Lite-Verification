
interface dut_if#(
    parameter ADDR_WIDTH=5,
    parameter DATA_WIDTH=32)(input logic ACLK);

logic ARESETN; 


logic [ADDR_WIDTH-1:0] S_ARADDR;
logic [DATA_WIDTH-1:0] S_RDATA;
logic S_ARREADY;
logic S_ARVALID;
logic S_RVALID;
logic S_RREADY;
logic S_RRESP;

logic [ADDR_WIDTH-1:0] S_AWADDR;
logic [DATA_WIDTH-1:0] S_WDATA;
logic S_AWREADY;
logic S_AWVALID;
logic S_WVALID;
logic S_WREADY;

logic S_BREADY;
logic S_BVALID;
logic S_BRESP;



endinterface
// package my_pkg;

// `include "transaction_mem.sv"
// `include "sequencer.sv" 
// `include "driver_mem.sv"
// `include "monitor_mem.sv"
// `include "agent.sv"
// `include "scoreboard_mem.sv"
// `include "env.sv"


// endpackage
package my_pkg;

`include "transaction.sv"
`include "sequence1.sv" 
`include "sequence2.sv" 
`include "sequence3.sv" 
`include "sequence6.sv" 
`include "sequence7.sv" 
`include "sequencer.sv" 
`include "driver.sv"
`include "monitor.sv"
`include "agent.sv"
`include "scoreboard.sv"
`include "env.sv"


endpackage




// interface dut_if(input logic clk);
// logic rstn; 
// logic [7:0] addr;
// logic [7:0] wdata;
// logic [7:0] rdata;
// logic wr;
// logic sel;
// logic ready;
    


// endinterface



