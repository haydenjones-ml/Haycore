module alu (
        input  wire [4:0]  op,
        input  wire [31:0] a,
        input  wire [31:0] b,
        output wire        zero,
        output reg  [31:0] y
    );

    assign zero = (y == 0);
    reg [63:0] temp_mult_wire;

    // ALU Operations; for ease of use our "op" signal is our 3 bits funct3 field + the 5th bit of the
    // funct7 field for toggling subtraction, arithmetic shifts (structure: funct7[5]_funct3[2:0])

    always @ (op, a, b) begin
        case (op)
            5'b0_0000: y = a + b;
            5'b1_1000: y = a - b;
            5'b0_0001: y = a << b; // SLL
            5'b0_0010: y = $signed(a) < $signed(b) ? 1 : 0; // SLT(I)
            5'b0_0011: y = a < b ? 1 : 0; // SLTU(I)
            5'b0_0100: y = a ^ b;
            5'b0_0101: y = a >> b; // SRL(I)
            5'b1_1101: y = $signed(a) >>> b; // SRA(I)
            5'b0_0110: y = a | b;
            5'b0_0111: y = a & b;
            // RV32M extension operations
            5'b1_0000: y = a * b; // MUL
            5'b1_0001: begin
                temp_mult_wire = a * b;
                y = temp_mult_wire[63:32]; // MULH
            end
            5'b1_0010: begin
                temp_mult_wire = $signed(a) * $unsigned(b);
                y = temp_mult_wire[63:32]; // MULHSU
            end
            5'b1_0011: begin
                temp_mult_wire = $signed(a) * $signed(b);
                y = temp_mult_wire[63:32]; // MULHU
            end
            5'b1_0100: y = (b == 0) ? 32'hFFFFFFFF : $signed(a) / $signed(b); // DIV
            5'b1_0101: y = (b == 0) ? 32'hFFFFFFFF : a / b; // DIVU
            5'b1_0110: y = (b == 0) ? a : $signed(a) % $signed(b); // REM
            5'b1_0111: y = (b == 0) ? a : a % b; // REMU
            default: y = 32'b0;

        endcase
    end

endmodule