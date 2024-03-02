`timescale 1us/1us

`include "MyStructure.sv"

module PipeReg_ID_EXE(
    input clock,
    input in_zero_flag,
    input [31:0] ins,
    input [2:0] ID_EXE_Write,
    input ControlSignal cs,
    input [31:0] ReadData1,
    input [31:0] ReadData2,
    input [4:0] RegS,
    input [4:0] RegT,
    input [4:0] RegD,
    input [31:0] SignExt_Imm,
    input [25:0] addr_26,
    input [31:0] pc_plus4,
    output ControlSignal out_cs,
    output reg [31:0] out_ReadData1,
    output reg [31:0] out_ReadData2,
    output Write_Reg out_wr,
    output Read_Reg out_rr,
    output reg [31:0] out_sign_imm,
    output reg [31:0] out_addr_26,
    output reg [31:0] out_pc_plus4,
    output reg [5:0] ID_EXE_func,
    output reg ID_EXE_zero_flag
);

    ControlSignal tmp_cs;
    reg [31:0] tmp_ReadData1;
    reg [31:0] tmp_ReadData2;
    
    Write_Reg tmp_wr;
    Read_Reg tmp_rr;
    reg [31:0] tmp_signext_imm;
    reg [31:0] tmp_addr_26; 
    reg [31:0] tmp_pc_plus_4;
    reg beq;


    always @(cs or ID_EXE_Write or ReadData1 or ReadData2 or RegS or RegT or RegD or SignExt_Imm or addr_26 or pc_plus4 or ID_EXE_zero_flag) begin
        if (ID_EXE_Write == 3'b111) begin
            tmp_cs <= cs;

                
            tmp_ReadData1 <= ReadData1;
            tmp_ReadData2 <= ReadData2;
            
            tmp_wr.regd_write1 <= RegD;
            tmp_wr.regt_write2 <= RegT;
            tmp_wr.reg31_jal <= 5'b11111;

            tmp_rr.RegS <= RegS;
            tmp_rr.RegT <= RegT;

            tmp_signext_imm <= SignExt_Imm;
            tmp_addr_26 <={6'b000000, addr_26};
            tmp_pc_plus_4 <= pc_plus4;
        end
        else begin
            tmp_cs <= '0;
            tmp_ReadData1 <= '0;
            tmp_ReadData2 <= '0;
            tmp_wr <= '0;
            tmp_rr <= '0;
            tmp_signext_imm <= '0;
            tmp_addr_26 <= '0;
            tmp_pc_plus_4 <= '0;
        end
    end
    
    always @(negedge clock) begin
//            $display("ID_EXE_negedge");
            out_cs <= tmp_cs;
            out_ReadData1 <= tmp_ReadData1;
            out_ReadData2 <= tmp_ReadData2;
            
            out_wr <= tmp_wr;

            out_rr <= tmp_rr;

            out_sign_imm <= tmp_signext_imm;
            out_addr_26 <= tmp_addr_26;
            out_pc_plus4 <= tmp_pc_plus_4;
            ID_EXE_func <= ins[5:0];
            ID_EXE_zero_flag <= in_zero_flag;
            if (ins[31:26] == 6'b000100)
                begin
                    beq = 1;
                end
            else 
                begin 
                    beq = 0;
                end   
             
//              $display("ID_EXE_pc_plus_4 = %x, beq = %d, RegS =%d, RegT = %d, RegD = %d, RegReadData1 = %x, RegReadData2 = %x, ins = %x, regWrite = %d, tmp_cs.ins = %x, j_sig = %d, jal_sig = %d, jr_sig = %d, zero_flag = %d", 
//                tmp_pc_plus_4, beq, tmp_rr.RegS, 
//                tmp_wr.regt_write2, tmp_wr.regd_write1, 
//                tmp_ReadData1, tmp_ReadData2, ins, 
//                tmp_cs.regWrite, tmp_cs.ins,
//                cs.j, cs.jal, cs.jr, in_zero_flag);
    end
    

endmodule