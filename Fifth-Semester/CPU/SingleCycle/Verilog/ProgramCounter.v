`timescale 1ns/1ps


module ProgramCounter(
    input clk,
    input reset,
    input [31:0] addr,
    input j_s,
    input jal,
    output reg [31:0] pc
);
    reg [31:0] tmp;
    reg mark;
    initial begin
        pc <= 32'h00003000;
        mark <= 0;
    end
    
    

    always @(negedge clk) 
        begin
                begin 
                    if (j_s == 1'b1 && mark == 0)
                        begin
                            tmp = addr;
                            mark = 1;
                            pc = pc + 4;
                        end
                     else if (mark == 1)
                        begin
                            pc = tmp;
                            mark = 0;
                        end
                     else 
                        begin
                            pc = addr;
                        end
                    
                    $display("pc = %x", pc);
                end
        end

endmodule