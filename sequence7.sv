`include "uvm_macros.svh"
import uvm_pkg::*;
import my_pkg::*;

class my_sequence7 extends uvm_sequence#(transaction);

rand int num_reads;
rand bit[31:0] start_addr;
`uvm_object_utils(my_sequence7)

my_sequence1 seq_read;
my_sequence6 seq_write;

function new(string name ="my_sequence7");
super.new(name);
seq_read=my_sequence1::type_id::create("seq_read");
seq_write=my_sequence6::type_id::create("seq_write");
endfunction



virtual task body();

repeat(num_reads)
begin

    transaction t1;
    t1 = transaction::type_id::create("tr");

    repeat(3)
    
    begin

    start_item(t1);
    assert(t1.randomize() with
    {   
        S_AWADDR == start_addr;
        S_ARVALID==0;
        S_RREADY==1;
        S_AWVALID==1;
        S_WVALID==1;
        S_BREADY==1;

    });
    finish_item(t1);
    
    end

    repeat(2)
    begin

    start_item(t1);

    assert(t1.randomize() with
    {   
        S_ARADDR == start_addr;
        S_ARVALID==1;
        S_RREADY==1;
        S_AWVALID==0;
        S_WVALID==1;
        S_BREADY==1;

    });
    finish_item(t1);
    // t1.print();

    end
    start_addr+=2;
end
endtask

endclass

