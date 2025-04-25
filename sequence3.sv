`include "uvm_macros.svh"
import uvm_pkg::*;
import my_pkg::*;

class my_sequence3 extends uvm_sequence#(transaction);

rand int num_reads;
`uvm_object_utils(my_sequence3)

function new(string name ="my_sequence3");
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
        S_ARVALID==0;
        S_RREADY==1;


    });
    // t1.print();
    finish_item(t1);

end
endtask

endclass

