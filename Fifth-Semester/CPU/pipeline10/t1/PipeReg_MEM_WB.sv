`timescale 1us/1us

`include "MyStructure.sv"

module PipeReg_MEM_WB(
    input clock,
    input [31:0] ins,
    input ControlSignal cs,
    input [31:0] ALU_res,
    input [31:0] Mem_Read_Data,
    input [4:0] write_reg,
    input [31:0]  pc_plus4,
    output ControlSignal out_cs,
    output reg [31:0]  out_Mem_Read_Data,
    output reg [31:0]  out_ALU_res,
    output reg [4:0] out_write_reg,
    output reg [31:0] out_pc_plus8,
    output reg [31:0] branch_addr,
    output reg MEM_WB_out_zero_flag,
    output reg [5:0] MEM_WB_func,
    output reg [31:0] MEM_WB_out_pc_plus_4
);
    reg beq = 1;

    always @(negedge clock) begin
//        $display("MEM_WB_negedge");
        out_cs <= cs;
        out_Mem_Read_Data <= Mem_Read_Data;
        out_ALU_res <= ALU_res;
        out_write_reg <= write_reg;
        
        MEM_WB_func <= ins[5:0];
        MEM_WB_out_pc_plus_4 <= pc_plus4;
        
       if (ins[31:26] == 6'b000100)
            begin
                beq = 1;
            end
        else 
            begin
                beq = 0;
            end
//        out_mms <= mms;
//         $display("MEM_WB pc_plus4 = %x, beq = %d, ALU_res = %x, ReadData = %x RegWrite = %x, WriteReg = %d, ins = %x", pc_plus4, beq, ALU_res, Mem_Read_Data, cs.regWrite, write_reg, ins);
    end

endmodule