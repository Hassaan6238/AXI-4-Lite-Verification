`include "uvm_macros.svh"
import uvm_pkg::*;


class transaction  extends uvm_sequence_item;
localparam ADDR_WIDTH=32;
localparam DATA_WIDTH=8;

//read 
rand bit [ADDR_WIDTH-1:0] S_ARADDR;
rand bit S_ARVALID;
rand bit S_RREADY;

bit [DATA_WIDTH-1:0] S_RDATA;
bit S_RVALID;
bit S_ARREADY;


//write
rand bit[ADDR_WIDTH-1:0] S_AWADDR;
rand bit S_AWVALID;
rand bit [DATA_WIDTH-1:0] S_WDATA;
rand bit S_WVALID;


bit S_AWREADY;
bit S_WREADY;

//response;

rand bit S_BREADY;


`uvm_object_utils_begin(transaction)
`uvm_field_int(S_ARADDR, UVM_DEFAULT)
`uvm_field_int(S_ARVALID, UVM_DEFAULT)
`uvm_field_int(S_ARREADY, UVM_DEFAULT)
`uvm_field_int(S_RDATA, UVM_DEFAULT)
`uvm_field_int(S_RVALID, UVM_DEFAULT)
`uvm_field_int(S_RREADY, UVM_DEFAULT)
`uvm_field_int(S_AWADDR, UVM_DEFAULT)
`uvm_field_int(S_AWVALID, UVM_DEFAULT)
`uvm_field_int(S_AWREADY, UVM_DEFAULT)
`uvm_field_int(S_WDATA, UVM_DEFAULT)
`uvm_field_int(S_WVALID, UVM_DEFAULT)
`uvm_field_int(S_WREADY, UVM_DEFAULT)

`uvm_object_utils_end

function new(string name="transaction");
super.new(name);
endfunction



endclass