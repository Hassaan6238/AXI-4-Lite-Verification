module axi4_lite_slave_tb();

    // Parameters
    parameter ADDRESS = 32;
    parameter DATA_WIDTH = 32;
    parameter CLK_PERIOD = 10; // 100 MHz clock

    // Signals
    reg ACLK;
    reg ARESETN;
    
    // Read Address Channel
    reg [ADDRESS-1:0] S_ARADDR;
    reg S_ARVALID;
    wire S_ARREADY;
    
    // Read Data Channel
    wire [DATA_WIDTH-1:0] S_RDATA;
    wire [1:0] S_RRESP;
    wire S_RVALID;
    reg S_RREADY;
    
    // Write Address Channel (unused in this testbench)
    reg [ADDRESS-1:0] S_AWADDR;
    reg S_AWVALID;
    wire S_AWREADY;
    
    // Write Data Channel (unused in this testbench)
    reg [DATA_WIDTH-1:0] S_WDATA;
    reg [3:0] S_WSTRB;
    reg S_WVALID;
    wire S_WREADY;
    
    // Write Response Channel (unused in this testbench)
    wire [1:0] S_BRESP;
    wire S_BVALID;
    reg S_BREADY;

    // Instantiate the DUT
    axi4_lite_slave #(
        .ADDRESS(ADDRESS),
        .DATA_WIDTH(DATA_WIDTH))
    dut (
        .ACLK(ACLK),
        .ARESETN(ARESETN),
        
        // Read Address Channel
        .S_ARADDR(S_ARADDR),
        .S_ARVALID(S_ARVALID),
        .S_ARREADY(S_ARREADY),
        
        // Read Data Channel
        .S_RDATA(S_RDATA),
        .S_RRESP(S_RRESP),
        .S_RVALID(S_RVALID),
        .S_RREADY(S_RREADY),
        
        // Write Address Channel
        .S_AWADDR(S_AWADDR),
        .S_AWVALID(S_AWVALID),
        .S_AWREADY(S_AWREADY),
        
        // Write Data Channel
        .S_WDATA(S_WDATA),
        .S_WSTRB(S_WSTRB),
        .S_WVALID(S_WVALID),
        .S_WREADY(S_WREADY),
        
        // Write Response Channel
        .S_BRESP(S_BRESP),
        .S_BVALID(S_BVALID),
        .S_BREADY(S_BREADY)
    );

    // Clock generation
    initial begin
        ACLK = 0;
        forever #(CLK_PERIOD/2) ACLK = ~ACLK;
    end

    // Test procedure
    initial begin
        // Initialize all inputs
        ARESETN = 0;
        S_ARADDR = 0;
        S_ARVALID = 0;
        S_RREADY = 0;
        S_AWADDR = 0;
        S_AWVALID = 0;
        S_WDATA = 0;
        S_WSTRB = 0;
        S_WVALID = 0;
        S_BREADY = 0;
        
        // Reset the system
        #20;
        ARESETN = 1;
        
        // Test 1: Simple read operation
        #10;
        S_ARADDR = 0;       // Read from register 0
        S_ARVALID = 1;
        wait(S_ARREADY);
        #10;
        S_ARVALID = 0;
        
        // Wait for read data to be valid
        wait(S_RVALID);
        S_RREADY = 1;
        #10;
        $display("Read from address 0: Data = %h", S_RDATA);
        S_RREADY = 0;
        
        // Test 2: Read from multiple registers
        for (int i = 0; i < 8; i++) begin
            #10;
            S_ARADDR = i*4;  // Addresses are typically byte-based
            S_ARVALID = 1;
            wait(S_ARREADY);
            #10;
            S_ARVALID = 0;
            
            wait(S_RVALID);
            S_RREADY = 1;
            #10;
            $display("Read from address %d: Data = %h", i*4, S_RDATA);
            S_RREADY = 0;
        end
        
        // Test 3: Back-to-back read operations
        #10;
        S_ARADDR = 16;      // Read from register 4
        S_ARVALID = 1;
        wait(S_ARREADY);
        #10;
        S_ARADDR = 20;      // Read from register 5
        wait(S_ARREADY);
        #10;
        S_ARVALID = 0;
        
        // Handle the read responses
        wait(S_RVALID);
        S_RREADY = 1;
        #10;
        $display("Read from address 16: Data = %h", S_RDATA);
        wait(S_RVALID);
        #10;
        $display("Read from address 20: Data = %h", S_RDATA);
        S_RREADY = 0;
        
        // End simulation
        #100;
        $display("Simulation complete");
        $finish;
    end

    // Monitor to track the AXI transactions
    // initial begin
    //     $monitor("Time = %t: State = %s, ARADDR = %h, ARVALID = %b, ARREADY = %b, RDATA = %h, RVALID = %b, RREADY = %b",
    //         $time, dut.state.name(), S_ARADDR, S_ARVALID, S_ARREADY, S_RDATA, S_RVALID, S_RREADY);
    // end

endmodule