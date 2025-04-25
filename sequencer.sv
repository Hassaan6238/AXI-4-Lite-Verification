`include "uvm_macros.svh"
import uvm_pkg::*;
import my_pkg::*;


class axi_sequencer extends uvm_sequencer#(transaction);
`uvm_component_utils(axi_sequencer)

function new(string name="axi_sequencer", uvm_component parent);
    super.new(name, parent);
endfunction


endclass