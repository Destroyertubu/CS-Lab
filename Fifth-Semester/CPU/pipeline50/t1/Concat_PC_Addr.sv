`timescale 1ns/1ps


module Concat_PC_Addr(
    input [31:0] pc,
    input [31:0] imm_num,
    output reg [31:0] addr
);
    always @(*) begin
        addr <= {pc[31:28], imm_num[27:0]};
    end


endmodule