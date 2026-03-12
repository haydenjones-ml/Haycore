`timescale 1ns/1ps

module tb_riscv_top;

    reg         clk;
    reg         rst;
    wire        we_dm;
    wire [31:0] pc_current;
    wire [31:0] instr;
    wire [31:0] alu_out;
    wire [31:0] wd_dm;
    wire [31:0] rd_dm;
    wire [31:0] rd3; // Debug port for register file
    
    // Instantiate the top-level processor
    risc_v_top DUT (
        .clk        (clk),
        .rst        (rst),
        .ra3        (5'd4), // Monitor register x4 for our test
        .we_dm      (we_dm),
        .pc_current (pc_current),
        .instr      (instr),
        .alu_out    (alu_out),
        .wd_dm      (wd_dm),
        .rd_dm      (rd_dm),
        .rd3        (rd3)
    );

    // Generate a 10ns clock
    always #5 clk = ~clk;

    initial begin
        // Setup waveform dumping (optional but highly recommended for debugging)
        $dumpfile("riscv_waveform.vcd");
        $dumpvars(0, tb_riscv_top);

        // Initialize signals
        clk = 0;
        rst = 1;
        
        // Hold reset for a few cycles to clear registers
        #15 rst = 0;
        
        // Wait until the PC reaches the infinite loop at address 0x10
        wait(pc_current == 32'h10);
        #10; // Wait one more clock cycle for the final write-back
        
        // --- Self-Checking Assertions --- //
        
        $display("--- RISC-V Test Results ---");
        
        // Check if x4 contains 30 (10 + 20)
        if (rd3 !== 32'd30) begin
            $display("FAILED: Expected Register x4 to be 30, got %0d", rd3);
        end else begin
            $display("PASSED: Register x4 calculated correctly (ADDI & ADD work)");
        end

        // Check if memory address 4 contains 30
        if (DUT.dmem.ram[1] !== 32'd30) begin
            $display("FAILED: Expected Memory Address 4 to hold 30, got %0d", DUT.dmem.ram[1]);
        end else begin
            $display("PASSED: Memory Store operation successful (SW works)");
        end

        $finish;
    end
endmodule

// command to run: iverilog -o riscv_sim src/testbench/tb_risc_v_top.v src/instructions/*.v src/datapath/*.v src/control_unit/*.v src/memory/*.v
