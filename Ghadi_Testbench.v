`include "Ghadi_Design.v"

module Testbench;

reg Reset, Ghadi, Load_Samay, Load_Alarm, Alarm_Band, Alarm_Chalu;    // register variables declare karta hai jo use honge 
reg [1:0] Hours_Ki_Tenth_digit_IN;                                    //  2 bits
reg [3:0] Hours_Ki_Ones_digit_IN;                                     //  4 bits
reg [3:0] Mins_Ki_Tenth_digit_IN;                                     //  4 bits
reg [3:0] Mins_Ki_Ones_digit_IN;                                      //  4 bits

wire Alarm;                                                           // wire variable Alarm naam ka declare hota hai
wire [1:0] Hours_Ki_Tenth_digit_OUT;                                  // 2 bits
wire [3:0] Hours_Ki_Ones_digit_OUT;                                   // 4 bits
wire [3:0] Mins_Ki_Tenth_digit_OUT;                                   // 4 bits
wire [3:0] Mins_Ki_Ones_digit_OUT;                                    // 4 bits
wire [3:0] Secs_Ki_Tenth_digit_OUT;                                   // 4 bits
wire [3:0] Secs_Ki_Ones_digit_OUT;                                    // 4 bits

Aclock uut (                                                          // Connect karta hai input or output module ko unke register or wire se 
.Reset(Reset),
.Ghadi(Ghadi),
.Hours_Ki_Tenth_digit_IN(Hours_Ki_Tenth_digit_IN),
.Hours_Ki_Ones_digit_IN(Hours_Ki_Ones_digit_IN),
.Mins_Ki_Tenth_digit_IN(Mins_Ki_Tenth_digit_IN),
.Mins_Ki_Ones_digit_IN(Mins_Ki_Ones_digit_IN),
.Load_Samay(Load_Samay),
.Load_Alarm(Load_Alarm),
.Alarm_Band(Alarm_Band),
.Alarm_Chalu(Alarm_Chalu),
.Alarm(Alarm),
.Hours_Ki_Tenth_digit_OUT(Hours_Ki_Tenth_digit_OUT),
.Hours_Ki_Ones_digit_OUT(Hours_Ki_Ones_digit_OUT),
.Mins_Ki_Tenth_digit_OUT(Mins_Ki_Tenth_digit_OUT),
.Mins_Ki_Ones_digit_OUT(Mins_Ki_Ones_digit_OUT),
.Secs_Ki_Tenth_digit_OUT(Secs_Ki_Tenth_digit_OUT),
.Secs_Ki_Ones_digit_OUT(Secs_Ki_Ones_digit_OUT)
);

initial begin                                                        // simulation chalu karne ke liye block hai 
Ghadi = 0;                                                           // clock ko 0 pe initialsise karta hai
forever #50000000 Ghadi = ~Ghadi;                                    // Forever loop chalata hai
end

initial begin                                                        // signals ke initial value ko assign karta hai
Reset = 1;                        
Hours_Ki_Tenth_digit_IN = 1;                        
Hours_Ki_Ones_digit_IN = 0;                        
Mins_Ki_Tenth_digit_IN = 1;                        
Mins_Ki_Ones_digit_IN = 9;                        
Load_Samay = 0;                      
Load_Alarm = 0;                     
Alarm_Band = 0;                      
Alarm_Chalu = 0;                        

#1000000000;                                                         // Delays simulation 
Reset = 0;                                                           // Resets the Reset signal
Hours_Ki_Tenth_digit_IN = 1;                        
Hours_Ki_Ones_digit_IN = 0;                        
Mins_Ki_Tenth_digit_IN = 2;                        
Mins_Ki_Ones_digit_IN = 0;                        
Load_Samay = 0;                      
Load_Alarm = 1;                     
Alarm_Band = 0;                      
Alarm_Chalu = 1;                        

#1000000000;                                                         // Delays simulation 
Reset = 0;                                                           // Resets the Reset signal
Hours_Ki_Tenth_digit_IN = 1;                        
Hours_Ki_Ones_digit_IN = 0;                        
Mins_Ki_Tenth_digit_IN = 2;                        
Mins_Ki_Ones_digit_IN = 0;                        
Load_Samay = 0;                      
Load_Alarm = 0;                     
Alarm_Band = 0;                      
Alarm_Chalu = 1;                        

#1000000000;                      
#1000000000;                      
#1000000000;                      
#1000000000;                      
#1000000000;                      
#1000000000;                      
Alarm_Band = 1;

end

initial begin                          
    $dumpfile("Ghadi_Ki_Output.vcd");     
    $dumpvars(0, Testbench);                                        // sare variables ko dump karta hai for waveform checking
    #100;                                                           // Delays simulation 
    $finish;
end

endmodule           

