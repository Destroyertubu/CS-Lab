`timescale 1us/1us

`include "MyStructure.sv"
`include "MultiplicationDivisionUnit.sv"

module CU(
    input [5:0] opcode,
    input [5:0] func,
    input [4:0] shamt,
    input [31:0] ins,
    input [2:0] CU_wr,
    input [4:0] regD,
    output ControlSignal cs,
    output MultDivCs mdcs
);

    
    
    always @(opcode or func) begin 
        cs.ins <= ins;
//        $display("CU opcode = %x func = %x", opcode, func);
        mdcs <= 0;
        cs.jal <= 1'b0;
        cs.jalr <= 1'b0;
        cs.jr <= 1'b0;
        cs.Branch <= 1'b0;
        cs.MemoToReg <= 1'b0;
        cs.MemoRead <= 1'b0;
        cs.MemoWrite <= 1'b0;
        cs.regDst <= 3'b000;
        cs.regWrite <= 1'b0;
        cs.alu_op_code <= 4'b0000;
        cs.alu_src <= 1'b1;            // choose the reg 
        cs.jal_reg <= 5'b00000;
        cs.lui_mark <= 1'b1;            // choose the reg
        cs.j <= 1'b0;
        cs.opcode <= opcode;
        cs.funct <= func;
        cs.shift_sig <= 0;
        cs.syscall_sig <= 1'b0;
        cs.sign_ext_sig <= 1'b0;        

        
               case (opcode)
                6'b000000: begin     // addu, subu, jr
                        case (func)
                            6'b100001: begin     // addu
                                cs.regDst <= 3'b001;
                                cs.regWrite <= 1'b1;
                                cs.alu_op_code <= 4'b0001;
                            end
                            6'b100011: begin    // subu
                                cs.regDst <= 3'b001;
                                cs.regWrite <= 1'b1;
                                cs.alu_op_code <= 4'b0010;
                            end 
                            
                            6'b001000: begin    // jr
                                cs.jr <= 1'b1;
                            end


                            6'b001001: begin    // jalr
                                cs.jalr <= 1'b1;
                                cs.regDst <= 3'b001;
                                cs.regWrite <= 1'b1;
                                cs.alu_op_code <= 4'b1001;
                                cs.jal_reg <= regD;
                                cs.sign_ext_sig <= 1'b1;
                            end
                            
                                                        
                            6'b100000: begin       // add
                                cs.regDst <= 3'b001;
                                cs.regWrite <= 1'b1;
                                cs.alu_op_code <= 4'b0110;
                            end
                            
                            6'b100010: begin      // sub
                                cs.regDst <= 3'b001;
                                cs.regWrite <= 1'b1;
                                cs.alu_op_code <= 4'b0111;
                            end
                                                        
                            6'b100101: begin       // or
                                cs.regDst <= 3'b001;
                                cs.regWrite <= (1'b1);
                                cs.alu_op_code <= 4'b0100;
                            end
                            
                            6'b000000: begin       // sll & nop
                                cs.regDst <= 3'b001;
                                cs.regWrite <= 1'b1;
                                cs.alu_op_code <= 4'b0101;
                                cs.shift_sig <= 1;
                            end
                            
                            6'b000010: begin       // srl
                                cs.regDst <= 3'b001;
                                cs.regWrite <= 1'b1;
                                cs.alu_op_code <= 4'b1100;
                                cs.shift_sig <= 1;
                            end
                            
                            6'b000011: begin       // sra
                                cs.regDst <= 3'b001;
                                cs.regWrite <= 1'b1;
                                cs.alu_op_code <= 4'b1101;
                                cs.shift_sig <= 1;
                            end                            

                            6'b000100: begin       //  sllv
                                cs.regDst <= 3'b001;
                                cs.regWrite <= 1'b1;
                                cs.alu_op_code <= 4'b0101;
                            end      
                            
                            6'b000110: begin       //  srlv
                                mdcs <= 0;
                                cs.jal <= 1'b0;
                                cs.jalr <= 1'b0;
                                cs.jr <= 1'b0;
                                cs.Branch <= 1'b0;
                                cs.MemoToReg <= 1'b0;
                                cs.MemoRead <= 1'b0;
                                cs.MemoWrite <= 1'b0;
                                cs.regDst <= 3'b001;
                                cs.regWrite <= 1'b1;
                                cs.alu_op_code <= 4'b1100;
                                cs.alu_src <= 1'b1;
                                cs.jal_reg <= 5'b00000;
                                cs.lui_mark <= 1'b1;
                                cs.j <= 1'b0;
                                cs.opcode <= opcode;
                                cs.funct <= func;
                                cs.shift_sig <= 0;
                                cs.syscall_sig <= 1'b0;
                                cs.sign_ext_sig <= 1'b1;
                            end                                     
                            
                            6'b000111: begin       //  srav
                                mdcs <= 0;
                                cs.jal <= 1'b0;
                                cs.jalr <= 1'b0;
                                cs.jr <= 1'b0;
                                cs.Branch <= 1'b0;
                                cs.MemoToReg <= 1'b0;
                                cs.MemoRead <= 1'b0;
                                cs.MemoWrite <= 1'b0;
                                cs.regDst <= 3'b001;
                                cs.regWrite <= 1'b1;
                                cs.alu_op_code <= 4'b1101;
                                cs.alu_src <= 1'b1;
                                cs.jal_reg <= 5'b00000;
                                cs.lui_mark <= 1'b1;
                                cs.j <= 1'b0;
                                cs.opcode <= opcode;
                                cs.funct <= func;
                                cs.shift_sig <= 0;
                                cs.syscall_sig <= 1'b0;
                                cs.sign_ext_sig <= 1'b1;
                            end                            
                                              
                            
                            6'b101010: begin       // slt
                                mdcs <= 0;
//                                $display("OR ACT");
                                cs.jal <= 1'b0; 
                                cs.jalr <= 1'b0;
                                cs.jr <= 1'b0;
                                cs.Branch <= 1'b0;
                                cs.MemoToReg <= 1'b0;
                                cs.MemoRead <= 1'b0;
                                cs.MemoWrite <= 1'b0;
                                cs.regDst <= 3'b001;
                                cs.regWrite <= 1'b1;
                                cs.alu_op_code <= 4'b1000;
                                cs.alu_src <= 1'b1;    
                                cs.jal_reg <= 5'b00000;
                                cs.lui_mark <= 1'b1;   
                                cs.j <= 1'b0;
                                cs.opcode <= opcode;
                                cs.funct <= func;
                                cs.shift_sig <= 0;
                                cs.syscall_sig <= 1'b0;
                                cs.sign_ext_sig <= 1'b0;
                            end
                            
                            6'b101011: begin       // sltu
                                mdcs <= 0;
//                                $display("OR ACT");
                                cs.jal <= 1'b0; 
                                cs.jalr <= 1'b0;
                                cs.jr <= 1'b0;
                                cs.Branch <= 1'b0;
                                cs.MemoToReg <= 1'b0;
                                cs.MemoRead <= 1'b0;
                                cs.MemoWrite <= 1'b0;
                                cs.regDst <= 3'b001;
                                cs.regWrite <= 1'b1;
                                cs.alu_op_code <= 4'b1111;
                                cs.alu_src <= 1'b1;    
                                cs.jal_reg <= 5'b00000;
                                cs.lui_mark <= 1'b1;   
                                cs.j <= 1'b0;
                                cs.opcode <= opcode;
                                cs.funct <= func;
                                cs.shift_sig <= 0;
                                cs.syscall_sig <= 1'b0;
                                cs.sign_ext_sig <= 1'b0;
                            end                            
                            
                            6'b100100: begin       // and
                                mdcs <= 0;
                                cs.jal <= 1'b0; 
                                cs.jalr <= 1'b0;
                                cs.jr <= 1'b0;
                                cs.Branch <= 1'b0;
                                cs.MemoToReg <= 1'b0;
                                cs.MemoRead <= 1'b0;
                                cs.MemoWrite <= 1'b0;
                                cs.regDst <= 3'b001;
                                cs.regWrite <= 1'b1;
                                cs.alu_op_code <= 4'b1010;
                                cs.alu_src <= 1'b1;    
                                cs.jal_reg <= 5'b00000;
                                cs.lui_mark <= 1'b1;   
                                cs.j <= 1'b0;
                                cs.opcode <= opcode;
                                cs.funct <= func;
                                cs.shift_sig <= 0;
                                cs.syscall_sig <= 1'b0;
                                cs.sign_ext_sig <= 1'b0;
                            end                            

                            
                            6'b100100: begin       // and
                                mdcs <= 0;
                                cs.jal <= 1'b0; 
                                cs.jalr <= 1'b0;
                                cs.jr <= 1'b0;
                                cs.Branch <= 1'b0;
                                cs.MemoToReg <= 1'b0;
                                cs.MemoRead <= 1'b0;
                                cs.MemoWrite <= 1'b0;
                                cs.regDst <= 3'b001;
                                cs.regWrite <= 1'b1;
                                cs.alu_op_code <= 4'b1010;
                                cs.alu_src <= 1'b1;    
                                cs.jal_reg <= 5'b00000;
                                cs.lui_mark <= 1'b1;   
                                cs.j <= 1'b0;
                                cs.opcode <= opcode;
                                cs.funct <= func;
                                cs.shift_sig <= 0;
                                cs.syscall_sig <= 1'b0;
                                cs.sign_ext_sig <= 1'b0;
                            end 
                                                        
                            6'b100110: begin       // xor
                                mdcs <= 0;
                                cs.jal <= 1'b0; 
                                cs.jalr <= 1'b0;
                                cs.jr <= 1'b0;
                                cs.Branch <= 1'b0;
                                cs.MemoToReg <= 1'b0;
                                cs.MemoRead <= 1'b0;
                                cs.MemoWrite <= 1'b0;
                                cs.regDst <= 3'b001;
                                cs.regWrite <= 1'b1;
                                cs.alu_op_code <= 4'b1011;
                                cs.alu_src <= 1'b1;    
                                cs.jal_reg <= 5'b00000;
                                cs.lui_mark <= 1'b1;   
                                cs.j <= 1'b0;
                                cs.opcode <= opcode;
                                cs.funct <= func;
                                cs.shift_sig <= 0;
                                cs.syscall_sig <= 1'b0;
                                cs.sign_ext_sig <= 1'b0;
                            end 
                            
                            6'b100111: begin       // nor
                                mdcs <= 0;
                                cs.jal <= 1'b0; 
                                cs.jalr <= 1'b0;
                                cs.jr <= 1'b0;
                                cs.Branch <= 1'b0;
                                cs.MemoToReg <= 1'b0;
                                cs.MemoRead <= 1'b0;
                                cs.MemoWrite <= 1'b0;
                                cs.regDst <= 3'b001;
                                cs.regWrite <= 1'b1;
                                cs.alu_op_code <= 4'b1110;
                                cs.alu_src <= 1'b1;    
                                cs.jal_reg <= 5'b00000;
                                cs.lui_mark <= 1'b1;   
                                cs.j <= 1'b0;
                                cs.opcode <= opcode;
                                cs.funct <= func;
                                cs.shift_sig <= 0;
                                cs.syscall_sig <= 1'b0;
                                cs.sign_ext_sig <= 1'b0;
                            end                            
                            
//   --------------------  Multiplication and Division start
                            6'b011000: begin     // mult
                                cs.jal <= 1'b0;
                                cs.jalr <= 1'b0;
                                cs.jr <= 1'b0;
                                cs.Branch <= 1'b0;
                                cs.MemoToReg <= 1'b0;
                                cs.MemoRead <= 1'b0;
                                cs.MemoWrite <= 1'b0;
                                cs.regDst <= 3'b000;
                                cs.regWrite <= 1'b0;
                                cs.alu_op_code <= 4'b0001;
                                cs.alu_src <= 1'b1;
                                cs.jal_reg <= 5'b00000;
                                cs.lui_mark <= 1'b1;
                                cs.j <= 1'b0;
                                cs.opcode <= opcode;
                                cs.funct <= func;
                                cs.shift_sig <= 0;
                                cs.syscall_sig <= 1'b0;
                                cs.sign_ext_sig <= 1'b1;                                
                                mdcs.is_MD <= 1'b1;
                                mdcs.MD_read <= 1'b0;
                                mdcs.MD_write <= 1'b0;
                                mdcs.MD_opcode <= MDU_START_SIGNED_MUL;
                            end         
                            
                            
                            6'b011001: begin     // multu
                                cs.jal <= 1'b0;
                                cs.jalr <= 1'b0;
                                cs.jr <= 1'b0;
                                cs.Branch <= 1'b0;
                                cs.MemoToReg <= 1'b0;
                                cs.MemoRead <= 1'b0;
                                cs.MemoWrite <= 1'b0;
                                cs.regDst <= 3'b000;
                                cs.regWrite <= 1'b0;
                                cs.alu_op_code <= 4'b0001;
                                cs.alu_src <= 1'b1;
                                cs.jal_reg <= 5'b00000;
                                cs.lui_mark <= 1'b1;
                                cs.j <= 1'b0;
                                cs.opcode <= opcode;
                                cs.funct <= func;
                                cs.shift_sig <= 0;
                                cs.syscall_sig <= 1'b0;
                                cs.sign_ext_sig <= 1'b1;                                
                                mdcs.is_MD <= 1'b1;
                                mdcs.MD_read <= 1'b0;
                                mdcs.MD_write <= 1'b0;
                                mdcs.MD_opcode <= MDU_START_UNSIGNED_MUL;
                            end             

                            6'b011010: begin     // div
                                cs.jal <= 1'b0;
                                cs.jalr <= 1'b0;
                                cs.jr <= 1'b0;
                                cs.Branch <= 1'b0;
                                cs.MemoToReg <= 1'b0;
                                cs.MemoRead <= 1'b0;
                                cs.MemoWrite <= 1'b0;
                                cs.regDst <= 3'b000;
                                cs.regWrite <= 1'b0;
                                cs.alu_op_code <= 4'b0001;
                                cs.alu_src <= 1'b1;
                                cs.jal_reg <= 5'b00000;
                                cs.lui_mark <= 1'b1;
                                cs.j <= 1'b0;
                                cs.opcode <= opcode;
                                cs.funct <= func;
                                cs.shift_sig <= 0;
                                cs.syscall_sig <= 1'b0;
                                cs.sign_ext_sig <= 1'b1;                                
                                mdcs.is_MD <= 1'b1;
                                mdcs.MD_read <= 1'b0;
                                mdcs.MD_write <= 1'b0;
                                mdcs.MD_opcode <= MDU_START_SIGNED_DIV;
                            end   

                            6'b011011: begin     // divu
                                cs.jal <= 1'b0;
                                cs.jalr <= 1'b0;
                                cs.jr <= 1'b0;
                                cs.Branch <= 1'b0;
                                cs.MemoToReg <= 1'b0;
                                cs.MemoRead <= 1'b0;
                                cs.MemoWrite <= 1'b0;
                                cs.regDst <= 3'b000;
                                cs.regWrite <= 1'b0;
                                cs.alu_op_code <= 4'b0001;
                                cs.alu_src <= 1'b1;
                                cs.jal_reg <= 5'b00000;
                                cs.lui_mark <= 1'b1;
                                cs.j <= 1'b0;
                                cs.opcode <= opcode;
                                cs.funct <= func;
                                cs.shift_sig <= 0;
                                cs.syscall_sig <= 1'b0;
                                cs.sign_ext_sig <= 1'b1;                                
                                mdcs.is_MD <= 1'b1;
                                mdcs.MD_read <= 1'b0;
                                mdcs.MD_write <= 1'b0;
                                mdcs.MD_opcode <= MDU_START_UNSIGNED_DIV;
                            end                               
                                                        
                            6'b010000: begin     // mfhi
                                cs.jal <= 1'b0;
                                cs.jalr <= 1'b0;
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
                                cs.shift_sig <= 0;
                                cs.syscall_sig <= 1'b0;
                                cs.sign_ext_sig <= 1'b1;                                
                                mdcs.is_MD <= 1'b1;
                                mdcs.MD_read <= 1'b1;
                                mdcs.MD_write <= 1'b0;
                                mdcs.MD_opcode <= MDU_READ_HI;
                            end                                                   

                            6'b010010: begin     // mflo
                                cs.jal <= 1'b0;
                                cs.jalr <= 1'b0;
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
                                cs.shift_sig <= 0;
                                cs.syscall_sig <= 1'b0;
                                cs.sign_ext_sig <= 1'b1;                                
                                mdcs.is_MD <= 1'b1;
                                mdcs.MD_read <= 1'b1;
                                mdcs.MD_write <= 1'b0;
                                mdcs.MD_opcode <= MDU_READ_LO;
                            end    
                            
                            6'b010001: begin     // mthi
                                cs.jal <= 1'b0;
                                cs.jalr <= 1'b0;
                                cs.jr <= 1'b0;
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
                                cs.shift_sig <= 0;
                                cs.syscall_sig <= 1'b0;
                                cs.sign_ext_sig <= 1'b1;                                
                                mdcs.is_MD <= 1'b1;
                                mdcs.MD_read <= 1'b0;
                                mdcs.MD_write <= 1'b1;
                                mdcs.MD_opcode <= MDU_WRITE_HI;
                            end                                
                            
                            6'b010011: begin     // mtlo
                                cs.jal <= 1'b0;
                                cs.jalr <= 1'b0;
                                cs.jr <= 1'b0;
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
                                cs.shift_sig <= 0;
                                cs.syscall_sig <= 1'b0;
                                cs.sign_ext_sig <= 1'b1;                                
                                mdcs.is_MD <= 1'b1;
                                mdcs.MD_read <= 1'b0;
                                mdcs.MD_write <= 1'b1;
                                mdcs.MD_opcode <= MDU_WRITE_LO;
                            end                             
                            
//   --------------------  Multiplication and Division end         
                            
                                                        
                            6'b001100: begin
//                                $finish;
                                cs.syscall_sig <= 1'b1;
                            end
                            endcase
        //            $display("addu, subu, jr");
               end
        
               6'b001101: begin    // ori
                    // $display("ori");
                    mdcs <= 0;
                    cs.jal <= 1'b0;
                    cs.jalr <= 1'b0;
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
                    cs.shift_sig <= 0;
                    cs.syscall_sig <= 1'b0;
                    cs.sign_ext_sig <= 1'b0;
                end
        
                6'b100011: begin    // lw
                    mdcs <= 0;
                    cs.jal <= 1'b0;
                    cs.jalr <= 1'b0;
                    cs.jr <= 1'b0;
                    cs.Branch <= 1'b0;
                    cs.MemoToReg <= 1'b1;
                    cs.MemoRead <= 1'b1;
                    cs.MemoWrite <= 1'b0;
                    cs.regDst <= 3'b010;
                    cs.regWrite <= 1'b1;
                    cs.alu_op_code <= 4'b0110;
                    cs.alu_src <= 1'b0;
                    cs.jal_reg <= 5'b00000;
                    cs.lui_mark <= 1'b1;
                    cs.j <= 1'b0;
                    cs.opcode <= opcode;
                    cs.funct <= func;
                    cs.shift_sig <= 0;
                    cs.syscall_sig <= 1'b0;
                    cs.sign_ext_sig <= 1'b1;
                end
                
                6'b100000: begin    // lb
                    mdcs <= 0;
                    cs.jal <= 1'b0;
                    cs.jalr <= 1'b0;
                    cs.jr <= 1'b0;
                    cs.Branch <= 1'b0;
                    cs.MemoToReg <= 1'b1;
                    cs.MemoRead <= 1'b1;
                    cs.MemoWrite <= 1'b0;
                    cs.regDst <= 3'b010;
                    cs.regWrite <= 1'b1;
                    cs.alu_op_code <= 4'b0110;
                    cs.alu_src <= 1'b0;
                    cs.jal_reg <= 5'b00000;
                    cs.lui_mark <= 1'b1;
                    cs.j <= 1'b0;
                    cs.opcode <= opcode;
                    cs.funct <= func;
                    cs.shift_sig <= 0;
                    cs.syscall_sig <= 1'b0;
                    cs.sign_ext_sig <= 1'b1;
                end                
        
                6'b100100: begin    // lbu
                    mdcs <= 0;
                    cs.jal <= 1'b0;
                    cs.jalr <= 1'b0;
                    cs.jr <= 1'b0;
                    cs.Branch <= 1'b0;
                    cs.MemoToReg <= 1'b1;
                    cs.MemoRead <= 1'b1;
                    cs.MemoWrite <= 1'b0;
                    cs.regDst <= 3'b010;
                    cs.regWrite <= 1'b1;
                    cs.alu_op_code <= 4'b0110;
                    cs.alu_src <= 1'b0;
                    cs.jal_reg <= 5'b00000;
                    cs.lui_mark <= 1'b1;
                    cs.j <= 1'b0;
                    cs.opcode <= opcode;
                    cs.funct <= func;
                    cs.shift_sig <= 0;
                    cs.syscall_sig <= 1'b0;
                    cs.sign_ext_sig <= 1'b1;
                end    
                
                6'b100001: begin    // lh
                    mdcs <= 0;
                    cs.jal <= 1'b0;
                    cs.jalr <= 1'b0;
                    cs.jr <= 1'b0;
                    cs.Branch <= 1'b0;
                    cs.MemoToReg <= 1'b1;
                    cs.MemoRead <= 1'b1;
                    cs.MemoWrite <= 1'b0;
                    cs.regDst <= 3'b010;
                    cs.regWrite <= 1'b1;
                    cs.alu_op_code <= 4'b0110;
                    cs.alu_src <= 1'b0;
                    cs.jal_reg <= 5'b00000;
                    cs.lui_mark <= 1'b1;
                    cs.j <= 1'b0;
                    cs.opcode <= opcode;
                    cs.funct <= func;
                    cs.shift_sig <= 0;
                    cs.syscall_sig <= 1'b0;
                    cs.sign_ext_sig <= 1'b1;
                end 
 
 
                6'b100101: begin    // lhu
                    mdcs <= 0;
                    cs.jal <= 1'b0;
                    cs.jalr <= 1'b0;
                    cs.jr <= 1'b0;
                    cs.Branch <= 1'b0;
                    cs.MemoToReg <= 1'b1;
                    cs.MemoRead <= 1'b1;
                    cs.MemoWrite <= 1'b0;
                    cs.regDst <= 3'b010;
                    cs.regWrite <= 1'b1;
                    cs.alu_op_code <= 4'b0110;
                    cs.alu_src <= 1'b0;
                    cs.jal_reg <= 5'b00000;
                    cs.lui_mark <= 1'b1;
                    cs.j <= 1'b0;
                    cs.opcode <= opcode;
                    cs.funct <= func;
                    cs.shift_sig <= 0;
                    cs.syscall_sig <= 1'b0;
                    cs.sign_ext_sig <= 1'b1;
                end 
                
                        
                6'b101011: begin    // sw
                    mdcs <= 0;
                    cs.jal <= 1'b0;
                    cs.jalr <= 1'b0;
                    cs.jr <= 1'b0;
                    cs.Branch <= 1'b0;
                    cs.MemoToReg <= 1'b0;
                    cs.MemoRead <= 1'b0;
                    cs.MemoWrite <= 1'b1;
                    cs.regDst <= 3'b010;
                    cs.regWrite <= 1'b0;
                    cs.alu_op_code <= 4'b0110;
                    cs.alu_src <= 1'b0;
                    cs.jal_reg <= 5'b00000;
                    cs.lui_mark <= 1'b1;
                    cs.j <= 1'b0;
                    cs.opcode <= opcode;
                    cs.funct <= func;
                    cs.shift_sig <= 0;
                    cs.syscall_sig <= 1'b0;
                    cs.sign_ext_sig <= 1'b1;
                end

                6'b101000: begin    // sb
                    mdcs <= 0;
                    cs.jal <= 1'b0;
                    cs.jalr <= 1'b0;
                    cs.jr <= 1'b0;
                    cs.Branch <= 1'b0;
                    cs.MemoToReg <= 1'b0;
                    cs.MemoRead <= 1'b0;
                    cs.MemoWrite <= 1'b1;
                    cs.regDst <= 3'b010;
                    cs.regWrite <= 1'b0;
                    cs.alu_op_code <= 4'b0110;
                    cs.alu_src <= 1'b0;
                    cs.jal_reg <= 5'b00000;
                    cs.lui_mark <= 1'b1;
                    cs.j <= 1'b0;
                    cs.opcode <= opcode;
                    cs.funct <= func;
                    cs.shift_sig <= 0;
                    cs.syscall_sig <= 1'b0;
                    cs.sign_ext_sig <= 1'b1;
                end  
                
                
                6'b101001: begin    // sh
                    mdcs <= 0;
                    cs.jal <= 1'b0;
                    cs.jalr <= 1'b0;
                    cs.jr <= 1'b0;
                    cs.Branch <= 1'b0;
                    cs.MemoToReg <= 1'b0;
                    cs.MemoRead <= 1'b0;
                    cs.MemoWrite <= 1'b1;
                    cs.regDst <= 3'b010;
                    cs.regWrite <= 1'b0;
                    cs.alu_op_code <= 4'b0110;
                    cs.alu_src <= 1'b0;
                    cs.jal_reg <= 5'b00000;
                    cs.lui_mark <= 1'b1;
                    cs.j <= 1'b0;
                    cs.opcode <= opcode;
                    cs.funct <= func;
                    cs.shift_sig <= 0;
                    cs.syscall_sig <= 1'b0;
                    cs.sign_ext_sig <= 1'b1;
                end       
        
                6'b000100: begin    // beq
//                    $display("BEQ BRANCH ins = %x", ins);
                    mdcs <= 0;
                    cs.jal <= 1'b0;
                    cs.jalr <= 1'b0;
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
                    cs.shift_sig <= 0;
                    cs.syscall_sig <= 1'b0;
                    cs.sign_ext_sig <= 1'b1;
                end

                6'b000111: begin    // bgtz
                    mdcs <= 0;
//                    $display("BEQ BRANCH ins = %x", ins);
                    cs.jal <= 1'b0;
                    cs.jalr <= 1'b0;
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
                    cs.shift_sig <= 0;
                    cs.syscall_sig <= 1'b0;
                    cs.sign_ext_sig <= 1'b1;
                end
                
                6'b000110: begin    // blez
                    mdcs <= 0;
//                    $display("BEQ BRANCH ins = %x", ins);
                    cs.jal <= 1'b0;
                    cs.jalr <= 1'b0;
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
                    cs.shift_sig <= 0;
                    cs.syscall_sig <= 1'b0;
                    cs.sign_ext_sig <= 1'b1;
                end

                6'b000001: begin    // bgez   bltz
                    mdcs <= 0;
//                    $display("BEQ BRANCH ins = %x", ins);
                    cs.jal <= 1'b0;
                    cs.jalr <= 1'b0;
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
                    cs.shift_sig <= 0;
                    cs.syscall_sig <= 1'b0;
                    cs.sign_ext_sig <= 1'b1;
                end                
                        
                6'b001111: begin    //   lui
                    mdcs <= 0;
                    cs.jal <= 1'b0;
                    cs.jalr <= 1'b0;
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
                    cs.shift_sig <= 0;
                    cs.syscall_sig <= 1'b0;
                    cs.sign_ext_sig <= 1'b1;
                end
         
                6'b000011: begin   // jal
                    mdcs <= 0;
                    cs.jal <= 1'b1;
                    cs.jalr <= 1'b0;
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
                    cs.shift_sig <= 0;
                    cs.syscall_sig <= 1'b0;
                    cs.sign_ext_sig <= 1'b1;
                end
                
                6'b000010: begin   // j
                    mdcs <= 0;
                    cs.jal <= 1'b0;
                    cs.jalr <= 1'b0;
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
                    cs.shift_sig <= 0;
                    cs.syscall_sig <= 1'b0;
                    cs.sign_ext_sig <= 1'b1;
//                    $display("CU J");
                end
                
                6'b001010: begin    // slti
                    mdcs <= 0;
                    cs.jal <= 1'b0;
                    cs.jalr <= 1'b0;
                    cs.jr <= 1'b0;
                    cs.Branch <= 1'b0;
                    cs.MemoToReg <= 1'b0;
                    cs.MemoRead <= 1'b0;
                    cs.MemoWrite <= 1'b0;
                    cs.regDst <= 3'b010;
                    cs.regWrite <= 1'b1;
                    cs.alu_op_code <= 4'b1000;
                    cs.alu_src <= 1'b0;    
                    cs.jal_reg <= 5'b00000;
                    cs.lui_mark <= 1'b1;   
                    cs.j <= 1'b0;
                    cs.opcode <= opcode;
                    cs.funct <= func;
                    cs.shift_sig <= 0;
                    cs.syscall_sig <= 1'b0;
                    cs.sign_ext_sig <= 1'b1;
                end
                
                6'b001011: begin    // sltui
                    mdcs <= 0;
                    cs.jal <= 1'b0;
                    cs.jalr <= 1'b0;
                    cs.jr <= 1'b0;
                    cs.Branch <= 1'b0;
                    cs.MemoToReg <= 1'b0;
                    cs.MemoRead <= 1'b0;
                    cs.MemoWrite <= 1'b0;
                    cs.regDst <= 3'b010;
                    cs.regWrite <= 1'b1;
                    cs.alu_op_code <= 4'b1111;
                    cs.alu_src <= 1'b0;    
                    cs.jal_reg <= 5'b00000;
                    cs.lui_mark <= 1'b1;   
                    cs.j <= 1'b0;
                    cs.opcode <= opcode;
                    cs.funct <= func;
                    cs.shift_sig <= 0;
                    cs.syscall_sig <= 1'b0;
                    cs.sign_ext_sig <= 1'b1;
                end                
                
                6'b001001: begin       // addiu
                    mdcs <= 0;
                    cs.jal <= 1'b0;
                    cs.jalr <= 1'b0;
                    cs.jr <= 1'b0;
                    cs.Branch <= 1'b0;
                    cs.MemoToReg <= 1'b0;
                    cs.MemoRead <= 1'b0;
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
                    cs.shift_sig <= 0;
                    cs.syscall_sig <= 1'b0;
                    cs.sign_ext_sig <= 1'b1;
                end
                
                6'b000101: begin     //bne
                    mdcs <= 0;
                    cs.jal <= 1'b0;
                    cs.jalr <= 1'b0;
                    cs.jr <= 1'b0;
                    cs.Branch <= 1'b1;
                    cs.MemoToReg <= 1'b0;
                    cs.MemoRead <= 1'b0;
                    cs.MemoWrite <= 1'b0;
                    cs.regDst <= 3'b000;
                    cs.regWrite <= 1'b0;
                    cs.alu_op_code <= 4'b0000;
                    cs.alu_src <= 1'b0;    
                    cs.jal_reg <= 5'b00000;
                    cs.lui_mark <= 1'b0;   
                    cs.j <= 1'b0;
                    cs.opcode <= opcode;
                    cs.funct <= func;
                    cs.shift_sig <= 0;
                    cs.syscall_sig <= 1'b0;
                    cs.sign_ext_sig <= 1'b1;
                end
                
                6'b001100: begin     // andi
                    mdcs <= 0;
                    cs.jal <= 1'b0;
                    cs.jalr <= 1'b0;
                    cs.jr <= 1'b0;
                    cs.Branch <= 1'b0;
                    cs.MemoToReg <= 1'b0;
                    cs.MemoRead <= 1'b0;
                    cs.MemoWrite <= 1'b0;
                    cs.regDst <= 3'b010;
                    cs.regWrite <= 1'b1;
                    cs.alu_op_code <= 4'b1010;
                    cs.alu_src <= 1'b0;    
                    cs.jal_reg <= 5'b00000;
                    cs.lui_mark <= 1'b1;   
                    cs.j <= 1'b0;
                    cs.opcode <= opcode;
                    cs.funct <= func;
                    cs.shift_sig <= 0;
                    cs.syscall_sig <= 1'b0;
                    cs.sign_ext_sig <= 1'b0;
                end 
                
                6'b001110: begin       // xori
                    mdcs <= 0;
                    cs.jal <= 1'b0;
                    cs.jalr <= 1'b0;
                    cs.jr <= 1'b0;
                    cs.Branch <= 1'b0;
                    cs.MemoToReg <= 1'b0;
                    cs.MemoRead <= 1'b0;
                    cs.MemoWrite <= 1'b0;
                    cs.regDst <= 3'b010;
                    cs.regWrite <= 1'b1;
                    cs.alu_op_code <= 4'b1011;
                    cs.alu_src <= 1'b0;    
                    cs.jal_reg <= 5'b00000;
                    cs.lui_mark <= 1'b1;   
                    cs.j <= 1'b0;
                    cs.opcode <= opcode;
                    cs.funct <= func;
                    cs.shift_sig <= 0;
                    cs.syscall_sig <= 1'b0;
                    cs.sign_ext_sig <= 1'b0;
                end
                
                6'b001000: begin     // addi
                    mdcs <= 0;
                    cs.jal <= 1'b0;
                    cs.jalr <= 1'b0;
                    cs.jr <= 1'b0;
                    cs.Branch <= 1'b0;
                    cs.MemoToReg <= 1'b0;
                    cs.MemoRead <= 1'b0;
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
                    cs.shift_sig <= 0;
                    cs.syscall_sig <= 1'b0;
                    cs.sign_ext_sig <= 1'b1;
                end              
         
            endcase  
        end
       
     

endmodule