`timescale 1us/1us

module DataMemory(
    input [31:0] addr,
    input [31:0] write_data,
    input clk,
    input RD,         // 
    input WR,         // 
    input [5:0] opcode,
    input reset,
    output reg [31:0] read_data,
    input [31:0] programCounter    
    );
    
    reg [31:0] storage [0:2050];    
    reg [7:0] tmp_data1;
    reg [31:0] tmp_data2;
    
    reg [15:0] tmp_data3;
    
    integer i;
    
    initial
        begin
                for(i = 0;i < 2050;i = i + 1) begin
                    storage[i] <= 0;
            end            
        end
    
    always @(negedge reset) begin
            for(i = 0;i < 2050;i = i + 1) begin
                storage[i] <= 0;
        end
    end
    
    always @(negedge clk) begin
//        $display("DataMemory");
        if(WR == 1) begin
            if (opcode == 6'b101011)    // sw
                begin
                    storage[addr[12:2]] = write_data;
                    $display("@%h: *%h <= %h", programCounter - 4, addr, write_data);                
                end
            else if (opcode == 6'b101000)  // sb
                begin
                    tmp_data1 = 0;
                    tmp_data2 = 0;
                    tmp_data1 = write_data[7:0];
                    tmp_data2 = storage[addr[12:2]];
                    $display("tmp_data1 = %x, tmp_data2 = %x， addr = %x", tmp_data1, tmp_data2, addr[12:2]);
                    if (addr[1:0] == 2'b00)
                        begin
                            tmp_data2[7:0] = tmp_data1;
                            storage[addr[12:2]] = tmp_data2;
                            $display("@%h: *%h <= %h", programCounter - 4, {addr[31:2], 2'b00}, storage[addr[12:2]]);  
                        end
                    else if (addr[1:0] == 2'b01)
                        begin
                            tmp_data2[15:8] = tmp_data1;
                            storage[addr[12:2]] = tmp_data2;
                            $display("@%h: *%h <= %h", programCounter - 4, {addr[31:2], 2'b00}, storage[addr[12:2]]);                              
                        end
                    else if (addr[1:0] == 2'b10)
                        begin
                            tmp_data2[23:16] = tmp_data1;
                            storage[addr[12:2]] = tmp_data2;
                            $display("@%h: *%h <= %h", programCounter - 4, {addr[31:2], 2'b00}, storage[addr[12:2]]);                             
                        end
                    else if (addr[1:0] == 2'b11)   
                        begin
                            tmp_data2[31:24] = tmp_data1;
                            storage[addr[12:2]] = tmp_data2;
                            $display("@%h: *%h <= %h", programCounter - 4, {addr[31:2], 2'b00}, storage[addr[12:2]]);                            
                        end
                end
            else if (opcode == 6'b101001)     // sh
                begin
                
                    tmp_data3 = 0;
                    tmp_data2 = 0;
                    tmp_data3 = write_data[15:0];
                    tmp_data2 = storage[addr[12:2]];
                    
                    if (addr[1:0] == 2'b00)
                        begin
                            tmp_data2[15:0] = tmp_data3;
                            storage[addr[12:2]] = tmp_data2;
                            $display("@%h: *%h <= %h", programCounter - 4, addr, storage[addr[12:2]]);
                        end
                    else if (addr[1:0] == 2'b10)
                        begin
                            tmp_data2[31:16] = tmp_data3;
                            storage[addr[12:2]] = tmp_data2;
                            $display("@%h: *%h <= %h", programCounter - 4, addr - 2, storage[addr[12:2]]);                            
                        end
                end
        end
     end
     
     always @(*) begin
        if (RD == 1) begin
            if (opcode == 6'b100011)  // lw
                begin
                    read_data = storage[addr[12:2]];
//                    $display("MemoRead addr = %x, MemoRead value = %x", addr, storage[addr[31:2]]);
                end
            else if (opcode == 6'b100000 || opcode == 6'b100100)   //  lb & lbu
                
                begin
                    tmp_data2 = storage[addr[12:2]];
                    
                    if (addr[1:0] == 2'b00)
                        begin
                            tmp_data1 = tmp_data2[7:0];
                        end
                    else if (addr[1:0] == 2'b01)
                        begin
                            tmp_data1 = tmp_data2[15:8];
                        end
                    else if (addr[1:0] == 2'b10) 
                        begin
                            tmp_data1 = tmp_data2[23:16];
                        end
                    else if (addr[1:0] == 2'b11)    
                        begin
                            tmp_data1 = tmp_data2[31:24];
                        end
                    
                    if (opcode == 6'b100000)       // lh & lhu
                        begin
                            if (tmp_data1[7] == 1'b0)
                                begin
                                    read_data = {24'b000000000000000000000000, tmp_data1};
                                end
                            else
                                begin
                                    read_data = {24'b111111111111111111111111, tmp_data1};
                                end
                        end
                     else 
                        begin
                            read_data = {24'b000000000000000000000000, tmp_data1};
                        end
                end
            else if (opcode == 6'b100001 || opcode == 6'b100101)  
                begin
                    tmp_data2 = storage[addr[12:2]];
                    
                    if (addr[1:0] == 2'b00)
                        begin
                            tmp_data3 = tmp_data2[15:0];
                        end
                    else if (addr[1:0] == 2'b10)
                        begin
                            tmp_data3 = tmp_data2[31:16];
                        end
                        
                    if (opcode == 6'b100001)
                        begin
                            if (tmp_data3[15] == 1'b0)
                                begin
                                    read_data = {16'b0000000000000000, tmp_data3};
                                end
                            else
                                begin
                                    read_data = {16'b1111111111111111, tmp_data3};
                                end
                        end
                    else
                        begin
                            read_data = {16'b0000000000000000, tmp_data3};
                        end
                end
//            $display("MemoRead Data = %h, MemoRead addr = %h, %h", read_data, addr, storage[addr]);
        end
    end
    
endmodule
