module auxdec (
        input  wire [1:0] alu_op,
        input  wire [2:0] funct3,
        input  wire       funct7_5_bit,
        input  wire       funct7_0_bit,
        output wire [4:0] alu_ctrl
    );

    reg [4:0] ctrl;
    assign alu_ctrl = ctrl;

wire valid_modifier = (alu_op == 2'b10) || (alu_op == 2'b11 && funct3 == 3'b101);
    
    // Combine the validated modifier bit and funct3 into a single 4-bit wire
    wire [3:0] aux_op = {valid_modifier ? funct7_5_bit : 1'b0, funct3};

    always @(*) begin
        case (alu_op)
            2'b00: ctrl = 5'b00000; // Memory address calculation (Force ADD)
            2'b01: ctrl = 5'b01000; // Branch equality comparison (Force SUB)
            
            // alu_op 10 (R-Type) or 11 (I-Type Math)
            default: begin 
            // NEW BLOCK: R-Type instruction AND RV32M instructions
            if (alu_op == 2'b10 && funct7_0_bit) begin
                case(funct3)
                    3'b000: ctrl = 5'b10000;
                    3'b001: ctrl = 5'b10001;
                    3'b010: ctrl = 5'b10010;
                    3'b011: ctrl = 5'b10011;
                    3'b100: ctrl = 5'b10100;
                    3'b101: ctrl = 5'b10101;
                    3'b110: ctrl = 5'b10110;
                    3'b111: ctrl = 5'b10111;
                    default: ctrl = 5'bxxxxx;
                endcase
            end else begin
                case (aux_op)
                    4'b0_000: ctrl = 5'b00000;
                    4'b1_000: ctrl = 5'b01000;
                    4'b0_001: ctrl = 5'b00001;
                    4'b0_010: ctrl = 5'b00010;
                    4'b0_011: ctrl = 5'b00011;
                    4'b0_100: ctrl = 5'b00100;
                    4'b0_101: ctrl = 5'b00101;
                    4'b1_101: ctrl = 5'b01101;
                    4'b0_110: ctrl = 5'b00110;
                    4'b0_111: ctrl = 5'b00111;
                    default:  ctrl = 5'bxxxxx;
                endcase
            end
        end
    endcase
end

endmodule