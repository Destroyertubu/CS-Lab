`timescale 1us/1us

`include "MyStructure.sv"

module CU(
    input [5:0] opcode,
    input [5:0] func,
    input [31:0] ins,
    input [2:0] CU_wr,
    output ControlSignal cs
);


    
    always @(opcode or func) begin 
        cs.ins <= ins;
//        $display("CU opcode = %x£¬ func = %x", opcode, func);
        if (CU_wr == 3'b111)
            begin
//               $display("CU_wr 111");
               case (opcode)
                6'b000000: begin     // addu, subu, jr
                        case (func)
                            6'b100001: begin 
                                cs.jal <= 1'b0;
                                cs.jr <= 1'b0;
                                cs.Branch <= 1'b0;
                                cs.MemoToReg <= 1'b0;
                                cs.MemoRead <= 1'b0;
                                cs.MemoWrite <= 1'b0;
                                cs.regDst <= 3'b001;
                                cs.regWrite <= 1'b1;
                                cs.alu_op_code <= 4'b0001;
                                cs.alu_src <= 1'b1;
                                cs.jal_reg <= 5'b00000;
                                cs.lui_mark <= 1'b1;
                                cs.j <= 1'b0;
                                cs.opcode <= opcode;
                                cs.funct <= func;
                            end
                            6'b100011: begin
                                cs.jal <= 1'b0;
                                cs.jr <= 1'b0;
                                cs.Branch <= 1'b0;
                                cs.MemoToReg <= 1'b0;
                                cs.MemoRead <= 1'b0;
                                cs.MemoWrite <= 1'b0;
                                cs.regDst <= 3'b001;
                                cs.regWrite <= 1'b1;
                                cs.alu_op_code <= 4'b0010;
                                cs.alu_src <= 1'b1;
                                cs.jal_reg <= 5'b00000;
                                cs.lui_mark <= 1'b1;
                                cs.j <= 1'b0;
                                cs.opcode <= opcode;
                                cs.funct <= func;
                            end 
                            6'b001000: begin 
                                cs.jal <= 1'b0;
                                cs.jr <= 1'b1;
                                cs.Branch <= 1'b0;
                                cs.MemoToReg <= 1'b0;
                                cs.MemoRead <= 1'b0;
                                cs.MemoWrite <= 1'b0;
                                cs.regDst <= 3'b001;
                                cs.regWrite <= 1'b0;
                                cs.alu_op_code <= 4'b0001;
                                cs.alu_src <= 1'b1;
                                cs.jal_reg <= 5'b00000;
                                cs.lui_mark <= 1'b1;
                                cs.j <= 1'b0;
                                cs.opcode <= opcode;
                                cs.funct <= func;
                            end
                            6'b001100: begin
                                $finish;
                            end
                            endcase
        //            $display("addu, subu, jr");
                end
        
                6'b001101: begin    // ori
                    // $display("ori");
                    cs.jal <= 1'b0;
                    cs.jr <= 1'b0;
                    cs.Branch <= 1'b0;
                    cs.MemoToReg <= 1'b0;
                    cs.MemoRead <= 1'b0;
                    cs.MemoWrite <= 1'b0;
                    cs.regDst <= 3'b010;
                    cs.regWrite <= 1'b1;
                    cs.alu_op_code <= 4'b0100;
                    cs.alu_src <= 1'b0;
                    cs.jal_reg <= 5'b00000;
                    cs.lui_mark <= 1'b1;
                    cs.j <= 1'b0;
                    cs.opcode <= opcode;
                    cs.funct <= func;
                end
        
                6'b100011: begin    // lw
                    cs.jal <= 1'b0;
                    cs.jr <= 1'b0;
                    cs.Branch <= 1'b0;
                    cs.MemoToReg <= 1'b1;
                    cs.MemoRead <= 1'b1;
                    cs.MemoWrite <= 1'b0;
                    cs.regDst <= 3'b010;
                    cs.regWrite <= 1'b1;
                    cs.alu_op_code <= 4'b0001;
                    cs.alu_src <= 1'b0;
                    cs.jal_reg <= 5'b00000;
                    cs.lui_mark <= 1'b1;
                    cs.j <= 1'b0;
                    cs.opcode <= opcode;
                    cs.funct <= func;
                end
        
                6'b101011: begin    // sw
                    cs.jal <= 1'b0;
                    cs.jr <= 1'b0;
                    cs.Branch <= 1'b0;
                    cs.MemoToReg <= 1'b0;
                    cs.MemoRead <= 1'b0;
                    cs.MemoWrite <= 1'b1;
                    cs.regDst <= 3'b010;
                    cs.regWrite <= 1'b0;
                    cs.alu_op_code <= 4'b0001;
                    cs.alu_src <= 1'b0;
                    cs.jal_reg <= 5'b00000;
                    cs.lui_mark <= 1'b1;
                    cs.j <= 1'b0;
                    cs.opcode <= opcode;
                    cs.funct <= func;
                end
        
        
                6'b000100: begin    // beq
//                    $display("BEQ BRANCH ins = %x", ins);
                    cs.jal <= 1'b0;
                    cs.jr <= 1'b0;
                    cs.Branch <= 1'b1;
                    cs.MemoToReg <= 1'b0;
                    cs.MemoRead <= 1'b0;
                    cs.MemoWrite <= 1'b0;
                    cs.regDst <= 3'b000;
                    cs.regWrite <= 1'b0;
                    cs.alu_op_code <= 4'b0010;
                    cs.alu_src <= 1'b1;
                    cs.jal_reg <= 5'b00000;
                    cs.lui_mark <= 1'b1;
                    cs.j <= 1'b0;
                    cs.opcode <= opcode;
                    cs.funct <= func;
                end
        
                6'b001111: begin    //   lui
        
                    cs.jal <= 1'b0;
                    cs.jr <= 1'b0;
                    cs.Branch <= 1'b0;
                    cs.MemoToReg <= 1'b0;
                    cs.MemoRead <= 1'b0;
                    cs.MemoWrite <= 1'b0;
                    cs.regDst <= 3'b010;
                    cs.regWrite <= 1'b1;
                    cs.alu_op_code <= 4'b0011;
                    cs.alu_src <= 1'b0;
                    cs.jal_reg <= 5'b00000;
                    cs.lui_mark <= 1'b1;
                    cs.j <= 1'b0;
                    cs.opcode <= opcode;
                    cs.funct <= func;
                end
         
                6'b000011: begin   // jal
                    cs.jal <= 1'b1;
                    cs.jr <= 1'b0;
                    cs.Branch <= 1'b0;
                    cs.MemoToReg <= 1'b0;
                    cs.MemoRead <= 1'b0;
                    cs.MemoWrite <= 1'b0;
                    cs.regDst <= 3'b100;
                    cs.regWrite <= 1'b1;
                    cs.alu_op_code <= 4'b1001;
                    cs.alu_src <= 1'b0;
                    cs.jal_reg <= 5'b11111;
                    cs.lui_mark <= 1'b0;
                    cs.j <= 1'b0;
                    cs.opcode <= opcode;
                    cs.funct <= func;
                end
                
                6'b000010: begin   // j
                    cs.jal <= 1'b0;
                    cs.jr <= 1'b0;
                    cs.Branch <= 1'b0;
                    cs.MemoToReg <= 1'b0;
                    cs.MemoRead <= 1'b0;
                    cs.MemoWrite <= 1'b0;
                    cs.regDst <= 3'b100;    
                    cs.regWrite <= 1'b0;
                    cs.alu_op_code <= 4'b0001;
                    cs.alu_src <= 1'b0;
                    cs.jal_reg <= 5'b00000;
                    cs.lui_mark <= 1'b0;
                    cs.j <= 1'b1;
                    cs.opcode <= opcode;
                    cs.funct <= func;
//                    $display("CU J");
                end
                endcase 
            end
            else if (CU_wr == 3'b010)
                begin
//                    $display("CU_wr 010");
                    cs <= cs;
                end
            else if (CU_wr == 3'b000)
                begin
//                    $display("CU_wr 000");
                    cs <= 0;
                end
             
        end
       
     

endmodule