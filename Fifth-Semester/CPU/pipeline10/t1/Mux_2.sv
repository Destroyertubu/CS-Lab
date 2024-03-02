`timescale 1us/1us

module Mux_2(input [31:0] a, input [31:0] b, input sel, input [3:0] Mux_Tag, output reg [31:0] out, input [2:0] mark);

    always @(*) begin
        if (sel == 1) begin
            out <= a;
//             $display("1 Mux_2 %d, out = %x, a = %x, b = %x", mark, a, a, b);
        end
        else begin
            out <= b;
//             $display("0 Mux_2 %d,  out = %x, a = %x, b = %x", mark, b, a, b);
        end
    end
    
endmodule