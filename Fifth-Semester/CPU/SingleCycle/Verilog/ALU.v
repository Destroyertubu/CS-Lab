`timescale 1ns/1ps


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
//                 $display("ALU A = %x, ALU B = %x, PC = %x", A, B, programCounter);
//                 $display("zero = %x ALU_res = %x My_ALUOp = %x", zero, result, op);
             end

            4'b0010: begin 
                result = A - B;
                zero = (result == 0) ? 1 : 0;
                $display("subu A = %x, subu B = %x", A, B);
            end

            4'b0011: begin    // lui
//                $display("ALU A = %x, ALU B = %x", A, B);
                result <= {A[15:0], {16'b0000000000000000}};
            end
            4'b0100: begin
                result <= A | B;    
//                $display("ALU ori res = %x", result);
            end
            4'b0101: begin
                result <= A;
            end
        endcase
        
    end
    
    

    
    
    always @(*) begin
        
    end
endmodule
