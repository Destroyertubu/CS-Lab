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
    input [3:0] sig,
    output reg [31:0] bypass_out_data
    );
    
        always @(*)
        begin
//            $display("sig = %d", sig);
            if (sig == 4'b0001)
                begin
                    bypass_out_data <= Read_Data;
//                    $display("ID_RegS_addr = %x", ID_RegS_addr);
                end
            else if (sig == 4'b0010)
                begin
                    bypass_out_data <= ALU_res;
//                    $display("ALU_res_addr = %x", ALU_res_addr);
                end
            else if (sig == 4'b0100)
                begin
                    bypass_out_data <= EXE_MEM_write_data;
//                    $display("EXE_MEM_write_data = %x", EXE_MEM_write_data);
                end
            else if (sig == 4'b1000)
                begin
                    bypass_out_data <= MEM_WB_write_data;
//                    $display("MEM_WB_write_data = %x", MEM_WB_write_data);
                end 
                
        end
    
    
endmodule
