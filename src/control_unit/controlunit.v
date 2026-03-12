module controlunit (
        input  wire [6:0]  opcode,
        input  wire [2:0]  funct3,
        input  wire        funct7_5_bit,
        output wire        branch,
        output wire        jump,
        output wire        jalr,
        output wire        we_reg,
        output wire        alu_src,
        output wire        we_dm,
        output wire        dm2reg,
        output wire [3:0]  alu_ctrl
    );
    
    wire [1:0] alu_op;

    maindec md (
        .opcode         (opcode),
        .branch         (branch),
        .jump           (jump),
        .jalr           (jalr),
        .we_reg         (we_reg),
        .alu_src        (alu_src),
        .we_dm          (we_dm),
        .dm2reg         (dm2reg),
        .alu_op         (alu_op)
    );

    auxdec ad (
        .alu_op         (alu_op),
        .funct3         (funct3),
        .funct7_5_bit   (funct7_5_bit),
        .alu_ctrl       (alu_ctrl)
    );

endmodule