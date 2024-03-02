`timescale 1ns/1ps

module Mux_2(input [31:0] a, input [31:0] b, input sel, input [3:0] Mux_Tag, output reg [31:0] out);

    always @(*) begin
        if (sel == 1) begin
            out <= a;
        end
        else begin
            out <= b;
        end
    end
    
endmodule