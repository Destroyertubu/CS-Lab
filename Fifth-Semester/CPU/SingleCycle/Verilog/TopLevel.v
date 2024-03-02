`timescale 1ns/1ps

module TopLevel(
    input clock,
    input reset   
);

    wire [31:0] PC_to_IM;
    wire [31:0] IM_OUT;
    wire [31:0] PC_to_pcAdder;
    wire [31:0] PC_to_Adder;
    wire [31:0] PC_to_Mux_2_1;


    wire [5:0] Ins_op;
    wire [4:0] Ins_Rs;
    wire [4:0] Ins_Rt;
    wire [4:0] Ins_Rd;
    wire [15:0] Ins_imm16;
    wire [31:0] Ins_Addr;
    wire [5:0] Ins_func;


    wire [31:0] Sl2_To_Cpa;

    wire jal_c;
    wire branch_c;
    wire jr_c;
    wire MemoRead_c;
    wire MemoWrite_c;
    wire MemoToReg_c;
    wire [3:0] ALU_Op_c;
    wire ALU_src_c;
    wire RegWrite_c;
    wire [2:0] RegDst_c;
    wire [4:0] jal_Reg_c;

    wire [4:0] Mux_3_1_Out;
    wire [31:0] Mux_To_PC;
    
    wire [31:0] Mux_2_6_To_GPR;
    wire [31:0] cpa_to_Mux_2_2;
    
    
    wire [31:0] Mux_2_5_To_GPR;
    wire [31:0] GR_OUT_D1;
    wire [31:0] GR_OUT_D2;
    
    wire [31:0] se_out;
    wire [31:0] Mux_2_4_To_ALU;
    wire [31:0] Mux_2_7_To_ALU;
    
    wire [31:0] shift_left_32;
    wire [31:0] Mux_2_3_out;
    
    wire alu_zero;
    wire [31:0] ALU_OUT;
    
    
    wire [31:0] Mux_2_2_out;
    wire [31:0] Adder_to_Mux_2_1;
    wire overflow;
    wire [31:0] Mux_2_1_out;
    wire [31:0] mux_2_5_out;
    wire [31:0] MD_to_Mux_2_5;
    wire [3:0] acs;    // alu
    wire AND_res;
    wire lui_mark;
    
    
    
    
    assign PC_to_IM = PC_to_pcAdder;
    assign Ins_op = IM_OUT[31:26];
    assign Ins_Rs = IM_OUT[25:21];
    assign Ins_Rt = IM_OUT[20:16];
    assign Ins_Rd = IM_OUT[15:11];
    assign Ins_imm16 = IM_OUT[15:0];
    assign Ins_Addr = IM_OUT[25:0];
    assign Ins_func = IM_OUT[5:0];


    ProgramCounter pc(
        .clk(clock),
        .j_s(jal_c | jr_c  | AND_res),
        .jal(jal_c),
        .reset(reset),
        .addr(Mux_To_PC),
        .pc(PC_to_pcAdder)
    );

    pcAdder pcAd(
        .pc(PC_to_pcAdder),
        .mod_pc(PC_to_Adder)
    );

    InstructionMemory im(
        .ins_addr(PC_to_IM),
        .ins(IM_OUT)
    );

    CU cu(
        .opcode(IM_OUT[31:26]),
        .func(Ins_func),
        .jal(jal_c),
        .Branch(branch_c),
        .jr(jr_c),
        .MemoRead(MemoRead_c),
        .MemoWrite(MemoWrite_c),
        .MemoToReg(MemoToReg_c),
        .alu_op_code(ALU_Op_c),
        .alu_src(ALU_src_c),
        .regWrite(RegWrite_c),
        .regDst(RegDst_c),
        .jal_reg(jal_Reg_c),
        .lui_mark(lui_mark)
    );
    
    
    
    Shift_Left sl2(
        .addr(Ins_Addr),
        .addr_shift_left(Sl2_To_Cpa)
    );

    Concat_PC_Addr CPA(
        .pc(PC_to_Adder),
        .imm_num(Sl2_To_Cpa),
        .addr(cpa_to_Mux_2_2)
    );

    Mux_3  mux_3_1(
        .a(Ins_Rd),
        .b(Ins_Rt),
        .c(jal_Reg_c),
        .sel(RegDst_c),
        .out(Mux_3_1_Out)
    );

    GPR RegisterFile(
        .clk(clock),
        .Reset(reset),
        .WR(RegWrite_c),
        .jal(jal_c),
        .rd_r1(Ins_Rs),
        .rd_r2(Ins_Rt),
        .mod_reg(Mux_3_1_Out),
        .in_data(Mux_2_6_To_GPR),
        .out_data1(GR_OUT_D1),
        .out_data2(GR_OUT_D2),
        .programCounter(PC_to_pcAdder)
    );

    Sign_Ext se(
        .imm_num(Ins_imm16),
        .opcode(IM_OUT[31:26]),
        .Sign_ext(se_out)
    );

    Shift_Left_2 sl4(
        .addr(se_out),
        .addr_shift_left(shift_left_32)
    );

    Adder adder(
        .A(shift_left_32),
        .B(PC_to_Adder),
        .flag(1'b1),
        .sum(Adder_to_Mux_2_1),
        .over(overflow)
    );
    
    Mux_2 Mux_2_7(
        .a(se_out),
        .b(GR_OUT_D1),
        .sel(lui_mark),
        .out(Mux_2_7_To_ALU),
        .Mux_Tag(4'b0111)
    );

    Mux_2 Mux_2_4(
        .a(se_out),
        .b(GR_OUT_D2),
        .sel(ALU_src_c),
        .out(Mux_2_4_To_ALU),
        .Mux_Tag(4'b0100)
    );
    

    ALU alu_v(
        .A(Mux_2_7_To_ALU),
        .B(Mux_2_4_To_ALU),
        .op(ALU_Op_c),
        .clk(clock),
        .result(ALU_OUT),
        .zero(alu_zero),
        .programCounter(PC_to_Adder)
    );


    DataMemory DM(
        .addr(ALU_OUT),
        .clk(clock),
        .WR(MemoWrite_c),
        .RD(MemoRead_c),
        .write_data(GR_OUT_D2),
        .reset(reset),
        .read_data(MD_to_Mux_2_5),
        .programCounter(PC_to_pcAdder)
    );

    
    Mux_2 mux_2_5(
        .a(MD_to_Mux_2_5),
        .b(ALU_OUT),
        .sel(MemoToReg_c),
        .out(mux_2_5_out),
        .Mux_Tag(4'b0101)
    );
    
    
    Mux_2 mux_2_6(
        .a(PC_to_Adder),
        .b(mux_2_5_out),
        .sel(jal_c),
        .out(Mux_2_6_To_GPR),
        .Mux_Tag(4'b0110)
    );
    

    AND and_gate(
        .A(branch_c),
        .B(alu_zero),
        .out(AND_res)
    );



    Mux_2 Mux_2_1(
        .a(Adder_to_Mux_2_1),
        .b(PC_to_Adder),
        .sel(AND_res),
        .out(Mux_2_1_out),
        .Mux_Tag(4'b0001)
    );


    Mux_2 Mux_2_2(
        .a(cpa_to_Mux_2_2),
        .b(Mux_2_1_out),
        .sel(jal_c),
        .out(Mux_2_2_out),
        .Mux_Tag(4'b0010)
    );
    
    Mux_2 Mux_2_3(
        .a(ALU_OUT),
        .b(Mux_2_2_out),
        .sel(jr_c),
        .out(Mux_2_3_out),
        .Mux_Tag(4'b0011)
    );

    assign Mux_To_PC = Mux_2_3_out;

endmodule