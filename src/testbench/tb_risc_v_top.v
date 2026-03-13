//TODO: Rework testbench to add more test cases for other instruction types, 

`timescale 1ns / 1ps

module tb_riscv();

    reg         clk;
    reg         rst;
    wire [31:0] pc_current;
    
    // Catch-all debug wires for register outputs (x1-x8) for tracking
    wire [31:0] out_x1, out_x2, out_x3, out_x4;
    wire [31:0] out_x5, out_x6, out_x7, out_x8;
    
    risc_v_top dut (
        .clk        (clk),
        .rst        (rst),
        .pc_current (pc_current),
        .dbg_x1     (out_x1),
        .dbg_x2     (out_x2),
        .dbg_x3     (out_x3),
        .dbg_x4     (out_x4),
        .dbg_x5     (out_x5),
        .dbg_x6     (out_x6),
        .dbg_x7     (out_x7),
        .dbg_x8     (out_x8)
    );

    // Generate a 10ns clock period
    always #5 clk = ~clk; 

    integer tests_passed = 0;

    initial begin
        $display("  STARTING RISC-V RV32IM VERIFICATION   ");
        
        clk = 0;
        rst = 1;

        #20;
        rst = 0;

        // Wait for the program to finish
        wait(pc_current == 32'h00000034);
        #10; 

        $display("\n--- INSTRUCTION TEST RESULTS ---");

        // Testing using purely physical wire connections
        if (out_x1 == 32'd10 && out_x2 == 32'd3) begin
            $display("[PASS] ADDI  - Immediate Setup");
            tests_passed = tests_passed + 1;
        end else $display("[FAIL] ADDI  - Expected x1=10, x2=3. Got x1=%0d, x2=%0d", out_x1, out_x2);

        if (out_x3 == 32'd30) begin
            $display("[PASS] MUL - RV32M Multiplication");
            tests_passed = tests_passed + 1;
        end else $display("[FAIL] MUL - Expected x3=30. Got x3=%0d", out_x3);

        if (out_x4 == 32'd30) begin
            $display("[PASS] SW/LW - Memory Store and Load");
            tests_passed = tests_passed + 1;
        end else $display("[FAIL] SW/LW - Expected x4=30. Got x4=%0d", out_x4);

        if (out_x5 == 32'd20) begin
            $display("[PASS] SUB - Register Subtraction");
            tests_passed = tests_passed + 1;
        end else $display("[FAIL] SUB - Expected x5=20. Got x5=%0d", out_x5);

        if (out_x6 == 32'd6) begin
            $display("[PASS] DIV - RV32M Division");
            tests_passed = tests_passed + 1;
        end else $display("[FAIL] DIV   - Expected x6=6. Got x6=%0d", out_x6);

        if (out_x7 == 32'd2) begin
            $display("[PASS] REM   - RV32M Remainder");
            tests_passed = tests_passed + 1;
        end else $display("[FAIL] REM   - Expected x7=2. Got x7=%0d", out_x7);

        if (out_x8 == 32'd48) begin
            $display("[PASS] BNE   - Branching Logic");
            $display("[PASS] JAL   - Jump & Link (Return Address Correct)");
            tests_passed = tests_passed + 2;
        end else $display("[FAIL] BNE/JAL - Expected x8=48. Got x8=%0d", out_x8);

        if (tests_passed == 8) begin
            $display("  STATUS: ALL 8 TESTS PASSED!");
        end else begin
            $display("  STATUS: %0d/8 TESTS PASSED. CHECK FAILED LOGS.", tests_passed);
        end

        $finish;
    end

endmodule

// command to run: iverilog -o riscv_sim src/testbench/tb_risc_v_top.v src/instructions/*.v src/datapath/*.v src/control_unit/*.v src/memory/*.v
