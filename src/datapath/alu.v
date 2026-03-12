module alu (
        input  wire [3:0]  op,
        input  wire [31:0] a,
        input  wire [31:0] b,
        output wire        zero,
        output reg  [31:0] y
    );

    assign zero = (y == 0);

    // ALU Operations; for ease of use our "op" signal is our 3 bits funct3 field + the 5th bit of the
    // funct7 field for toggling subtraction, arithmetic shifts (structure: funct7[5]_funct3[2:0])

    // TODO: expand op signal to 5-bits; include instructions in RV32M extension
    always @ (op, a, b) begin
        case (op)
            4'b0000: y = a + b;
            4'b1000: y = a - b;
            4'b0001: y = a << b; // SLL
            4'b0010: y = $signed(a) < $signed(b) ? 1 : 0; // SLT(I)
            4'b0011: y = a < b ? 1 : 0; // SLTU(I)
            4'b0100: y = a ^ b;
            4'b0101: y = a >> b; // SRL(I)
            4'b1101: y = $signed(a) >>> b; // SRA(I)
            4'b0110: y = a | b;
            4'b0111: y = a & b;
            default: y = 32'b0;
        endcase
    end

endmodule