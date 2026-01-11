`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.03.2024 11:09:46
// Design Name: 
// Module Name: GHR_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module GHR_tb;
    reg clk;
    reg rst;
    reg gin;
    reg branch;
    reg [31:0] instruction,target;
    reg [23:0] tag;
    wire nnt;
    wire [31:0] target_addr;
    wire hit;
   
    // Instantiate the module
    GHR uut (
        .clk(clk),
        .rst(rst),
        .gin(gin),
        .branch(branch),
        .instruction(instruction),
        .target(target),
        .tag(tag),
        .nnt(nnt),
        .target_addr(target_addr),
        .hit(hit)
     );
    always #5 clk=~clk;
    initial
    begin
    clk =0;
    #10 rst =1;
    #10 rst =0; instruction = 32'b0000111;gin = 0;
    #10 instruction = 32'b0111000;branch = 1;tag = 24'b0;target = 32'b1101;gin=1;
    #10 instruction = 32'b11000; gin =1;branch =0;tag = 24'bx;target = 32'bx;
    #10 instruction = 32'b0000; gin =1;
    #10 instruction = 32'b100; gin =1;
    #10 instruction = 32'b110; gin =1;
    #10 instruction = 32'b111; gin =1;
    #10 instruction = 32'b1000111; gin =0;
    #10 instruction = 32'b100111; gin =1;
    #10 instruction = 32'b10111; gin =1;
    #10 instruction = 32'b1111; gin =1;
    #10 instruction = 32'b11; gin =1;
    #10 instruction = 32'b101; gin =1;
    #10 instruction = 32'b110; gin =1;
    #10 instruction = 32'b111; gin =1;
    #10 instruction = 32'b1111;gin = 1; branch = 1;tag = 24'b0;target = 32'b1110;
     #10 instruction = 32'b111; gin =1;branch =0;tag = 24'bx;target = 32'bx;
    #10 $finish;
    end
endmodule




//    wire nnt, gin_store;
//    wire [1:0] prediction;
//    wire [6:0] hash, gout, prev_hash;
//    wire hit;
//    wire [31:0] instr,target_addr;
//    wire [6:0] index, prev_index;
//    wire prev_hit, valid;
//    wire [23:0] tag_store;
//    wire [31:0] target_store;

//        .instr(instr),
//        .gin_store(gin_store),
//        .prediction(prediction),
//        .hash(hash),
//        .gout(gout),
//        .prev_hash(prev_hash),
//        .index(index),
//        .prev_index(prev_index),
//        .prev_hit(prev_hit),
//        .valid(valid),
//        .tag_store(tag_store),
//        .target_store(target_store)