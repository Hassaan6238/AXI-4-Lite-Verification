`include "uvm_macros.svh"
import uvm_pkg::*;
import my_pkg::*;


class my_agent extends uvm_agent;

`uvm_component_utils(my_agent)

driver d1;
axi_sequencer s1;
my_monitor m1;

function new(string name = "agent" , uvm_component parent=null);
super.new(name, parent);
endfunction

virtual function void build_phase(uvm_phase phase);

    super.build_phase(phase);
    m1= my_monitor::type_id::create("m1", this);
    
    if(get_is_active())
    begin
    
        s1=axi_sequencer::type_id::create("s1",this);
        d1=driver::type_id::create("d1", this);
    
    end

endfunction

virtual function void connect_phase(uvm_phase phase);

    super.connect_phase(phase);
    if(get_is_active())
        d1.seq_item_port.connect(s1.seq_item_export);

endfunction

endclass