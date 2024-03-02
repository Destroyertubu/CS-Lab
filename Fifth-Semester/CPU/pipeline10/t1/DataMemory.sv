`timescale 1us/1us

module DataMemory(
    input [31:0] addr,
    input [31:0] write_data,
    input clk,
    input RD,         // 
    input WR,         // 
    input reset,
    output reg [31:0] read_data,
    input [31:0] programCounter    
    );
    
    reg [31:0] storage [0:2050];    
    integer i;
    always @(negedge reset) begin
            for(i = 0;i < 32;i = i + 1) begin
                storage[i] <= 0;
        end
    end
    
    always @(negedge clk) begin
//        $display("DataMemory");
        if(WR == 1) begin
            storage[addr[31:2]] = write_data;
            $display("@%h: *%h <= %h", programCounter - 4, addr, write_data);
        end
     end
     
     always @(*) begin
        if (RD == 1) begin
            read_data = storage[addr[31:2]];
//            $display("MemoRead Data = %h, MemoRead addr = %h, %h", read_data, addr, storage[addr]);
        end
    end
    
endmodule
