`include "uvm_macros.svh"
import uvm_pkg::*;
import my_pkg::*;

class my_sequence5 extends uvm_sequence#(transaction);


my_sequence1 seq1;
my_sequence2 seq2;
my_sequence3 seq3;
uvm_sequencer#(transaction) my_sequencer;
// my_sequence4 seq4;

`uvm_object_utils(my_sequence5)

function new(string name ="my_sequence5");
super.new(name);
endfunction



virtual task body();

seq1= my_sequence1::type_id::create("seq1");
seq2= my_sequence2::type_id::create("seq2");
seq3= my_sequence3::type_id::create("seq3");
my_sequencer= new("my_seq", this);
// seq4= my_sequence4::type_id::create("seq4");

assert(seq1.randomize() with
{
    num_reads inside {[5:10]};
});

seq1.start(my_sequencer);

assert(seq2.randomize() with
{
    num_reads inside {[5:10]};
});

seq2.start(my_sequencer);


assert(seq3.randomize() with
{
    num_reads inside {[5:10]};
});

seq3.start(my_sequencer);


// assert(seq4.randomize() with
// {
//     num_reads inside {[5:10]};
// });

// seq4.start(my_sequencer);


endtask

endclass

