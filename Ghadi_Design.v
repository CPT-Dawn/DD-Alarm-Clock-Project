module Aclock(
input reset, clk, LD_time, LD_alarm, STOP_al, AL_ON, 
input [1:0] H_in1,                                           // tens digit of hours
input [3:0] H_in0,                                           // ones digit of hours
input [3:0] M_in1,                                           // tens digit of minutes
input [3:0] M_in0,                                           // ones digit of minutes

output reg Alarm,                                            // Output batata hua ki alarm bajna chaie ki nahi
output [1:0]  H_out1,                                        // tens digit of hours
output [3:0]  H_out0,                                        // ones digit of hours
output [3:0]  M_out1,                                        // tens digit of minutes
output [3:0]  M_out0,                                        // ones digit of minutes
output [3:0]  S_out1,                                        // tens digit of seconds
output [3:0]  S_out0);                                       // ones digit of seconds

reg clk_1s;                                                  // generating a 1Hz clock signal
reg [3:0] tmp_1s;                                            // counting seconds
reg [5:0] tmp_hour, tmp_minute, tmp_second;                  // storing time values
reg [1:0] c_hour1,a_hour1;                                   // storing current and alarm hour tens digits
reg [3:0] c_hour0,a_hour0;                                   // storing current and alarm hour ones digits
reg [3:0] c_min1,a_min1;                                     // storing current and alarm minute tens digits
reg [3:0] c_min0,a_min0;                                     // storing current and alarm minute ones digits
reg [3:0] c_sec1,a_sec1;                                     // storing current and alarm second tens digits
reg [3:0] c_sec0,a_sec0;                                     // storing current and alarm second ones digits

function [3:0] mod_10;                                       // Function to calculate modulo 10 of a 6-bit number
input [5:0] number;
begin
    mod_10 = (number >= 50) ? 5 : ((number >= 40) ? 4 : ((number >= 30) ? 3 : ((number >= 20) ? 2 : ((number >= 10) ? 1 : 0))));
end
endfunction

always @(posedge clk_1s or posedge reset)                    // Always block triggered on positive edge of clk_1s or reset
begin
    if (reset) begin
        // Resetting alarm time registers
        a_hour1 <= 2'b00;
        a_hour0 <= 4'b0000;
        a_min1 <= 4'b0000;
        a_min0 <= 4'b0000;
        a_sec1 <= 4'b0000;
        a_sec0 <= 4'b0000;
        // Setting temporary time registers
        tmp_hour <= H_in1*10 + H_in0;
        tmp_minute <= M_in1*10 + M_in0;
        tmp_second <= 0;
    end
    else begin
        // Loading alarm time if LD_alarm is asserted
        if (LD_alarm) begin
            a_hour1 <= H_in1;
            a_hour0 <= H_in0;
            a_min1 <= M_in1;
            a_min0 <= M_in0;
            a_sec1 <= 4'b0000;
            a_sec0 <= 4'b0000;
        end
        // Loading time if LD_time is asserted
        if (LD_time) begin
            tmp_hour <= H_in1*10 + H_in0;
            tmp_minute <= M_in1*10 + M_in0;
            tmp_second <= 0;
        end
        else begin
            // Incrementing seconds and updating minutes and hours accordingly
            tmp_second <= tmp_second + 1;
            if (tmp_second >= 59) begin
                tmp_minute <= tmp_minute + 1;
                tmp_second <= 0;
                if (tmp_minute >= 59) begin
                    tmp_minute <= 0;
                    tmp_hour <= tmp_hour + 1;
                    if (tmp_hour >= 24) begin
                        tmp_hour <= 0;
                    end
                end
            end
        end
    end
end

// Always block triggered on positive edge of clk or reset
always @(posedge clk or posedge reset)
begin
    if (reset) begin
        // Resetting 1s clock counter and output
        tmp_1s <= 0;
        clk_1s <= 0;
    end
    else begin
        // Incrementing 1s clock counter and updating clk_1s accordingly
        tmp_1s <= tmp_1s + 1;
        if (tmp_1s <= 5)
            clk_1s <= 0;
        else if (tmp_1s >= 10) begin
            clk_1s <= 1;
            tmp_1s <= 1;
        end
        else
            clk_1s <= 1;
    end
end

// Always block to calculate current time digits based on temporary time registers
always @(*)
begin
    if (tmp_hour >= 20)
        c_hour1 = 2;
    else begin
        if (tmp_hour >= 10)
            c_hour1 = 1;
        else
            c_hour1 = 0;
    end
    c_hour0 = tmp_hour - c_hour1*10;
    c_min1 = mod_10(tmp_minute);
    c_min0 = tmp_minute - c_min1*10;
    c_sec1 = mod_10(tmp_second);
    c_sec0 = tmp_second - c_sec1*10;
end

// Always block triggered on positive edge of clk_1s or reset to check alarm condition
always @(posedge clk_1s or posedge reset)
begin
    if (reset)
        Alarm <= 0;
    else begin
        // Checking if current time matches alarm time and AL_ON is asserted
        if ({a_hour1,a_hour0,a_min1,a_min0} == {c_hour1,c_hour0,c_min1,c_min0}) begin
            if (AL_ON)
                Alarm <= 1;
        end
        // Resetting alarm if STOP_al is asserted
        if (STOP_al)
            Alarm <= 0;
    end
end

// output values assign hore hain
assign H_out1 = c_hour1;
assign H_out0 = c_hour0;
assign M_out1 = c_min1;
assign M_out0 = c_min0;
assign S_out1 = c_sec1;
assign S_out0 = c_sec0;

endmodule