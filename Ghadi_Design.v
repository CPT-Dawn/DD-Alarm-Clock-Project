module Aclock(
input Reset, Ghadi, Load_Samay, Load_Alarm, Alarm_Band, Alarm_Chalu, 
input [1:0] Hours_Ki_Tenth_digit_IN,                                          // tens digit of hours
input [3:0] Hours_Ki_Ones_digit_IN,                                           // ones digit of hours
input [3:0] Mins_Ki_Tenth_digit_IN,                                           // tens digit of minutes
input [3:0] Mins_Ki_Ones_digit_IN,                                            // ones digit of minutes

output reg Alarm,                                                             // Output batata hua ki alarm bajna chaie ki nahi
output [1:0]  Hours_Ki_Tenth_digit_OUT,                                       // tens digit of hours
output [3:0]  Hours_Ki_Ones_digit_OUT,                                        // ones digit of hours
output [3:0]  Mins_Ki_Tenth_digit_OUT,                                        // tens digit of minutes
output [3:0]  Mins_Ki_Ones_digit_OUT,                                         // ones digit of minutes
output [3:0]  Secs_Ki_Tenth_digit_OUT,                                        // tens digit of seconds
output [3:0]  Secs_Ki_Ones_digit_OUT);                                        // ones digit of seconds

reg Ghadi_1s;                                                                 // generating a 1Hz clock signal
reg [3:0] tmp_1s;                                                             // counting seconds
reg [5:0] Temp_Hour, Temp_Min, Temp_Sec;                                      // storing time values
reg [1:0] Current_Hour_Ki_Tenth_Digit,Alarm_Hour_Ki_Tenth_Digit;              // storing current and alarm hour tens digits
reg [3:0] Current_Hour_Ki_Ones_Digit,Alarm_Hour_Ki_Ones_Digit;                // storing current and alarm hour ones digits
reg [3:0] Current_Min_Ki_Tenth_Digit,Alarm_Min_Ki_Tenth_Digit;                // storing current and alarm minute tens digits
reg [3:0] Current_Min_Ki_Ones_Digit,Alarm_Min_Ki_Ones_Digit;                  // storing current and alarm minute ones digits
reg [3:0] Current_Sec_Ki_Tenth_Digit,Alarm_Sec_Ki_Tenth_Digit;                // storing current and alarm second tens digits
reg [3:0] Current_Sec_Ki_Ones_Digit,Alarm_Sec_Ki_Ones_Digit;                  // storing current and alarm second ones digits

function [3:0] mod_10;                                                        // Function to calculate modulo 10 of a 6-bit sankhya
input [5:0] sankhya;
begin
    mod_10 = (sankhya >= 50) ? 5 : ((sankhya >= 40) ? 4 : ((sankhya >= 30) ? 3 : ((sankhya >= 20) ? 2 : ((sankhya >= 10) ? 1 : 0))));
end
endfunction

always @(posedge Ghadi_1s or posedge Reset)                                   // Always block triggered on positive edge of Ghadi_1s or Reset
begin
    if (Reset) begin                                                          // Resetting alarm time registers
        Alarm_Hour_Ki_Tenth_Digit <= 2'b00;
        Alarm_Hour_Ki_Ones_Digit <= 4'b0000;
        Alarm_Min_Ki_Tenth_Digit <= 4'b0000;
        Alarm_Min_Ki_Ones_Digit <= 4'b0000;
        Alarm_Sec_Ki_Tenth_Digit <= 4'b0000;
        Alarm_Sec_Ki_Ones_Digit <= 4'b0000;
        Temp_Hour <= Hours_Ki_Tenth_digit_IN*10 + Hours_Ki_Ones_digit_IN;     // Setting temporary time registers
        Temp_Min <= Mins_Ki_Tenth_digit_IN*10 + Mins_Ki_Ones_digit_IN;
        Temp_Sec <= 0;
    end
    else begin                                                                // Loading alarm time if Load_Alarm is asserted
        if (Load_Alarm) begin
            Alarm_Hour_Ki_Tenth_Digit <= Hours_Ki_Tenth_digit_IN;
            Alarm_Hour_Ki_Ones_Digit <= Hours_Ki_Ones_digit_IN;
            Alarm_Min_Ki_Tenth_Digit <= Mins_Ki_Tenth_digit_IN;
            Alarm_Min_Ki_Ones_Digit <= Mins_Ki_Ones_digit_IN;
            Alarm_Sec_Ki_Tenth_Digit <= 4'b0000;
            Alarm_Sec_Ki_Ones_Digit <= 4'b0000;
        end                                                                   // Loading time if Load_Samay is asserted
        if (Load_Samay) begin
            Temp_Hour <= Hours_Ki_Tenth_digit_IN*10 + Hours_Ki_Ones_digit_IN;
            Temp_Min <= Mins_Ki_Tenth_digit_IN*10 + Mins_Ki_Ones_digit_IN;
            Temp_Sec <= 0;
        end
        else begin                                                           // Incrementing seconds and updating minutes and hours accordingly
            Temp_Sec <= Temp_Sec + 1;
            if (Temp_Sec >= 59) begin
                Temp_Min <= Temp_Min + 1;
                Temp_Sec <= 0;
                if (Temp_Min >= 59) begin
                    Temp_Min <= 0;
                    Temp_Hour <= Temp_Hour + 1;
                    if (Temp_Hour >= 24) begin
                        Temp_Hour <= 0;
                    end
                end
            end
        end
    end
end

always @(posedge Ghadi or posedge Reset)                                     // Always block triggered on positive edge of Ghadi or Reset
begin
    if (Reset) begin                                                         // Resetting 1s clock counter and output
        tmp_1s <= 0;
        Ghadi_1s <= 0;
    end
    else begin                                                               // Resetting 1s clock counter and output
        tmp_1s <= tmp_1s + 1;
        if (tmp_1s <= 5)
            Ghadi_1s <= 0;
        else if (tmp_1s >= 10) begin
            Ghadi_1s <= 1;
            tmp_1s <= 1;
        end
        else
            Ghadi_1s <= 1;
    end
end

always @(*)                                                                   // Always block to calculate current time digits based on temporary time registers
begin
    if (Temp_Hour >= 20)
        Current_Hour_Ki_Tenth_Digit = 2;
    else begin
        if (Temp_Hour >= 10)
            Current_Hour_Ki_Tenth_Digit = 1;
        else
            Current_Hour_Ki_Tenth_Digit = 0;
    end
    Current_Hour_Ki_Ones_Digit = Temp_Hour - Current_Hour_Ki_Tenth_Digit*10;
    Current_Min_Ki_Tenth_Digit = mod_10(Temp_Min);
    Current_Min_Ki_Ones_Digit = Temp_Min - Current_Min_Ki_Tenth_Digit*10;
    Current_Sec_Ki_Tenth_Digit = mod_10(Temp_Sec);
    Current_Sec_Ki_Ones_Digit = Temp_Sec - Current_Sec_Ki_Tenth_Digit*10;
end

always @(posedge Ghadi_1s or posedge Reset)                                  // Always block triggered on positive edge of Ghadi_1s or Reset to check alarm condition
begin
    if (Reset)
        Alarm <= 0;
    else begin                                                              // Checking if current time matches alarm time and Alarm_Chalu is asserted
        if ({Alarm_Hour_Ki_Tenth_Digit,Alarm_Hour_Ki_Ones_Digit,Alarm_Min_Ki_Tenth_Digit,Alarm_Min_Ki_Ones_Digit} == {Current_Hour_Ki_Tenth_Digit,Current_Hour_Ki_Ones_Digit,Current_Min_Ki_Tenth_Digit,Current_Min_Ki_Ones_Digit}) begin
            if (Alarm_Chalu)
                Alarm <= 1;
        end                                                                // Resetting alarm if Alarm_Band is asserted
        if (Alarm_Band)
            Alarm <= 0;
    end
end
assign Hours_Ki_Tenth_digit_OUT = Current_Hour_Ki_Tenth_Digit;              // output values assign hore hain
assign Hours_Ki_Ones_digit_OUT = Current_Hour_Ki_Ones_Digit;
assign Mins_Ki_Tenth_digit_OUT = Current_Min_Ki_Tenth_Digit;
assign Mins_Ki_Ones_digit_OUT = Current_Min_Ki_Ones_Digit;
assign Secs_Ki_Tenth_digit_OUT = Current_Sec_Ki_Tenth_Digit;
assign Secs_Ki_Ones_digit_OUT = Current_Sec_Ki_Ones_Digit;

endmodule