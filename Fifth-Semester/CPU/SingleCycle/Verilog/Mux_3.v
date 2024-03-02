`timescale 1ns/1ps

module Mux_3(input [4:0] a, input [4:0] b, input [4:0] c, input [2:0] sel, output reg [4:0] out);

    always @(a or b or c or sel) begin
//        $display("Mux_3 sel = %x, a = %x, b = %x, c = %x", sel, a, b, c);
        if (sel == 3'b001) begin
            out <= a;
//            $display("Mux_3_out 1 = %d", out);
        end
        else if (sel == 3'b010) begin
            out <= b;
//            $display("Mux_3_out 2 = %d", out);
        end
        else begin
            out <= c;
//            $display("Mux_3_out 3 = %d", out);
        end
        
        
    end
endmodule