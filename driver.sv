`include "uvm_macros.svh"
import uvm_pkg::*;
import my_pkg::*;


class driver extends uvm_driver#(transaction);

`uvm_component_utils(driver)

transaction t1;
virtual dut_if vif;

function new(string name = "driver", uvm_component parent= null);
    super.new(name, parent);
endfunction

virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
if(!uvm_config_db#(virtual dut_if)::get(this, "", "dut_vif", vif))
    `uvm_fatal(get_type_name(), "Could find Virtual interface")

endfunction



virtual task run_phase(uvm_phase phase);

forever begin
    
    @(posedge vif.ACLK);

    seq_item_port.get_next_item(t1);
    // $display("DRV: %t", $time);
    vif.S_ARADDR<=t1.S_ARADDR;
    vif.S_ARVALID<=t1.S_ARVALID;
    vif.S_RREADY<=t1.S_RREADY;
    vif.S_AWADDR<= t1.S_AWADDR;
    vif.S_AWVALID<=t1.S_AWVALID;
    vif.S_WVALID<=t1.S_WVALID;
    vif.S_WDATA<=t1.S_WDATA;
    vif.S_BREADY<=t1.S_BREADY;

    seq_item_port.item_done();

end

endtask

endclass