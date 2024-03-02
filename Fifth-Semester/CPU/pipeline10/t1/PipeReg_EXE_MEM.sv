`timescale 1us/1us

`include "MyStructure.sv"

module PipeReg_EXE_MEM(
    input clock,
    input [31:0] ins,
    input ControlSignal cs,
    input zero_flag,
    input [31:0] ALU_res,
    input [31:0] Data_to_Mem,
    input [4:0] write_reg,
    input [31:0] branch_addr,
    input [31:0] jal_concat_addr,
    input [31:0] pc_plus4,
    output ControlSignal out_cs,
    output reg [31:0] out_ALU_res,
    output reg [31:0] out_Data_to_Mem,
    output reg [4:0]  out_write_reg,
    output MuxMixSig mms,
    output Mix_Addr out_mix_addr,
    output reg [31:0] out_pc_plus4,
    output reg out_zero_flag,
    output reg [5:0] EXE_MEM_func
);
    reg beq = 1;

    always @(negedge clock) begin
//            $display("EXE_MEM_negedge");
            out_cs <= cs;
            out_ALU_res <= ALU_res;
            out_Data_to_Mem <= Data_to_Mem;
            out_write_reg <= write_reg;
            out_pc_plus4 <= pc_plus4;
            
            EXE_MEM_func <= ins[5:0];

//            $display("EXE_MEM pc_plus_4 = %x ALU_res = %x cs.regWrite = %d, out_write_reg = %d, ins = %x, Data_to_Memo = %x", pc_plus4, ALU_res, cs.regWrite, write_reg, ins, Data_to_Mem);

    end


endmodule