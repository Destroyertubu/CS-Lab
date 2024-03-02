`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/07 14:59:18
// Design Name: 
// Module Name: ByPass_Mux_4
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


module ByPass_Mux_4(
    input [31:0] Read_Data,
    input [31:0] ALU_res,
    input [31:0] EXE_MEM_write_data,
    input [31:0] MEM_WB_write_data,
    input [31:0] ins,
    input [3:0] sig,
    output reg [31:0] bypass_out_data
    );
    
        always @(*)
        begin
//            $display("IF_ID_ins = %x, ID data = %x, EXE data = %x, MEM data = %x, WB data = %x", ins, Read_Data, ALU_res, EXE_MEM_write_data, MEM_WB_write_data);
            if (sig == 4'b0001)
                begin
                    bypass_out_data <= Read_Data;
//                    $display("ID_ReadData = %x, IF_ID_ins = %x", Read_Data, ins);
                end
            else if (sig == 4'b0010)
                begin
                    bypass_out_data <= ALU_res;
//                    $display("ALU_res = %x, IF_ID_ins = %x", ALU_res, ins);
                end
            else if (sig == 4'b0100)
                begin
                    bypass_out_data <= EXE_MEM_write_data;
//                    $display("EXE_MEM_write_data = %x, IF_ID_ins = %x", EXE_MEM_write_data, ins);
                end
            else if (sig == 4'b1000)
                begin
                    bypass_out_data <= MEM_WB_write_data;
//                    $display("MEM_WB_write_data = %x, IF_ID_ins = %x", MEM_WB_write_data, ins);
                end 
                
        end
    
    
endmodule
