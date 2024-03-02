`timescale 1us/1us


module ALU(
    input [31:0] A,
    input [31:0] B,
    input [3:0] op,
    output reg [31:0] result,
    output reg zero,    
    output reg jr_sign,
    output reg overflow,
    input [31:0] programCounter
    );
    
    wire signed [31:0] sa = A;
    wire signed [31:0] sb = B;
    
    
    parameter Addu = 4'b0001;
    parameter Subu = 4'b0010;
    parameter Lui = 4'b0011;
    parameter Ori = 4'b0100;
    parameter Sll = 4'b0101;    // contain the sllv
    parameter Add = 4'b0110;
    parameter Sub = 4'b0111;
    parameter Slti = 4'b1000;   // 
    parameter Jal = 4'b1001;
    parameter Andi = 4'b1010;   // contain the and
    parameter Xori = 4'b1011;   // contain the xor
    parameter Srl = 4'b1100;    // contain the srlv
    parameter Sra = 4'b1101;    // contain the srav
    parameter Nor_ = 4'b1110;   // contain the nori
    parameter Sltu = 4'b1111;   // contain the Sltui
    
    
    always @(*) begin
        overflow = 0;
        zero = 0;
        case(op)
            
            Addu: begin      // addu
                 result = A + B;
//                 $display("ALU A = %x, ALU B = %x, PC + 4 = %x", A, B, programCounter);
//                 $display("zero = %x ALU_res = %x My_ALUOp = %x", zero, result, op);
             end

            Subu: begin      // subu
                result = A - B;
                zero = (result == 0) ? 1 : 0;
//                $display("subu A = %x, subu B = %x", A, B);
            end

            Lui: begin    // lui
//                $display("lui ALU A = %x, ALU B = %x", A, B);
                result = {B[15:0], {16'b0000000000000000}};
            end
            
            Ori: begin     // ori
                result = A | B;    
//                $display("ALU ori A = %x, B = %x, PC + 4 = %x", A, B, programCounter);
            end
            
            Sll: begin     // 
                result = B << A[4:0];
                $display("SLL B = %x, A = %x", B, A);
            end
            
            Add: begin      // add
                result = sa + sb;
                overflow = ((sa[31] == 0 && sb[31] == 0 && result[31] == 1) || (sa[31] == 1 && sb[31] == 1 && result[31] == 0));
            end
            
            Sub: begin   // sub
                result = sa - sb;
                overflow = ((sa[31] == 0 && sb[31] == 1 && result[31] == 1) || (sa[31] == 1 && sb[31] == 0 && result[31] == 0));
            end
            
            Jal: begin   // jal  jalr
                result = B + 4;
            end
            
            Slti: begin     // Slt's act is the same 
                if (sa < sb)
                    begin
                        result = 1'b1;
                    end
                else   
                    begin
                        result = 1'b0;
                    end
            end 
            
            Andi: begin
                result = sa & sb;
            end
            
            Xori: begin
                result = A ^ B;
            end
            
            Srl: begin
                result = B >> A[4:0];
            end
            
            Sra: begin
//                $display("SRA number = %x", sb);
                result = sb >>> A[4:0];
            end
            
            Nor_: begin
                result = ~(B | A);
            end
            
            Sltu: begin
                if (A < B)
                    begin
                        result = 1'b1;
                    end
                else   
                    begin
                        result = 1'b0;
                    end                
            end
        endcase
    end
    
    
endmodule
