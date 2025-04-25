`include "uvm_macros.svh"
import uvm_pkg::*;
import my_pkg::*;

class my_sequence4 extends uvm_sequence#(transaction);

rand int num_reads;
rand int max_delay;
`uvm_object_utils(my_sequence4)

function new(string name ="my_sequence4");
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
        ARREADY==1;
        ARVALID==0;
        RREADY==1;

    });
    t1.print();
    finish_item(t1);

    #($urandom_range(1,max_delay ));

    start_item(t1);
    assert(t1.randomize() with
    {   
        ARREADY==1;
        ARVALID==1;
        RREADY==1;

    });
    t1.print();
    finish_item(t1);

end
endtask

endclass

