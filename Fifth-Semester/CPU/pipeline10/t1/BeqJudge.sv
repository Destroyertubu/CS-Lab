`timescale 1us/1us

module BeqJudge(
    input clk,
    input [31:0] RegS,
    input [31:0] RegT,
    output reg resBeq
);  
    reg [31:0] s;
    reg [31:0] t;

    always @(RegS or RegT) begin
        s = RegS;
        t = RegT;
        if (s == t)
            begin
//                $display("1 RegS = %x, RegT = %x", s, t);
                resBeq <= 1;
            end
        else 
            begin
//                $display("0 RegS = %x, RegT = %x", s, t);
                 resBeq <= 0;  
            end
    end


endmodule