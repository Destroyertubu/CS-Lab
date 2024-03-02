`ifndef MYSTRUCTURE_SV
`define MYSTRUCTURE_SV

typedef struct packed{
   reg jal_sig;
   reg jr_sig;
   reg branch_zero_sig;  
   reg j_sig;
}MuxMixSig;

typedef struct packed{
   reg [4:0] RegS;
   reg [4:0] RegT;
} Read_Reg;

typedef struct packed{
   reg [4:0] regd_write1;
   reg [4:0] regt_write2;
   reg [4:0] reg31_jal;
} Write_Reg;

typedef struct packed{
   reg [31:0] branch_addr;
   reg [31:0] jal_j_addr;
   reg [31:0] jr_addr;
} Mix_Addr;

typedef struct packed{
    reg jal;
    reg jr;
    reg Branch;
    reg MemoToReg;
    reg MemoRead;     
    reg MemoWrite;     
    reg [2:0] regDst;    
    reg regWrite;           
    reg [3:0] alu_op_code;   
    reg alu_src;           
    reg [4:0] jal_reg;        
    reg lui_mark;         
    reg j;      
    reg [5:0] opcode;
    reg [4:0] funct;
    reg [31:0] ins;
} ControlSignal;

`endif 