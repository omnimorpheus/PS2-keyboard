`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Class: EEL5722C 
// Engineer: Syed Ahmed
// 
// Create Date:    15:19:43 10/05/2015 
// Design Name: PS2 Keyboard Interface
// Module Name:    keyb 
// Project Name: Lab Assignment 3
// Target Devices: Keyboard, Virtex 2P development kit
// Tool versions: 
// Description: all good no worries.
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module keyb(
input wire kb_clock, // This is the clock signal from Keyboard
input wire data, //This is the clock signal from Keyboard
output reg [3:0] led //LED outputs on the kit
);

//=============================== Declare Additional Registers required =========== Start ===========
reg [7:0] d_current;
reg [7:0] d_previous;
reg [3:0] count;
reg break;
//=============================== Declare Additional Registers required =========== End ===========

//=============================== Intialize the declared Registers =========== Start ===========
initial
begin
count<=4'h1; // count to keep a track of the current data bit
break<=1'b0;
d_current<=8'hf0;
d_previous<=8'hf0;
led<=3'b0;
end
//=============================== Intialize the declared Registers =========== End ===========

//============================ Receive the data from keyboard ================== Start ========
always @(negedge kb_clock) //at the falling edge of the clock
begin
case(count)
1:; //starting bit
2:d_current[0]<=data; // read next 8 data bits
3:d_current[1]<=data;
4:d_current[2]<=data;
5:d_current[3]<=data;
6:d_current[4]<=data;
7:d_current[5]<=data;
8:d_current[6]<=data;
9:d_current[7]<=data;
10:break<=1'b1; //Parity bit
11:break<=1'b0; //Ending bit
endcase
 if(count<=10)
 count<=count+1;
 else if(count==11)
 count<=1;
end
//============================ Receive the data from keyboard ================== END ========

//============================ Display the read data ================== Start ========
always@(posedge break) // Printing data obtained to led lights
begin
if(d_current==8'hf0)
begin
case(d_previous)
8'h16: led <= 4'b1110;  //1
8'h1E: led <= 4'b1101; //2
8'h26: led <= 4'b1100; //3
8'h25: led <= 4'b1011; //4
8'h2E: led <= 4'b1010; //5
8'h36: led <= 4'b1001; //6
8'h3D: led <= 4'b1000; //7
8'h3E: led <= 4'b0111; //8
8'h46: led <= 4'b0110; //9
8'h45: led <= 4'b1111; //10
default: led <= 4'b0000; // diaplay all lights high when any other key is pressed
endcase
end
 else
 d_previous<=d_current;
//============================ Display the read data ================== END ========
end endmodule
