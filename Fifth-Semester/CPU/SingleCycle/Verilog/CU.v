`timescale 1ns/1ps


module CU(
    input [5:0] opcode,
    input [5:0] func,
    output reg jal,
    output reg jr,
    output reg Branch,
    output reg MemoToReg,
    output reg MemoRead,     // 
    output reg MemoWrite,     // 
    output reg [2:0] regDst,    
    output reg regWrite,      
    output reg [3:0] alu_op_code,
    output reg alu_src,      // 
    output reg [4:0] jal_reg,
    output reg lui_mark
);


 
    always @(opcode or func) begin 
//        $display("CU");
        case (opcode)

        6'b000000: begin     // addu, subu, jr
                case (func)
                    6'b100001: begin 
                        alu_op_code <= 4'b0001; // addu
//                        $display("alu_control addu");
                        regWrite <= 1'b1;
                        regDst <= 3'b001;
                        lui_mark <= 1'b0;     // 选寄存器
                        alu_src <= 1'b0;
                        jr <= 1'b0;
                        MemoToReg <= 1'b0;
                        jal <= 1'b0;
                        MemoRead <= 0;
                        MemoWrite <= 0;
                        Branch <= 0;
                    end
                    6'b100011: begin
                        alu_op_code <= 4'b0010; // subu
//                        $display("subu");
                        regWrite <= 1'b1;
                        regDst <= 3'b001;
                        lui_mark <= 1'b0;     // 选寄存器
                        MemoWrite <= 0;
                        alu_src <= 1'b0;
                        jr <= 1'b0;
                        MemoToReg <= 1'b0;
                        MemoRead <= 0;
                        jal <= 1'b0;
                        Branch <= 0;
                    end 
                    6'b001000: begin 
                        alu_op_code <= 4'b0101; // jr
//                        $display("jr");
                        regWrite <= 1'b0;
                        regDst <= 3'b001;
                        lui_mark <= 1'b0;     // 选寄存器
                        alu_src <= 1'b0;
                        jr <= 1'b1;
                        regDst <= 3'b001;
                        MemoToReg <= 1'b0;
                        MemoWrite <= 1'b0;
                        jal <= 1'b1;
                    end
                    endcase
//            $display("addu, subu, jr");
        end

        6'b001101: begin    // ori
            alu_op_code <= 4'b0100;
            regWrite <= 1'b1;
            alu_src <= 1'b1;
            regDst <= 3'b010;
            MemoToReg <= 1'b0;
            MemoRead <= 1'b0;
            MemoWrite <= 1'b0;
            lui_mark <= 1'b0;
            Branch <= 1'b0;
            jal <= 1'b0;
            jr <= 1'b0;
            $display("ori regDst");
        end

        6'b100011: begin    // lw
            alu_op_code <= 4'b0001;        //  0
            MemoWrite <= 1'b0;
            MemoRead <= 1'b1;
            MemoToReg <= 1'b1;
            Branch <= 0;
            jr <= 0;
            jal <= 0;
            regWrite <= 1'b1;
            regDst <= 3'b010;
            lui_mark <= 1'b0;
            alu_src <= 1'b1;
        end

        6'b101011: begin    // sw
            alu_op_code <= 4'b0001;            
            MemoWrite <= 1'b1;
            MemoToReg <= 1'b0;
            MemoRead <= 1'b0;
            lui_mark <= 1'b0;      // 上面选rs
            alu_src <= 1'b1;       // 下面选imm
            regWrite <= 1'b0;
            jr <= 1'b0;
            jal <= 1'b0;
            regWrite <= 1'b0;
//            $display("sw");
        end


        6'b000100: begin    // beq
//            $display("BEQ BRANCH");
            alu_op_code <= 4'b0010;        // 1
            Branch <= 1'b1;
            alu_src <= 1'b0;
            lui_mark <= 1'b0;
            jal <= 1'b0;
            jr <= 1'b0;
            regWrite <= 1'b0;
            MemoToReg <= 0;
            MemoWrite <= 0;
            MemoRead <= 0;
            
        end

        6'b001111: begin    //   lui
            alu_op_code <= 4'b0011;         // 
            regWrite <= 1'b1;
            lui_mark <= 1'b1;
            alu_src <= 1'b0;
            regDst <= 3'b010;
            MemoToReg <= 1'b0;
            MemoWrite <= 0;
            MemoRead <= 0;
            jal <= 0;
            jr <= 0;
            Branch <= 0;
//            $display("lui");
        end
 
        6'b000011: begin   // jal
            jal_reg <= 5'b11111;
            Branch <= 1'b0;
            jr <= 1'b0;
            jal <= 1'b1;
            regDst <= 3'b100;
            MemoRead <= 0;
            MemoToReg <= 0;
            MemoWrite <= 0;
            regWrite <= 1'b1;
//            $display("jal");
        end
        
        6'b000010: begin
            jal <= 1'b1;
            regWrite <= 1'b0;
            Branch <= 1'b0;
            jr <= 1'b0;
            regDst <= 3'b100;
            MemoRead <= 0;
            MemoToReg <= 0;
            MemoWrite <= 0;
        end


        endcase
        end
       
     

endmodule