//TODO: Rework testbench to add more test cases for other instruction types, 

//TODO: Rework testbench to add more test cases for other instruction types, 

`timescale 1ns / 1ps

module tb_riscv();
    reg         clk;
    reg         rst;
    wire [31:0] pc_current;
    
    risc_v_top dut (
        .clk        (clk),
        .rst        (rst),
        .pc_current (pc_current)
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

        // Testing using hierarchical referencing (x-ray vision)
        if (dut.risc_v.dp.rf.rf[1] == 32'd10 && dut.risc_v.dp.rf.rf[2] == 32'd3) begin
            $display("[PASS] ADDI  - Immediate Setup");
            tests_passed = tests_passed + 1;
        end else $display("[FAIL] ADDI  - Expected x1=10, x2=3. Got x1=%0d, x2=%0d", dut.risc_v.dp.rf.rf[1], dut.risc_v.dp.rf.rf[2]);

        if (dut.risc_v.dp.rf.rf[3] == 32'd30) begin
            $display("[PASS] MUL   - RV32M Multiplication");
            tests_passed = tests_passed + 1;
        end else $display("[FAIL] MUL   - Expected x3=30. Got x3=%0d", dut.risc_v.dp.rf.rf[3]);

        if (dut.risc_v.dp.rf.rf[4] == 32'd30) begin
            $display("[PASS] SW/LW - Memory Store and Load");
            tests_passed = tests_passed + 1;
        end else $display("[FAIL] SW/LW - Expected x4=30. Got x4=%0d", dut.risc_v.dp.rf.rf[4]);

        if (dut.risc_v.dp.rf.rf[5] == 32'd20) begin
            $display("[PASS] SUB   - Register Subtraction");
            tests_passed = tests_passed + 1;
        end else $display("[FAIL] SUB   - Expected x5=20. Got x5=%0d", dut.risc_v.dp.rf.rf[5]);

        if (dut.risc_v.dp.rf.rf[6] == 32'd6) begin
            $display("[PASS] DIV   - RV32M Division");
            tests_passed = tests_passed + 1;
        end else $display("[FAIL] DIV   - Expected x6=6. Got x6=%0d", dut.risc_v.dp.rf.rf[6]);

        if (dut.risc_v.dp.rf.rf[7] == 32'd2) begin
            $display("[PASS] REM   - RV32M Remainder");
            tests_passed = tests_passed + 1;
        end else $display("[FAIL] REM   - Expected x7=2. Got x7=%0d", dut.risc_v.dp.rf.rf[7]);

        if (dut.risc_v.dp.rf.rf[8] == 32'd48) begin
            $display("[PASS] BNE   - Branching Logic");
            $display("[PASS] JAL   - Jump & Link (Return Address Correct)");
            tests_passed = tests_passed + 2;
        end else $display("[FAIL] BNE/JAL - Expected x8=48. Got x8=%0d", dut.risc_v.dp.rf.rf[8]);

        if (tests_passed == 8) begin
            $display("  STATUS: ALL 8 TESTS PASSED!");
        end else begin
            $display("  STATUS: %0d/8 TESTS PASSED. CHECK FAILED LOGS.", tests_passed);
        end

        $finish;
    end

endmodule

// command to run: iverilog -o riscv_sim src/testbench/tb_risc_v_top.v src/instructions/*.v src/datapath/*.v src/control_unit/*.v src/memory/*.v