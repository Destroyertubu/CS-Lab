`timescale 1us/1us


module ALU(
    input [31:0] A,
    input [31:0] B,
    input [3:0] op,
    input clk,
    output reg [31:0] result,
    output reg zero,    
    output reg jr_sign,
    input [31:0] programCounter
    );

    
    always @(*) begin
        case(op)
            
            4'b0001:begin
                 result <= A + B;
//                 $display("ALU A = %x, ALU B = %x, PC + 4 = %x", A, B, programCounter);
//                 $display("zero = %x ALU_res = %x My_ALUOp = %x", zero, result, op);
             end

            4'b0010: begin 
                result = A - B;
                zero = (result == 0) ? 1 : 0;
//                $display("subu A = %x, subu B = %x", A, B);
            end

            4'b0011: begin    // lui
//                $display("lui ALU A = %x, ALU B = %x", A, B);
                result <= {B[15:0], {16'b0000000000000000}};
            end
            4'b0100: begin
                result <= A | B;    
//                $display("ALU ori A = %x, B = %x, PC + 4 = %x", A, B, programCounter);
            end
            4'b0101: begin
                result <= A;
            end
            
            4'b1001:begin   // jal
                result <= B + 4;
            end
        endcase
        
    end
endmodule
