`include "uvm_macros.svh"
import uvm_pkg::*;
import my_pkg::*;

class my_sequence2 extends uvm_sequence#(transaction);

rand int num_reads;
`uvm_object_utils(my_sequence2)

function new(string name ="my_sequence2");
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
        S_ARVALID==1;
        S_RREADY==1;
        S_WVALID==0;

    });
    // t1.print();
    finish_item(t1);

end
endtask

endclass

