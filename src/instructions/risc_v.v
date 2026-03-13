module risc_v (
        input  wire        clk,
        input  wire        rst,
        input  wire [4:0]  ra3,
        input  wire [31:0] instr,
        input  wire [31:0] rd_dm,
        output wire        we_dm,
        output wire [31:0] pc_current,
        output wire [31:0] alu_out,
        output wire [31:0] wd_dm,
        output wire [31:0] rd3
    );
    
    wire       branch;
    wire       jump;
    wire       jalr;
    wire       reg_dst;
    wire       we_reg;
    wire       alu_src;
    wire [1:0] result_src;
    wire [2:0] imm_type;
    wire [4:0] alu_ctrl;

    datapath dp (
            .clk            (clk),
            .rst            (rst),
            .branch         (branch),
            .jump           (jump),
            .jalr           (jalr),
            .we_reg         (we_reg),
            .alu_src        (alu_src),
            .result_src     (result_src),
            .imm_type       (imm_type),
            .alu_ctrl       (alu_ctrl),
            .ra3            (ra3),
            .instr          (instr),
            .rd_dm          (rd_dm),
            .pc_current     (pc_current),
            .alu_out        (alu_out),
            .wd_dm          (wd_dm),
            .rd3            (rd3)
        );

    controlunit cu (
            .opcode         (instr[6:0]),
            .funct3          (instr[14:12]),
            .funct7_5_bit   (instr[30]),
            .funct7_0_bit   (instr[25]),
            .branch         (branch),
            .jump           (jump),
            .jalr           (jalr),
            .we_reg         (we_reg),
            .alu_src        (alu_src),
            .we_dm          (we_dm),
            .result_src     (result_src),
            .imm_type       (imm_type),
            .alu_ctrl       (alu_ctrl)
        );

endmodule