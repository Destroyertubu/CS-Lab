`timescale 1us/1us

`include "MyStructure.sv"

module TopLevel(
    input clock,
    input reset   
);

    wire [31:0] Mux_2_7_out;
    wire busy;
    wire start;
    
    wire [31:0] MD_read_data;
    wire [4:0] Sp_mark;

    wire out_bgtz_sig;
    wire out_blez_sig;
    wire out_bgez_sig;
    wire out_bltz_sig;

    wire [31:0] MEM_WB_pc_plus_4;

    wire ID_EXE_zero_flag;
     ControlSignal ID_EXE_out_CS;
     wire EXE_MEM_out_zero_flag;
    
    wire [4:0] EXE_MEM_out_Write_Reg;
    wire [4:0] MEM_WB_out_Write_Reg;
    
    wire [5:0] ID_EXE_func;
    wire [5:0] EXE_MEM_out_func;
    wire [5:0] MEM_WB_out_func;
        
    wire alu_out_zero_flag;
    wire MEM_WB_out_branch_zero_flag;
    wire alu_zero_flag;

    wire [31:0] MEM_WB_out_pc_plus8;
    
    wire [31:0] MEM_WB_branch_addr;
    wire [31:0] MEM_WB_jal_j_addr;
    wire [31:0] MEM_WB_jr_addr;
    wire MEM_WB_out_branch_sig;
    wire MEM_WB_out_jal_sig;
    wire MEM_WB_out_j_sig;
    wire MEM_WB_out_jr_sig;
    
    wire [31:0] EXE_MEM_out_ALU_res;
    wire [31:0] Mux_2_3_out;
    wire [2:0] ForwardA;
    wire [2:0] ForwardB;
    wire [31:0] mux_3_1_out;
    wire [31:0] mux_3_2_out;
    
    MuxMixSig MEM_WB_out_mms;
    Mix_Addr MEM_WB_out_MA;


// -----------------------------------   IF  BEGIN
    wire [31:0] PC_out;
    wire [31:0] MuxMixAddr_to_PC;

    wire [2:0] PC_Write_ad_out;
    
    
    wire ID_EXE_to_ADVD_MemoWrite;
    wire ID_EXE_to_ADVD_MemoRead;
    wire ID_EXE_to_ADVD_RegWrite;
    wire ID_EXE_to_ADVD_MemoToReg;
//    wire PC_Write_ad_out;


    wire [31:0] IF_ID_instruction_out;
    wire [31:0] pc_plus_4_to_ID_EX;
    wire [2:0] IF_ID_Write_ad_out;

    
    wire [4:0] WriteReg_Mux3_out_to_ADVD;
    wire [2:0] ID_EXE_Write_ad_out;
    wire [31:0] ID_EXE_out_pc_plus4;
    wire [31:0] EXE_MEM_out_pc_plus4;
    wire ID_zero_flag;
    
    
    wire [4:0] RegS;
    wire [4:0] RegT;
    wire [4:0] RegD;
    wire [15:0] Imm;
    wire [5:0] Funct;
    wire [5:0] OpCode;
    wire [31:0] SignExtImm;
    wire [4:0] Shamt;
    
    wire [31:0] ID_EXE_out_ReadData1;
    wire [31:0] ID_EXE_out_ReadData2;
    Write_Reg ID_EXE_out_WriteRegs;
    Read_Reg ID_EXE_out_ReadRegs;
    wire [31:0] ID_EXE_out_SignExtImm;
    wire [31:0] ID_EXE_out_addr_26;
    
    wire [31:0] J_A_out_addr;
    
    ControlSignal CU_out_CS;
    MultDivCs CU_out_mdcs;
    
    wire [3:0] ForwardC;
    wire [3:0] ForwardD;
    
    wire [31:0] by_Mux_4_1_out;
    wire [31:0] by_Mux_4_2_out;
    
    wire [31:0] ALU_res_to_EXE_MEM;
    wire [4:0] mux3_3_out;
    
    wire [31:0] alu_or_memoData_out;

    ProgramCounter PC(
        .clk(clock),
        .reset(reset),
        .addr(MuxMixAddr_to_PC),
        .pc(PC_out),
        .PC_Write(PC_Write_ad_out)
    );

    wire [31:0] instruction_to_IF_ID;

    InstructionMemory IM(
        .ins_addr(PC_out),
        .ins(instruction_to_IF_ID)
    );

    wire [31:0] pc_plus_4;

    pcAdder PCAdder(
        .pc(PC_out),
        .mod_pc(pc_plus_4)
    );
    
    Mix_Addr EXE_MEM_out_mix_addr;
    MuxMixSig EXE_MEM_out_mms;

    MuxMixAddr muxMixAddr(
        .ins(IF_ID_instruction_out),
        .ID_opcode(OpCode),
        .jump_addr(J_A_out_addr),
        .pc_plus4(pc_plus_4),
        .branch_sig(CU_out_CS.Branch),
        .branch_zero_sig(ID_zero_flag),
        .jal_sig(CU_out_CS.jal),
        .j_sig(CU_out_CS.j),
        .jr_sig(CU_out_CS.jr),
        .jalr_sig(CU_out_CS.jalr),
        .bgtz_sig(out_bgtz_sig),
        .blez_sig(out_blez_sig),
        .bgez_sig(out_bgez_sig),
        .bltz_sig(out_bltz_sig),
        .sp_mark(Sp_mark),
        .out_addr(MuxMixAddr_to_PC)
    );
    
    



// -----------------------------------   IF  END

// -----------------------------------   IF/ID Pipeline Reg



    PipeReg_IF_ID pr_IF_ID(
        .clock(clock),
        .IF_ID_Write(IF_ID_Write_ad_out),
        .instruction(instruction_to_IF_ID),
        .pc_plus_4(pc_plus_4),
        .instruction_out(IF_ID_instruction_out),
        .pc_plus_4_out(pc_plus_4_to_ID_EX)
    );
// -----------------------------------   IF/ID Pipeline Reg

// -----------------------------------   ID   BEGIN


    assign RegS = IF_ID_instruction_out[25:21];
    assign RegT = IF_ID_instruction_out[20:16];
    assign RegD = IF_ID_instruction_out[15:11];
    assign Imm = IF_ID_instruction_out[15:0];
    assign Funct = IF_ID_instruction_out[5:0];
    assign OpCode = IF_ID_instruction_out[31:26];
    assign Imm = IF_ID_instruction_out[15:0];
    assign Shamt = IF_ID_instruction_out[10:6];
    
    assign Sp_mark = IF_ID_instruction_out[20:16];
    
    wire [31:0] ext_shamt;
    
    assign ext_shamt = {27'b000000000000000000000000000, Shamt};
    
    
    wire [25:0] Addr26;
    
    assign Addr26 = IF_ID_instruction_out[25:0];
    
   



    AdventureDetect advdet(
        .ID_EXE_opcode(ID_EXE_out_CS.opcode),
        .ID_EXE_WriteReg(mux3_3_out),
        .RegS(RegS),
        .RegT(RegT),
        .busy(busy & CU_out_mdcs.is_MD),
        .PC_Write(PC_Write_ad_out),
        .IF_ID_Write(IF_ID_Write_ad_out),
        .ID_EX_Write(ID_EXE_Write_ad_out),
        .start(start)
    );

    

    CU cu(
        .opcode(OpCode),
        .CU_wr(IF_ID_Write_ad_out),
        .func(Funct),
        .shamt(Shamt),
        .regD(RegD),
        .ins(IF_ID_instruction_out),
        .cs(CU_out_CS),
        .mdcs(CU_out_mdcs)
    );

    wire MEM_WB_out_RegWriteW;
    
    wire [31:0] Mux_2_4_out;
    wire [31:0] GPR_to_ID_EXE_RegReadData_1;
    wire [31:0] GPR_to_ID_EXE_RegReadData_2;

    GPR Register_File(
        .clk(clock),
        .Reset(reset),
        .WR(MEM_WB_out_RegWriteW),
        .programCounter(MEM_WB_pc_plus_4),
        .rd_r1(RegS),
        .rd_r2(RegT),
        .mod_reg(MEM_WB_out_Write_Reg),
        .ins(MEM_WB_out_CS.ins),
        .in_data(Mux_2_3_out),
        .out_data1(GPR_to_ID_EXE_RegReadData_1),
        .out_data2(GPR_to_ID_EXE_RegReadData_2)
    );
    
    ByPass_Mux_4 bypass_mux4_1(
        .Read_Data(GPR_to_ID_EXE_RegReadData_1),
        .ins(IF_ID_instruction_out),
        .ALU_res(Mux_2_7_out),
        .EXE_MEM_write_data(alu_or_memoData_out),
        .MEM_WB_write_data(Mux_2_3_out),
        .sig(ForwardC),
        .bypass_out_data(by_Mux_4_1_out)
    );
    
    ByPass_Mux_4 bypass_mux4_2(
        .ins(IF_ID_instruction_out),
        .Read_Data(GPR_to_ID_EXE_RegReadData_2),
        .ALU_res(Mux_2_7_out),
        .EXE_MEM_write_data(alu_or_memoData_out),
        .MEM_WB_write_data(Mux_2_3_out),
        .sig(ForwardD),
        .bypass_out_data(by_Mux_4_2_out)
    );
    
    
    BeqJudge bj(
//        .ins(pc_plus_4_to_ID_EX),
        .clk(clock),
        .regs_(RegS),
        .regt_(RegT),
        .RegS(by_Mux_4_1_out),
        .RegT(by_Mux_4_2_out),
        .resBeq(ID_zero_flag),
        .bgtz_sig(out_bgtz_sig),
        .blez_sig(out_blez_sig),
        .bgez_sig(out_bgez_sig),
        .bltz_sig(out_bltz_sig)
    );

    Sign_Ext SE(
        .imm_num(Imm),
        .sign_sig(CU_out_CS.sign_ext_sig),
        .Sign_ext(SignExtImm)
    );
    
    wire [31:0] Mux_4_out;
    
    Mux_4 mux4_reg_addr(
        .ID_RegS_addr(GPR_to_ID_EXE_RegReadData_1),
        .ALU_res_addr(Mux_2_7_out),
        .EXE_MEM_write_reg_addr(alu_or_memoData_out),
        .MEM_WB_write_reg_addr(Mux_2_3_out),
        .sig(ForwardC),
        .Reg31_addr(Mux_4_out)
    );
    
    Jump_Analyse J_A(
        .pc_plus_4(pc_plus_4_to_ID_EX),
        .ins(IF_ID_instruction_out),
        .sign_ext_imm(SignExtImm),
        .addr_26(Addr26),
        .jr_reg_addr(Mux_4_out),
        .branch_sig(CU_out_CS.Branch),
        .jal_sig(CU_out_CS.jal),
        .jr_sig(CU_out_CS.jr),
        .j_sig(CU_out_CS.j),
        .Jump_Addr(J_A_out_addr)
    );

// -----------------------------------   ID  END
 
// -----------------------------------   ID/EXE  BEGIN

   
   wire [31:0] ID_EXE_out_ext_shamt;

    MultDivCs ID_EXE_out_mdcs;
    

    PipeReg_ID_EXE pr_ID_EXE(
        .clock(clock),
        .in_zero_flag(ID_zero_flag),
        .ins(IF_ID_instruction_out),
        .ID_EXE_Write(ID_EXE_Write_ad_out),
        .cs(CU_out_CS),
        .mdcs(CU_out_mdcs),
        .ReadData1(GPR_to_ID_EXE_RegReadData_1),
        .ReadData2(GPR_to_ID_EXE_RegReadData_2),
        .RegS(RegS),
        .RegT(RegT),
        .RegD(RegD),
        .SignExt_Imm(SignExtImm),
        .addr_26(IF_ID_instruction_out[25:0]),
        .pc_plus4(pc_plus_4_to_ID_EX),
        .input_ext_shamt(ext_shamt),
        .out_cs(ID_EXE_out_CS),
        .out_mdcs(ID_EXE_out_mdcs),
        .out_ReadData1(ID_EXE_out_ReadData1),
        .out_ReadData2(ID_EXE_out_ReadData2),
        .out_wr(ID_EXE_out_WriteRegs),
        .out_rr(ID_EXE_out_ReadRegs),
        .out_sign_imm(ID_EXE_out_SignExtImm),
        .out_addr_26(ID_EXE_out_addr_26),
        .out_pc_plus4(ID_EXE_out_pc_plus4),
        .ID_EXE_func(ID_EXE_func),
        .ID_EXE_zero_flag(ID_EXE_zero_flag),
        .out_ID_EXE_ext_shamt(ID_EXE_out_ext_shamt)
    );
    
    

// -----------------------------------   ID/EXE   END


// -----------------------------------   EXE  BEGIN

    assign ID_EXE_to_ADVD_MemoWrite = ID_EXE_out_CS.MemoWrite;
    assign ID_EXE_to_ADVD_MemoRead = ID_EXE_out_CS.MemoRead;
    assign ID_EXE_to_ADVD_RegWrite = ID_EXE_out_CS.regWrite;
    assign ID_EXE_to_ADVD_MemoToReg = ID_EXE_out_CS.MemoToReg;



    l_Mux_3 mux3_1(
        .a(alu_or_memoData_out),
        .b(ID_EXE_out_ReadData1),
        .c(Mux_2_3_out),
        .pc_plus_4(ID_EXE_out_pc_plus4),
        .sel(ForwardA),
        .out(mux_3_1_out)
    );

    l_Mux_3 mux3_2(
        .a(alu_or_memoData_out),
        .b(ID_EXE_out_ReadData2),
        .c(Mux_2_3_out),
        .pc_plus_4(ID_EXE_out_pc_plus4),
        .sel(ForwardB),
        .out(mux_3_2_out)
    );

    wire [31:0] Mux_2_1_out;
    wire [31:0] Mux_2_2_out;

    Mux_2 mux2_1(
        .a(mux_3_1_out),
        .b(ID_EXE_out_SignExtImm),
        .sel(ID_EXE_out_CS.lui_mark),
        .out(Mux_2_1_out),
        .mark(3'b001)
    );

    Mux_2 mux2_2(
        .a(mux_3_2_out),
        .b(ID_EXE_out_SignExtImm),
        .sel(ID_EXE_out_CS.alu_src),
        .out(Mux_2_2_out),
        .mark(3'b010)
    );
    
    wire [31:0] Mux_2_6_out;
    
    Mux_2 mux2_6(
        .a(ID_EXE_out_ext_shamt),
        .b(Mux_2_1_out),
        .sel(ID_EXE_out_CS.shift_sig),
        .out(Mux_2_6_out)
    );
    
    wire [31:0] Mux_2_5_out;
    
    Mux_2 mux2_5(
        .a(ID_EXE_out_pc_plus4),
        .b(Mux_2_2_out),
        .sel(ID_EXE_out_CS.jal || ID_EXE_out_CS.jalr),
        .out(Mux_2_5_out),
        .mark(3'b101)
    );

    wire [31:0] Data_to_Memory;

    assign Data_to_Memory = mux_3_2_out;

  
    

    ALU alu_sv(
        .A(Mux_2_6_out),
        .B(Mux_2_5_out),
        .op(ID_EXE_out_CS.alu_op_code),
        .result(ALU_res_to_EXE_MEM),
        .zero(alu_out_zero_flag),
        .programCounter(ID_EXE_out_pc_plus4)
    );
    
    
    MultiplicationDivisionUnit mdu(
        .clock(clock),
        .reset(reset),
        .operand1(Mux_2_1_out),
        .operand2(Mux_2_2_out),
        .operation(ID_EXE_out_mdcs.MD_opcode),
        .start(start),
        .busy(busy),
        .dataRead(MD_read_data)
    );
    
    Mux_2 mux2_7(
        .a(MD_read_data),
        .b(ALU_res_to_EXE_MEM),
        .sel(ID_EXE_out_mdcs.MD_read),
        .out(Mux_2_7_out)
    );
    
    
    assign alu_zero_flag = alu_out_zero_flag;

    Mux_3 mux3_3(
        .ins(ID_EXE_out_CS.ins),
        .a(ID_EXE_out_WriteRegs.regd_write1),
        .b(ID_EXE_out_WriteRegs.regt_write2),
        .c(ID_EXE_out_WriteRegs.reg31_jal),
        .sel(ID_EXE_out_CS.regDst),
        .out(mux3_3_out)
    );

    assign WriteReg_Mux3_out_to_ADVD = mux3_3_out;

    wire [4:0] out_MEM_WB_Write_Reg;
    
    wire EXE_MEM_out_RegWriteW;


    ForwardingUnit FU(
        .in_rr(ID_EXE_out_ReadRegs),
        .IF_ID_ins(IF_ID_instruction_out),
        .IF_ID_RegS(RegS),
        .IF_ID_RegT(RegT),
        .ID_EXE_WriteReg(mux3_3_out),
        .ID_EXE_RegWrite(ID_EXE_out_CS.regWrite),
        .MEM_WB_Write_Reg(MEM_WB_out_Write_Reg),
        .EXE_MEM_Write_Reg(EXE_MEM_out_Write_Reg),
        .MEM_WB_RegWriteW(MEM_WB_out_RegWriteW),
        .EXE_MEM_RegWriteW(EXE_MEM_out_RegWriteW),
        .out_forwardA(ForwardA),
        .out_forwardB(ForwardB),
        .out_forwardC(ForwardC),
        .out_forwardD(ForwardD),
        .pc_plus_4(ID_EXE_out_pc_plus4)
    );

    wire [31:0] sl2_1_out;
    wire [31:0] sl2_2_out;
    
    wire [31:0] adder_1_out;
    wire [31:0] cpa_out;

    wire overflag;

// -----------------------------------   EXE  END

// -----------------------------------   EXE/MEM BEGIN


    ControlSignal EXE_MEM_out_CS;
    
    wire [31:0] EXE_MEM_Data_to_Memory;
    
    
    
    

    PipeReg_EXE_MEM pr_EXE_MEM(
        .clock(clock),
        .ins(ID_EXE_out_CS.ins),
        .cs(ID_EXE_out_CS),
        .ALU_res(Mux_2_7_out),
        .Data_to_Mem(Data_to_Memory),
        .write_reg(mux3_3_out),
        .pc_plus4(ID_EXE_out_pc_plus4),
        .out_cs(EXE_MEM_out_CS),
        .out_ALU_res(EXE_MEM_out_ALU_res),
        .out_Data_to_Mem(EXE_MEM_Data_to_Memory),
        .out_write_reg(EXE_MEM_out_Write_Reg),
        .out_mix_addr(EXE_MEM_out_mix_addr),
        .out_pc_plus4(EXE_MEM_out_pc_plus4),
        .out_zero_flag(EXE_MEM_out_zero_flag),
        .EXE_MEM_func(EXE_MEM_out_func)
    );
    
    assign EXE_MEM_out_RegWriteW = EXE_MEM_out_CS.regWrite;


// -----------------------------------   EXE/MEM END

// -----------------------------------   MEM BEGIN


    wire [31:0] out_DM_ReadData;

    DataMemory DM(
        .clk(clock),
        .reset(reset),
        .WR(EXE_MEM_out_CS.MemoWrite),
        .RD(EXE_MEM_out_CS.MemoRead),
        .opcode(EXE_MEM_out_CS.opcode),
        .addr(EXE_MEM_out_ALU_res),
        .write_data(EXE_MEM_Data_to_Memory),
        .programCounter(EXE_MEM_out_pc_plus4),
        .read_data(out_DM_ReadData)
    );
    
    Mux_2 alu_or_memoData(
        .a(out_DM_ReadData),
        .b(EXE_MEM_out_ALU_res),
        .sel(EXE_MEM_out_CS.MemoRead),
        .out(alu_or_memoData_out)
    );

// -----------------------------------   MEM END

// -----------------------------------   MEM/WB BEGIN

    ControlSignal MEM_WB_out_CS;
    wire [31:0] MEM_WB_out_ALU_res;
    wire [31:0] MEM_WB_out_Data_to_Reg;
    
    
    

    PipeReg_MEM_WB pr_MEM_WB(
        .clock(clock),
        .ins(EXE_MEM_out_CS.ins),
        .cs(EXE_MEM_out_CS),
        .ALU_res(EXE_MEM_out_ALU_res),
        .Mem_Read_Data(out_DM_ReadData),
        .write_reg(EXE_MEM_out_Write_Reg),
        .pc_plus4(EXE_MEM_out_pc_plus4),
        .out_cs(MEM_WB_out_CS),
        .out_ALU_res(MEM_WB_out_ALU_res),
        .out_Mem_Read_Data(MEM_WB_out_Data_to_Reg),
        .out_write_reg(MEM_WB_out_Write_Reg),
        .out_pc_plus8(MEM_WB_out_pc_plus8),
        .branch_addr(MEM_WB_branch_addr),
        .MEM_WB_out_zero_flag(MEM_WB_out_branch_zero_flag),
        .MEM_WB_func(MEM_WB_out_func),
        .MEM_WB_out_pc_plus_4(MEM_WB_pc_plus_4)
    );
    
    assign MEM_WB_out_RegWriteW = MEM_WB_out_CS.regWrite;
   
    
// -----------------------------------   MEM/WB END

    Mux_2 mux2_3(
        .a(MEM_WB_out_Data_to_Reg),
        .b(MEM_WB_out_ALU_res),
        .sel(MEM_WB_out_CS.MemoToReg),
        .out(Mux_2_3_out),
        .mark(3'b011)
    );


endmodule