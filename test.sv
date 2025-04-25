`include "uvm_macros.svh"
import uvm_pkg::*;
import my_pkg::*;

class test extends uvm_test;

`uvm_component_utils(test)

sequencer s1;
my_env e1;
virtual dut_if vif;

function new(string name="seq", uvm_component parent=null);
super.new(name, parent);
endfunction

virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);

e1=my_env::type_id::create("e1", this);

if(!uvm_config_db#(virtual dut_if)::get(this,"","dut_vif",vif))
    `uvm_fatal(get_type_name(), "Didnt get virtual Interface")


uvm_config_db#(virtual dut_if)::set(this,"e1.a1.*","dut_vif",vif);

endfunction

virtual task run_phase(uvm_phase phase);
s1= sequencer::type_id::create("s1");
phase.raise_objection(this, "Starting");
apply_reset();
s1.start(e1.a1.s1);
#1000
phase.drop_objection(this, "End");

endtask

virtual task apply_reset();

vif.rstn<=0;
repeat(5) @(posedge vif.clk);
vif.rstn<=1;
repeat(10) @(posedge vif.clk);

endtask

endclass


module tb(
);

bit  clk;

dut_if vif(clk);
mem inst(vif);



always begin
    #10
    clk=~clk;
end

initial begin
    uvm_config_db#(virtual dut_if)::set(null,"*","dut_vif", vif);
    run_test("test");
end

    
endmodule