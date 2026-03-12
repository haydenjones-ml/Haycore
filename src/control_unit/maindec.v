module maindec (
    input  wire [6:0] opcode,
    output wire       branch,
    output wire       jump,
    output wire       jalr,
    output wire       we_reg,
    output wire       alu_src,
    output wire       we_dm,
    output wire [1:0] result_src, // 00=ALU, 01=Mem, 10=PC+4
    output wire [2:0] imm_type,
    output wire [1:0] alu_op
);

    reg [12:0] ctrl;
    assign {branch, jump, jalr, we_reg, alu_src, we_dm, result_src, imm_type, alu_op} = ctrl;

    always @(*) begin
        case (opcode)
            7'b0110011: ctrl = 13'b0_0_0_1_0_0_00_000_10; // R-type
            7'b0010011: ctrl = 13'b0_0_0_1_1_0_00_000_11; // I-type
            7'b0000011: ctrl = 13'b0_0_0_1_1_0_01_000_00; // Loads
            7'b0100011: ctrl = 13'b0_0_0_0_1_1_00_001_00; // Saves
            7'b1100011: ctrl = 13'b1_0_0_0_0_0_00_010_01; // Branches
            7'b1101111: ctrl = 13'b0_1_0_1_0_0_10_011_xx; // JAL
            7'b1100111: ctrl = 13'b0_0_1_1_1_0_00_000_11; // JALR
            default:     ctrl = 13'bx_x_x_x_x_xx_xxx_xx; 
        endcase
    end
endmodule