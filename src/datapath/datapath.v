module datapath (
        input  wire        clk,
        input  wire        rst,
        input  wire        branch,
        input  wire        jump,
        input  wire        reg_dst,
        input  wire        we_reg,
        input  wire        alu_src,
        input  wire [1:0]  result_src,
        input  wire [2:0]  imm_type,
        input  wire [3:0]  alu_ctrl,
        input  wire [4:0]  ra3,
        input  wire [31:0] instr,
        input  wire [31:0] rd_dm,
        output wire [31:0] pc_current,
        output wire [31:0] alu_out,
        output wire [31:0] wd_dm,
        output wire [31:0] rd3
    );

    wire        pc_src;
    wire [31:0] pc_plus4;
    wire [31:0] pc_target;
    wire [31:0] pc_next;
    wire [31:0] ext_imm;
    wire [31:0] alu_pa;
    wire [31:0] alu_pb;
    wire [31:0] wd_rf;
    wire        zero;
    
    assign pc_src = jump | branch & zero;
    
    // --- PC Logic --- //
    dreg pc_reg (
            .clk            (clk),
            .rst            (rst),
            .d              (pc_next),
            .q              (pc_current)
        );

    adder pc_plus_4 (
            .a              (pc_current),
            .b              (32'd4),
            .y              (pc_plus4)
        );

    adder pc_target (
            .a              (pc_current),
            .b              (ext_imm),
            .y              (pc_target)
        );

    // -- Immediate Logic --- //
    imm_gen imm_gen (
            .instr          (instr),
            .imm_type       (imm_type),
            .ext_imm        (ext_imm)
        );

    // --- RF Logic --- //
    regfile rf (
            .clk            (clk),
            .we             (we_reg),
            .ra1            (instr[19:15]),
            .ra2            (instr[24:20]),
            .ra3            (ra3),
            .wa             (instr[11:7]),
            .wd             (wd_rf),
            .rd1            (alu_pa),
            .rd2            (wd_dm),
            .rd3            (rd3),
            .rst            (rst)
        );

    // --- ALU Logic --- //
    mux2 #(32) alu_pb_mux (
            .sel            (alu_src),
            .a              (wd_dm),
            .b              (sext_imm),
            .y              (alu_pb)
        );

    alu alu (
            .op             (alu_ctrl),
            .a              (alu_pa),
            .b              (alu_pb),
            .zero           (zero),
            .y              (alu_out)
        );

    // --- MEM Logic --- // (Changed to accomodate JAL/JALR split)
    assign wd_rf = (result_src == 2'b01) ? rd_dm :
                    (result_src == 2'b10) ? pc_plus4 :
                    alu_out;

endmodule