module auxdec (
        input  wire [1:0] alu_op,
        input  wire [2:0] funct3,
        input  wire       funct7_5,
        output wire [3:0] alu_ctrl
    );

    reg [3:0] ctrl;
    assign alu_ctrl = ctrl;

wire valid_modifier = (alu_op == 2'b10) || (alu_op == 2'b11 && funct3 == 3'b101);
    
    // Combine the validated modifier bit and funct3 into a single 4-bit wire
    wire [3:0] aux_op = {valid_modifier ? funct7_b5 : 1'b0, funct3};

    always @(*) begin
        case (alu_op)
            2'b00: ctrl = 4'b0000; // Memory address calculation (Force ADD)
            2'b01: ctrl = 4'b1000; // Branch equality comparison (Force SUB)
            
            // alu_op 10 (R-Type) or 11 (I-Type Math)
            default: begin 
                case (aux_op)
                    4'b0_000: ctrl = 4'b0000;
                    4'b1_000: ctrl = 4'b1000;
                    4'b0_001: ctrl = 4'b0001;
                    4'b0_010: ctrl = 4'b0010;
                    4'b0_011: ctrl = 4'b0011;
                    4'b0_100: ctrl = 4'b0100;
                    4'b0_101: ctrl = 4'b0101;
                    4'b1_101: ctrl = 4'b1101;
                    4'b0_110: ctrl = 4'b0110;
                    4'b0_111: ctrl = 4'b0111;
                    default:  ctrl = 4'bxxxx;
                endcase
            end
        endcase
    end

endmodule