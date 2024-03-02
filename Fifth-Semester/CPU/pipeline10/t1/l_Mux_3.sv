`timescale 1us/1us

module l_Mux_3(
        input [31:0] a, 
        input [31:0] b, 
        input [31:0] c,
        input [2:0] sel, 
        input [31:0] pc_plus_4,
        output reg [31:0] out);

    always @(*) begin
//        $display("Mux_3 sel = %x, a = %x, b = %x, c = %x, pc_plus_4 = %x", sel, a, b, c, pc_plus_4);
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