`timescale 1ns / 1ps

// for add or sub
module Adder(A, B, flag, sum, over);
    input [31:0] A, B;
    input flag;
    output [31:0] sum;
    output over;
    wire [31:0] sum_temp;
    wire over_temp;
    assign sum_temp = A + B;
    assign over_temp = (A[31] == B[31]) && (A[31] != sum_temp[31]);
    assign sum = flag ? sum_temp : A - B;
    assign over = flag ? over_temp : 0;
    
//    always @(*) begin
//        $display("A = %x, B = %x, Sum = %x", A, B, sum);
//    end
endmodule
