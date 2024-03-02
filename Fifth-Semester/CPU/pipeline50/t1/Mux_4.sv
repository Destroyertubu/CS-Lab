`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/06 12:33:20
// Design Name: 
// Module Name: Mux_4
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Mux_4(
    input [31:0] ID_RegS_addr,
    input [31:0] ALU_res_addr,
    input [31:0] EXE_MEM_write_reg_addr,
    input [31:0] MEM_WB_write_reg_addr,
    input [3:0] sig,
    output reg [31:0] Reg31_addr
    );
    
    always @(*)
        begin
//            $display("sig = %d", sig);
            if (sig == 4'b0001)
                begin
                    Reg31_addr <= ID_RegS_addr;
//                    $display("ID_RegS_addr = %x", ID_RegS_addr);
                end
            else if (sig == 4'b0010)
                begin
                    Reg31_addr <= ALU_res_addr;
//                    $display("ALU_res_addr = %x", ALU_res_addr);
                end
            else if (sig == 4'b0100)
                begin
                    Reg31_addr <= EXE_MEM_write_reg_addr;
//                    $display("EXE_MEM_write_reg_addr = %x", EXE_MEM_write_reg_addr);
                end
            else if (sig == 4'b1000)
                begin
                    Reg31_addr <= MEM_WB_write_reg_addr;
//                    $display("MEM_WB_write_reg_addr = %x", MEM_WB_write_reg_addr);
                end 
                
        end
endmodule
