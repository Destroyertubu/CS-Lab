`timescale 1ns / 1ps

module Addr_Reg_Mux(
    input [31:0] pc_plus_8,
    input [2:0] ForwradC,
    input [4:0] MEM_WB_WriteReg,
    input [31:0] MEM_WB_Data,
    output [4:0] WriteReg,
    output [31:0] WriteData
);
    assign WriteReg = ForwradC == 3'b111 ? MEM_WB_WriteReg : 5'b11111;
    assign WriteData = ForwradC == 3'b111 ? MEM_WB_Data : pc_plus_8;
      

endmodule
