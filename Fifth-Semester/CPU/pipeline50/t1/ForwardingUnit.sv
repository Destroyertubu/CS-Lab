`timescale 1us/1us

module ForwardingUnit(
    input [31:0] IF_ID_ins, 
    input [4:0] IF_ID_RegS,
    input [4:0] IF_ID_RegT,
    input [4:0] ID_EXE_WriteReg,
    input Read_Reg in_rr,
    input [4:0] MEM_WB_Write_Reg,
    input [4:0] EXE_MEM_Write_Reg,
    input ID_EXE_RegWrite,
    input MEM_WB_RegWriteW,
    input EXE_MEM_RegWriteW,
    output reg [2:0] out_forwardA,
    output reg [2:0] out_forwardB,
    output reg [3:0] out_forwardC,
    output reg [3:0] out_forwardD,
    input [31:0] pc_plus_4
);
    
        always @(*) begin
            out_forwardA <= 3'b010;
            out_forwardB <= 3'b010;
            out_forwardC <= 4'b0001;
            out_forwardD <= 4'b0001;
            
//            $display("FU EXE_MEM_Write_Reg = %x, RegS = %x, pc_plus_4 = %x", EXE_MEM_Write_Reg, in_rr.RegS, pc_plus_4);
            if (EXE_MEM_RegWriteW && (EXE_MEM_Write_Reg != 0) && (in_rr.RegS == EXE_MEM_Write_Reg)) begin
//                $display("FU EXE_MEM_Write_Reg = %x, RegS = %x", EXE_MEM_Write_Reg, in_rr.RegS);
                out_forwardA <= 3'b001;
            end
            else if (MEM_WB_RegWriteW && (MEM_WB_Write_Reg != 0) && !(EXE_MEM_RegWriteW && ( EXE_MEM_Write_Reg !=0 ) && (EXE_MEM_Write_Reg == in_rr.RegS)) && (in_rr.RegS == MEM_WB_Write_Reg)) begin
                out_forwardA <= 3'b100;
            end
            if (EXE_MEM_RegWriteW && (EXE_MEM_Write_Reg != 0) && (in_rr.RegT == EXE_MEM_Write_Reg)) begin
                out_forwardB <= 3'b001;
            end
            else if (MEM_WB_RegWriteW && (MEM_WB_Write_Reg != 0) && !(EXE_MEM_RegWriteW && ( EXE_MEM_Write_Reg !=0 ) && (EXE_MEM_Write_Reg == in_rr.RegT)) && (in_rr.RegT == MEM_WB_Write_Reg )) begin
                out_forwardB <= 3'b100;
            end
            
//            if(IF_ID_RegS == 5'b11111 && ID_EXE_WriteReg == 5'b11111 && ID_EXE_RegWrite == 1'b1)
//                begin
//                    out_forwardC <= 4'b0010;
                    
//                end
//            if(IF_ID_RegS == 5'b11111 && EXE_MEM_Write_Reg == 5'b11111 && EXE_MEM_RegWriteW == 1'b1)
//                begin
//                    out_forwardC <= 4'b0100;
//                end    
//            if(IF_ID_RegS == 5'b11111 && MEM_WB_Write_Reg == 5'b11111 && MEM_WB_RegWriteW == 1'b1)
//                begin
//                    out_forwardC <= 4'b1000;
//                end

//            $display("OUTER IF_ID_ins = %x", IF_ID_ins);

            if(ID_EXE_WriteReg != 0 && IF_ID_RegS == ID_EXE_WriteReg && ID_EXE_RegWrite == 1'b1)
                begin
                    out_forwardC <= 4'b0010;
//                    $display("IF_ID_ins = %x, RegS = %d, ID_EXE_WriteReg = %d, 0010", IF_ID_ins, IF_ID_RegS, ID_EXE_WriteReg);
                end
            else if(EXE_MEM_Write_Reg != 0 && IF_ID_RegS == EXE_MEM_Write_Reg && EXE_MEM_RegWriteW == 1'b1)
                begin
                    out_forwardC <= 4'b0100;
//                    $display("IF_ID_ins = %x, 0100", IF_ID_ins);
                end    
            else if(MEM_WB_Write_Reg!= 0 && IF_ID_RegS == MEM_WB_Write_Reg && MEM_WB_RegWriteW == 1'b1)
                begin
                    out_forwardC <= 4'b1000;
//                    $display("IF_ID_ins = %x, 1000", IF_ID_ins);
                end
                
                
                
            if(ID_EXE_WriteReg != 0 && IF_ID_RegT == ID_EXE_WriteReg && ID_EXE_RegWrite == 1'b1)
                begin
                    out_forwardD <= 4'b0010;
//                    $display("IF_ID_ins = %x, RegT = %d, ID_EXE_WriteReg = %d, 0010", IF_ID_ins, IF_ID_RegT, ID_EXE_WriteReg);
                end
            else if(EXE_MEM_Write_Reg != 0 && IF_ID_RegT == EXE_MEM_Write_Reg && EXE_MEM_RegWriteW == 1'b1)
                begin
                    out_forwardD <= 4'b0100;
//                    $display("IF_ID_ins = %x, RegT = %d, EXE_MEM_WriteReg = %d, 0100", IF_ID_ins, IF_ID_RegT, EXE_MEM_Write_Reg);
                end    
            else if(MEM_WB_Write_Reg!= 0 && IF_ID_RegT == MEM_WB_Write_Reg && MEM_WB_RegWriteW == 1'b1)
                begin
                    out_forwardD <= 4'b1000;
//                    $display("IF_ID_ins = %x, RegT = %d, MEM_WB_WriteReg = %d, 1000", IF_ID_ins, IF_ID_RegT, MEM_WB_Write_Reg);
                end

        end
    
endmodule