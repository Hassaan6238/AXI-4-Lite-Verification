`include "uvm_macros.svh"
import uvm_pkg::*;
import my_pkg::*;

class scoreboard extends uvm_scoreboard;
    uvm_analysis_imp #(transaction, scoreboard) ana_exp;
    `uvm_component_utils(scoreboard)
    transaction exp_queue[$];
    bit[31:0] mem_exp[31:0];

    
    function new(string name, uvm_component parent);
        super.new(name, parent);
        for(int i=0;i<32;++i)
            mem_exp[i]=i;
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        ana_exp = new("ana_port", this);
    endfunction
    
    virtual function void write(transaction m_item);
        if(m_item.S_RREADY && m_item.S_RVALID)
            if(mem_exp[m_item.S_ARADDR] == m_item.S_RDATA)
                `uvm_info(get_type_name(), $sformatf("PASS  exp_value=0x%0h, act_value= 0x%0h at addr %d", mem_exp[m_item.S_ARADDR], m_item.S_RDATA, m_item.S_ARADDR), UVM_LOW)
            else
                `uvm_error(get_type_name(),$sformatf("FAIL exp_value=0x%0h, act_value= 0x%0h at addr %d", mem_exp[m_item.S_ARADDR], m_item.S_RDATA, m_item.S_ARADDR))
            
        
        if(m_item.S_WREADY && m_item.S_WVALID)
        begin
        
            mem_exp[m_item.S_AWADDR]=m_item.S_WDATA;
            `uvm_info(get_type_name(), $sformatf("Data: 0x0%h written at addr 0x%0h", m_item.S_WDATA, m_item.S_AWADDR), UVM_LOW)

        end           



    endfunction
endclass