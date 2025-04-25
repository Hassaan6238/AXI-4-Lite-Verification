`include "uvm_macros.svh"
import uvm_pkg::*;
import my_pkg::*;

class my_monitor extends uvm_monitor;

`uvm_component_utils(my_monitor)


virtual dut_if vif;
uvm_analysis_port#(transaction) mon_an_port;
transaction t1;


function new(string name = "my_monitor" , uvm_component parent=null);
super.new(name, parent);
endfunction


virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
if(!uvm_config_db#(virtual dut_if)::get(this, "", "dut_vif", vif))
    `uvm_fatal(get_type_name(), "Couldnt get virtual interface")

mon_an_port= new("Mon_port",this);

endfunction


virtual task run_phase(uvm_phase phase);

    super.run_phase(phase);

    forever begin
   
    t1=transaction::type_id::create("tr");
    @(posedge vif.ACLK);
    fork
    write();
    read();
    join
    $display("[%t] WREADY: %h  WVALID: %h", $time, t1.S_WREADY, t1.S_WVALID);
    $display("vif [%t] WREADY: %h  WVALID: %h", $time, vif.S_WREADY, vif.S_WVALID);

    mon_an_port.write(t1);
    end

endtask

task write();
    
    t1.S_WREADY=vif.S_WREADY;

if(vif.S_AWVALID && vif.S_AWREADY)
begin

    t1.S_AWADDR=vif.S_AWADDR;

    @(posedge vif.ACLK);

    wait(vif.S_WREADY && vif.S_WVALID)
    t1.S_WVALID= vif.S_WVALID;
    t1.S_WDATA= vif.S_WDATA;
    $display("DONE");

end


endtask

task read();

    t1.S_RREADY=vif.S_RREADY;
    t1.S_ARVALID=vif.S_ARVALID;
    t1.S_ARREADY= vif.S_ARREADY;


if(vif.S_ARVALID && vif.S_ARREADY)
begin

    t1.S_ARADDR=vif.S_ARADDR;

@(posedge vif.ACLK);

wait((vif.S_RREADY) && (vif.S_RVALID))

t1.S_RVALID= vif.S_RVALID;
t1.S_RDATA= vif.S_RDATA;
end
endtask
endclass