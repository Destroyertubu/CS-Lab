`timescale 1ns/1ps

module AdventureDetect(
    input [4:0] RegS,
    input [4:0] RegT,
    input [5:0] ID_EXE_opcode,
    input [4:0] ID_EXE_WriteReg,
    output reg [2:0] PC_Write,
    output reg [2:0] IF_ID_Write,
    output reg [2:0] ID_EX_Write
);
    reg [31:0] lw_cnt;
    reg conflict;
    
    reg [5:0] tmp_ID_EXE_opcode;
    reg [5:0] tmp_EXE_MEM_opcode;
    reg [5:0] tmp_MEM_WB_opcode;
    reg [5:0] tmp_EXE_MEM_func;
    reg [5:0] tmp_MEM_WB_func;
    
    
    initial begin
        PC_Write <= 3'b111;
        IF_ID_Write <= 3'b111;
        ID_EX_Write <= 3'b111;
        lw_cnt <= 0;;
        conflict <= 0;
    end
    
    

    always @(*) begin
//        $display("ID_EXE_zero_flag = %d, ID_EXE_ins = %x",ID_EXE_zero_flag, ID_EXE_ins);
        PC_Write <= 3'b111;
        IF_ID_Write <= 3'b111;
        ID_EX_Write <= 3'b111;
        
//        $display();

        if (ID_EXE_opcode == 6'b100011 && (ID_EXE_WriteReg != 0 && (ID_EXE_WriteReg == RegS || ID_EXE_WriteReg == RegT)))
            begin
//                    $display("ID_EXE_WriteReg = %d", ID_EXE_WriteReg);
                    PC_Write <= 3'b000;
                    IF_ID_Write <= 3'b010;
                    ID_EX_Write <= 3'b000;
            end

    end


endmodule