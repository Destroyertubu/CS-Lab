`timescale 1us/1us

module BeqJudge(
    input clk,
    input [4:0] regs_,
    input [4:0] regt_,
    input [31:0] RegS,
    input [31:0] RegT,
    input [5:0] opcode,
    output reg resBeq,
    output reg bgtz_sig,
    output reg blez_sig,
    output reg bgez_sig,
    output reg bltz_sig
);  
    reg signed [31:0] s;
    reg signed [31:0] t;

    always @( RegS or RegT ) begin
        s = RegS;
        t = RegT;
        
        $display("111 RegS = %x, regs_ = %d", RegS, regs_);
        
        
//        bgtz_sig = 0;
//        blez_sig = 0;
//        bgez_sig = 0;
//        bltz_sig = 0;
        
        if (s == t)    // beq bne
            begin
                resBeq <= 1;
            end
        else 
            begin
                 resBeq <= 0;  
            end
           
            begin
                if (s > 0)    // bgtz
                    begin
                        bgtz_sig <= 1'b1;
//                        $display("BGTZ");
                    end
                else 
                    begin
                        bgtz_sig <= 1'b0;
                    end
            end
            
        if (s <= 0)      // blez
            begin
                blez_sig <= 1'b1;
            end
        else
            begin
                blez_sig <= 1'b0;
            end    
        
        if (s >= 0)   // bgez
            begin
                bgez_sig <= 1'b1;
            end
        else 
            begin
                bgez_sig <= 1'b0;
            end
            
        if (s < 0)    // bltz
            begin
                bltz_sig <= 1'b1;
            end
        else 
            begin
                bltz_sig <= 1'b0;
            end
    end


endmodule