`timescale  1ns/1ps

module Shift_Left(
    input [31:0] addr,
    output reg [31:0] addr_shift_left
    );

    always @(addr) begin
        addr_shift_left <= addr << 2;
    end

endmodule
