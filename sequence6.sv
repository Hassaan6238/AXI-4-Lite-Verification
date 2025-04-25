`include "uvm_macros.svh"
import uvm_pkg::*;
import my_pkg::*;

class my_sequence6 extends uvm_sequence#(transaction);

rand int num_reads;
rand bit[31:0] start_addr;
`uvm_object_utils(my_sequence6)

function new(string name ="my_sequence6");
super.new(name);
endfunction

virtual task body();

repeat(num_reads)
begin
    transaction t1;
    t1 = transaction::type_id::create("tr");
    start_item(t1);
    assert(t1.randomize() with
    {   S_ARVALID==0;
        S_AWADDR == start_addr;
        S_AWVALID==1;
        S_BREADY==1;

    });
    // t1.print();
    start_addr+=2;
    finish_item(t1);

end
endtask

endclass

