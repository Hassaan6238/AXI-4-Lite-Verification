`include "uvm_macros.svh"
import uvm_pkg::*;
import my_pkg::*;

class my_env extends uvm_env;

`uvm_component_utils(my_env)

my_agent a1;
scoreboard sb1;

function new(string name="my_env", uvm_component parent=null);
    super.new(name, parent);
endfunction

virtual function void build_phase(uvm_phase phase);
    
    super.build_phase(phase);
    a1=my_agent::type_id::create("a1", this);
    sb1=scoreboard::type_id::create("sb1", this);

endfunction

virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    a1.m1.mon_an_port.connect(sb1.ana_exp);

endfunction


endclass