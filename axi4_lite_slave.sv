//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/04/2024 05:52:55 PM
// Design Name: 
// Module Name: axi4_lite_slave
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module axi4_lite_slave #(
    parameter ADDRESS = 5,
    parameter DATA_WIDTH = 32
    )
    (
        dut_if intf
        // //Global Signals
        // input                           ACLK,
        // input                           ARESETN,

        // ////Read Address Channel INPUTS
        // input           [ADDRESS-1:0]   S_ARADDR,
        // input                           S_ARVALID,
        // //Read Data Channel INPUTS
        // input                           S_RREADY,
        // //Write Address Channel INPUTS
        // /* verilator lint_off UNUSED */
        // input           [ADDRESS-1:0]   S_AWADDR,
        // input                           S_AWVALID,
        // //Write Data  Channel INPUTS
        // input          [DATA_WIDTH-1:0] S_WDATA,
        // input          [3:0]            S_WSTRB,
        // input                           S_WVALID,
        // //Write Response Channel INPUTS
        // input                           S_BREADY,	

        // //Read Address Channel OUTPUTS
        // output logic                    S_ARREADY,
        // //Read Data Channel OUTPUTS
        // output logic    [DATA_WIDTH-1:0]S_RDATA,
        // output logic         [1:0]      S_RRESP,
        // output logic                    S_RVALID,
        // //Write Address Channel OUTPUTS
        // output logic                    S_AWREADY,
        // output logic                    S_WREADY,
        // //Write Response Channel OUTPUTS
        // output logic         [1:0]      S_BRESP,
        // output logic                    S_BVALID
    );

    localparam no_of_registers = 32;

    logic [DATA_WIDTH-1 : 0] register_data [no_of_registers-1 : 0];
    logic [ADDRESS-1 : 0]    addr;
    logic [ADDRESS-1 : 0]    w_addr;
    logic  write_addr;
    logic  write_data;

    typedef enum logic [2 : 0] {IDLE,WRITE_CHANNEL,WRESP__CHANNEL, RADDR_CHANNEL, WADDR_CHANNEL, RDATA__CHANNEL} state_type;
    state_type state , next_state;

    // AR
    assign intf.S_ARREADY = (state == RADDR_CHANNEL) ? 1 : 0;
    assign intf.S_AWREADY = (state == WADDR_CHANNEL) ? 1 : 0;
    // 
    assign intf.S_RVALID = (state == RDATA__CHANNEL) ? 1 : 0;
    assign intf.S_RDATA  = (state == RDATA__CHANNEL) ? register_data[addr] : 0;
    assign intf.S_RRESP  = (state == RDATA__CHANNEL) ?2'b00:0;
    // AW
    // assign intf.S_AWREADY = (state == WRITE_CHANNEL) ? 1 : 0;
    // W
    assign intf.S_WREADY = (state == WRITE_CHANNEL) ? 1 : 0;
    assign write_addr = intf.S_AWVALID && intf.S_AWREADY;
    assign write_data = intf.S_WREADY && intf.S_WVALID;
    // B
    assign intf.S_BVALID = (state == WRESP__CHANNEL) ? 1 : 0;
    assign intf.S_BRESP  = (state == WRESP__CHANNEL )? 0:0;

    integer i;

    always_ff @(posedge intf.ACLK) begin
        // Reset the register array
        if (~(intf.ARESETN)) begin
            for (i = 0; i < 32; i++) begin
                register_data[i] <= i;
            end
            addr<=0;
            w_addr<=0;

        end
        else begin


            if (state == WRITE_CHANNEL) begin
                register_data[w_addr] <= intf.S_WDATA;
            end

            else if(state == WADDR_CHANNEL )
                w_addr<= intf.S_AWADDR;

            else if (state == RADDR_CHANNEL) begin
                addr <= intf.S_ARADDR;
            end
        end
    end

    always_ff @(posedge intf.ACLK) begin
        if (!(intf.ARESETN)) begin
            state <= IDLE;
        end
        else begin
            state <= next_state;
        end
    end

    always_comb begin
		case (state)
            IDLE : begin
                if (intf.S_AWVALID) begin
                    next_state = WADDR_CHANNEL;
                end 
                else if (intf.S_ARVALID) begin
                    next_state = RADDR_CHANNEL;
                end 
                else begin
                    next_state = IDLE;
                end
            end
            RADDR_CHANNEL   : if (intf.S_ARVALID && intf.S_ARREADY ) next_state = RDATA__CHANNEL;
            WADDR_CHANNEL   : if (intf.S_AWVALID && intf.S_AWREADY ) next_state = WRITE_CHANNEL;
            RDATA__CHANNEL  : if (intf.S_RVALID  && intf.S_RREADY  ) next_state = IDLE;
            WRITE_CHANNEL   : if (write_data) next_state = WRESP__CHANNEL;
            WRESP__CHANNEL  : if (intf.S_BVALID  && intf.S_BREADY  ) next_state = IDLE;
            default : next_state = IDLE;
        endcase
    end
endmodule