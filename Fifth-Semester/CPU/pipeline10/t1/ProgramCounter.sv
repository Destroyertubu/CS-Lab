`timescale 1ns/1ps


module ProgramCounter(
    input clk,
    input reset,
    input [31:0] addr,
    input [2:0] PC_Write,
    output reg [31:0] pc
);
    reg [31:0] tmp_pc;
    initial begin
        pc = 32'h00003000;
    end
    
    
    
    always @(addr) 
        begin
            if (PC_Write == 3'b111)
                begin
//                    $display("pc input addr = %x, old_pc = %x", addr, pc);
                end
            else 
                begin
//                    $display("pc repeat addr = %x, old_pc = %x", pc, pc);
                end
        end

    always @(negedge clk) 
        begin
//            $display("PC_clock");
            if (PC_Write == 3'b111)
                begin
                    pc <= addr;
//                    $display("pc output addr = %x", addr);
                end
            else 
                begin
                    pc <= pc;
//                    $display("pc repeat addr = %x", pc);
                end   
             
        end
endmodule