`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:CDAC Trivandrum 
// Engineer: Ashbin shiju
// 
// Create Date: 16.03.2024 11:01:23
// Design Name: 
// Module Name: GHR
// Project Name: Branch predictor
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


//       |_______|______________________________________|____________________________________________________________|  BTB cache without predictor/
//       | 1 bit |               24 bit                 |                     32 bit                                 |   prediction bits(57 bits)
//         valid                  Tag                                         target


module GHR(
input gin,clk,rst, branch,
input[31:0]instruction,target,
input [23:0]tag,
output  reg nnt,
output reg [31:0] target_addr,
output reg hit


    );
reg [6:0]index;
reg [6:0]prev_index;
reg prev_hit;
reg valid;
reg [23:0]tag_store;
reg [31:0] prev_target;
reg [31:0] target_store;
reg [31:0]instr;                              //to store instruction
reg gin_store;                           // to store T/NT feedback
reg[1:0] prediction;                          // 2 bit predictor
reg [6:0]hash;                                // 7 bit hash
reg [6:0]gout; 
reg [6:0] prev_hash;
reg [1:0] pht [127:0];                        // 2 bit 128 location ( 7 bit hash so 2^7 location)
reg[56:0] btb [127:0];
integer i;
integer j;
always@(posedge clk)
    begin  //always
    if(rst==1)
         begin // rst
         for ( i = 0; i < 128; i = i + 1) begin
            pht[i] = 2'b00; // Assign '00' to each location
            end
         // prediction <= 2'b00;
          gin_store <= 1'b0;
          hash <= 7'b0;
          nnt<=1'b0;
          gout <= 7'b0;
          
     for ( j = 0; j < 128; j = j + 1) begin
            btb[j] = 57'b0; // Assign '64 bit 0' to each location
        end
     valid = 1'b0;
    index = 6'b0;
     hit = 1'b0;
         end   //rst
         
    if(rst==0)
    
        begin  // !rst
        gin_store = gin; 
        instr = instruction;
        prev_hash = hash;
        prev_hit=hit;
        prev_index = index;
        prev_target = target_store;
        if(gin_store==1)
          begin  // ==
            if(pht[ prev_hash]<2'b11)
               begin
               pht [prev_hash] = pht[ prev_hash]+1'b1;
               end
            end  //==
        else
           begin  //!=
             if(pht[ prev_hash]>2'b00)
                begin
                 pht[ prev_hash] = pht[ prev_hash]-1'b1;          //incrementation of pht table value
                end
           end     //!=
 gout = {gin,gout[6:1]};            //ghr
 hash = instr [6:0] ^ gout;     //hashing
 prediction = pht[hash];
 nnt = prediction [1];
 
 if(branch ==1 && prev_hit==0)
    begin        //b&h
    btb[prev_index][56]=1'b1;
    btb[prev_index][55:32] = tag;
    btb[prev_index][31:0] = target;
    end          //b&h
 if(branch ==1 && prev_hit== 1 && prev_target != target)
    begin  // Diff target
    btb[prev_index][31:0] = target;
    end    // Diff target
    index = instr[6:0];
    tag_store = btb[index][55:32];
    target_store = btb[index][31:0];
    valid = btb[index][56];
    


    if(valid==1)
    begin   //valid
    if(instr[31:7]==tag_store)
    begin
    hit = 1'b1;
    end 
    else
    begin
    hit = 1'b0;
    end
    end // valid
   if(valid==0)
    begin  // not valid
    hit=1'b0;
 
    end     // not valid
        
     if( nnt==1 && hit ==1)
     begin // NNT & hit 
     target_addr = target_store;
     end  // NNT & hit 
     else
     begin // !NNT & hit
     target_addr = instr + 4;
     end   //!NNT & hit
        
        end    //!rst
    end    // always
endmodule
