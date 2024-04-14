`include "Ghadi_Design.v"

module Testbench;

 reg reset;
 reg clk;
 reg [1:0] H_in1;
 reg [3:0] H_in0;
 reg [3:0] M_in1;
 reg [3:0] M_in0;
 reg LD_time;
 reg LD_alarm;
 reg STOP_al;
 reg AL_ON;

 // Outputs
 wire Alarm;
 wire [1:0] H_out1;
 wire [3:0] H_out0;
 wire [3:0] M_out1;
 wire [3:0] M_out0;
 wire [3:0] S_out1;
 wire [3:0] S_out0;

 
 Aclock uut (
 .reset(reset), 
 .clk(clk), 
 .H_in1(H_in1), 
 .H_in0(H_in0), 
 .M_in1(M_in1), 
 .M_in0(M_in0), 
 .LD_time(LD_time), 
 .LD_alarm(LD_alarm), 
 .STOP_al(STOP_al), 
 .AL_ON(AL_ON), 
 .Alarm(Alarm), 
 .H_out1(H_out1), 
 .H_out0(H_out0), 
 .M_out1(M_out1), 
 .M_out0(M_out0), 
 .S_out1(S_out1), 
 .S_out0(S_out0)
 );

 initial begin 
  clk = 0;
  forever #50000000 clk = ~clk;
 end
 initial begin
 // Initialize Inputs
 reset = 1;
 H_in1 = 1;
 H_in0 = 0;
 M_in1 = 1;
 M_in0 = 9;
 LD_time = 0;
 LD_alarm = 0;
 STOP_al = 0;
 AL_ON = 0;

 #1000000000;
 reset = 0;
 H_in1 = 1;
 H_in0 = 0;
 M_in1 = 2;
 M_in0 = 0;
 LD_time = 0;
 LD_alarm = 1;
 STOP_al = 0;
 AL_ON = 1; 
 

#1000000000;
 reset = 0;
 H_in1 = 1;
 H_in0 = 0;
 M_in1 = 2;
 M_in0 = 0;
 LD_time = 0;
 LD_alarm = 0;
 STOP_al = 0;
 AL_ON = 1;

#1000000000;
#1000000000;
#1000000000;
#1000000000;
#1000000000;
#1000000000;
STOP_al = 1;

 
 end

initial begin
    $dumpfile("Ghadi_Ki_Output.vcd");  
    $dumpvars(0, Testbench);             // Sare Variables ko dump kardeta hai for waveform checking
    #100;
    $finish;                             
end

endmodule

