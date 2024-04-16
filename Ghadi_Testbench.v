`include "Ghadi_Design.v"

module Testbench;

reg reset, clk, LD_time, LD_alarm, STOP_al, AL_ON;    // register variables declare karta hai jo use honge 
reg [1:0] H_in1;                  //  2 bits
reg [3:0] H_in0;                  //  4 bits
reg [3:0] M_in1;                  //  4 bits
reg [3:0] M_in0;                  //  4 bits

wire Alarm;                       // wire variable Alarm naam ka declare hota hai
wire [1:0] H_out1;                // 2 bits
wire [3:0] H_out0;                // 4 bits
wire [3:0] M_out1;                // 4 bits
wire [3:0] M_out0;                // 4 bits
wire [3:0] S_out1;                // 4 bits
wire [3:0] S_out0;                // 4 bits

Aclock uut (                     // Connect karta hai input or output module ko unke register or wire se 
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

initial begin                     // simulation chalu karne ke liye block hai 
clk = 0;                          // clock ko 0 pe initialsise karta hai
forever #50000000 clk = ~clk;     // Forever loop chalata hai
end

initial begin                     // signals ke initial value ko assign karta hai
reset = 1;                        
H_in1 = 1;                        
H_in0 = 0;                        
M_in1 = 1;                        
M_in0 = 9;                        
LD_time = 0;                      
LD_alarm = 0;                     
STOP_al = 0;                      
AL_ON = 0;                        

#1000000000;                      // Delays simulation 
reset = 0;                        // Resets the reset signal
H_in1 = 1;                        
H_in0 = 0;                        
M_in1 = 2;                        
M_in0 = 0;                        
LD_time = 0;                      
LD_alarm = 1;                     
STOP_al = 0;                      
AL_ON = 1;                        

#1000000000;                      // Delays simulation 
reset = 0;                        // Resets the reset signal
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
    $dumpvars(0, Testbench);               // sare variables ko dump karta hai for waveform checking
    #100;                                  // Delays simulation 
    $finish;
end

endmodule                            