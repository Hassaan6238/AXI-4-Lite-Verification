`include "uvm_macros.svh"
import uvm_pkg::*;
import my_pkg::*;

class my_sequence1 extends uvm_sequence#(transaction);

rand int num_reads;
rand bit[31:0] start_addr;
`uvm_object_utils(my_sequence1)

function new(string name ="my_sequence");
super.new(name);
endfunction

virtual task body();

repeat(num_reads)
begin
    transaction t1;
    t1 = transaction::type_id::create("tr");
    start_item(t1);
    assert(t1.randomize() with
    {   
        S_ARADDR == start_addr;
        S_ARVALID==1;
        S_RREADY==1;
        S_AWVALID==0;
        S_WVALID==0;

    });
    // t1.print();
    start_addr+=2;
    finish_item(t1);

end
endtask

endclass

