`include "uvm_macros.svh"
import uvm_pkg::*;
import my_pkg::*;

class basic_test extends uvm_test;
  `uvm_component_utils(basic_test)

  my_sequence1 seq1;
  my_sequence2 seq2;
  my_sequence3 seq3;
  my_sequence6 seq6;
  my_sequence7 seq7;
  my_env e1;
  virtual dut_if vif; 

  function new(string name="basic_test", uvm_component parent= null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    e1= my_env::type_id::create("e1", this);
    seq1 = my_sequence1::type_id::create("seq1"); 
    seq2 = my_sequence2::type_id::create("seq2"); 
    seq3 = my_sequence3::type_id::create("seq3"); 
    seq6 = my_sequence6::type_id::create("seq6"); 
    seq7 = my_sequence7::type_id::create("seq7"); 
  
  if(!uvm_config_db#(virtual dut_if)::get(this,"","dut_vif",vif))
    `uvm_fatal(get_type_name(), "Didnt get virtual Interface")


uvm_config_db#(virtual dut_if)::set(this,"e1.a1.*","dut_vif",vif);

  
  endfunction



  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    `uvm_info("TEST", "Starting sequence", UVM_MEDIUM)
    
    // Proper way to start a sequence
    apply_reset();
    assert(seq1.randomize() with {
      num_reads inside {[50:100]};

    });

    // seq1.start(e1.a1.s1);  // Start sequence on the sequencer
    
    assert(seq2.randomize() with {
      num_reads inside{[50:100]};
    })

    // seq2.start(e1.a1.s1);

    assert(seq3.randomize() with{
      num_reads inside {[50:100]};
    })

    // seq3.start(e1.a1.s1);

    assert(seq6.randomize() with{
      num_reads inside {[50:100]};
    })

    // seq6.start(e1.a1.s1);

    assert(seq7.randomize() with{
      num_reads inside {[50:100]};
    })

    seq7.start(e1.a1.s1);

    phase.drop_objection(this);
  endtask


virtual task apply_reset();

vif.ARESETN<=0;
repeat(5) @(posedge vif.ACLK);
vif.ARESETN<=1;
repeat(10) @(posedge vif.ACLK);

endtask



endclass

module tb_t1;

    bit clk;
    dut_if axi_intf(clk);

    axi4_lite_slave
    dut ( axi_intf
        // .ACLK(axi_intf.ACLK),
        // .ARESETN(axi_intf.ARESETN),
        
        // // Read Address Channel
        // .S_ARADDR(axi_intf.S_ARADDR),
        // .S_ARVALID(axi_intf.S_ARVALID),
        // .S_ARREADY(axi_intf.S_ARREADY),
        
        // // Read Data Channel
        // .S_RDATA(axi_intf.S_RDATA),
        // .S_RRESP(axi_intf.S_RRESP),
        // .S_RVALID(axi_intf.S_RVALID),
        // .S_RREADY(axi_intf.S_RREADY),
        
        // // Write Address Channel
        // .S_AWADDR(0),
        // .S_AWVALID(0),
        // .S_AWREADY(axi_intf.S_AWREADY),
        
        // // Write Data Channel
        // .S_WDATA(0),
        // .S_WSTRB(0),
        // .S_WVALID(0),
        // .S_WREADY(axi_intf.S_WREADY),
        
        // // Write Response Channel
        // // .S_BRESP(S_BRESP),
        // // .S_BVALID(S_BVALID),
        // .S_BREADY(0)
    );

    always  begin
        #10
        clk=~clk;
    end


  initial begin
    uvm_config_db#(virtual dut_if)::set(null,"*","dut_vif", axi_intf);
    run_test("basic_test");
  end




endmodule