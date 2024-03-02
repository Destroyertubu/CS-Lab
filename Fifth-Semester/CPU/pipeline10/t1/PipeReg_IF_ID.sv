`timescale 1us/1us


module PipeReg_IF_ID(
    input clock,
    input [31:0] ins,
    input [2:0] IF_ID_Write,
    input [31:0] instruction,
    input [31:0] pc_plus_4,
    output reg [31:0] instruction_out,
    output reg [31:0] pc_plus_4_out
);
    reg [31:0] tmp_ins;
    reg [31:0] tmp_pc_plus_4;
    reg beq;
    
    always @(IF_ID_Write or instruction or pc_plus_4) begin
//        $display("ins = %x, IF_ID_Write = %x", instruction ,IF_ID_Write);
        if (IF_ID_Write == 3'b111)
                begin
                    tmp_ins <= instruction;
                    tmp_pc_plus_4 <= pc_plus_4;
                end
             else if (IF_ID_Write == 3'b010) 
                begin
                    tmp_ins <= instruction_out;
                    tmp_pc_plus_4 <= pc_plus_4_out;
                end
             else if (IF_ID_Write == 3'b000)
                begin
                    tmp_ins <= 0;
                    tmp_pc_plus_4 <= 0;
                end
           
           end
    always @(negedge clock) 
        begin
            instruction_out <= tmp_ins;
            pc_plus_4_out <= tmp_pc_plus_4;
           
            if (tmp_ins[31:26] == 6'b000100)
                begin
                    beq = 1;
                end
            else 
                begin
                    beq = 0;
                end   
             
//            $display("IF_ID instruction_out = %x, pc_plus_4_out = %x beq = %d, opcode = %x", 
//            tmp_ins, tmp_pc_plus_4, beq, tmp_ins[31:26]);
        end

endmodule