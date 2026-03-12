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
    // Implement other branch types
    wire        take_branch;

    wire [2:0] funct3 = instr[14:12];
    wire signed [31:0] rs1_signed = alu_pa;
    wire signed [31:0] rs2_signed = alu_pb;

    always @(*) begin
        if (branch) begin
        case(funct3)
            3'b000: take_branch = (rs1_signed == rs2_signed); // BEQ
            3'b001: take_branch = (rs1_signed != rs2_signed); // BNE
            3'b100: take_branch = (rs1_signed < rs2_signed); // BLT
            3'b101: take_branch = (rs1_signed >= rs2_signed); // BGE
            3'b110: take_branch = (alu_pa < alu_pb); // BLTU
            3'b111: take_branch = (alu_pa >= alu_pb); // BGEU
            default: take_branch = 1'b0; // Default case (should not happen)
        endcase
    end else begin
        take_branch = 1'b0;
        end
    end
    
    assign pc_src = jump | take_branch;
    assign pc_next = (pc_src) ? jump : pc_plus4;
    assign pc_jump = jalr ? {alu_out[31:1], 1'b0} : pc_target;
    
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
            .b              (ext_imm),
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