`timescale 1us/1us

module Mux_3(
        input [4:0] a, 
        input [4:0] b, 
        input [4:0] c,
        input [2:0] sel, 
        input [31:0] ins,
        output reg [4:0] out);

    always @(a or b or c or sel) begin
//         $display("Mux_3 sel = %x, a = %x, b = %x, c = %x, ins = %x", sel, a, b, c, ins);
        if (sel == 3'b001) begin
            out <= a;
            // $display("Mux_3_out 1 = %d", a);
        end
        else if (sel == 3'b010) begin
            out <= b;
            // $display("Mux_3_out 2 = %d", b);
        end
        else if (sel == 3'b100)begin
            out <= c;
            // $display("Mux_3_out 3 = %d", c);
        end
        
        
    end
endmodule