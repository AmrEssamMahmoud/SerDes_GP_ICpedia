`timescale 100fs/100fs

module phase_interpolator #(time_precision = 100) (
    input logic        clk,
    input logic [8:0]  phase_shift,
    output logic       data_clock,
    output logic       phase_clock,
    output logic       recovered_clock
);
    real pi = 3.141592653589793;
    real sine_wave[4];
    real gain;
    real interp_output;
    real sine_wave_out; //for checking

    always @(posedge clk) begin
        sine_wave[0] = $sin(pi*$time/time_precision);          // phase 0
        sine_wave[1] = $sin(pi*$time/time_precision + pi/2);     // phase 90
        sine_wave[2] = $sin(pi*$time/time_precision + pi);    // phase pi
        sine_wave[3] = $sin(pi*$time/time_precision + 3 * pi / 2);    // phase 270
        
        gain = phase_shift[6:0] / 128.0;
        
        case (phase_shift[8:7])
            2'b00: interp_output = (1-gain) * sine_wave[0] + gain * sine_wave[1];
            2'b01: interp_output = (1-gain) * sine_wave[1] + gain * sine_wave[2];
            2'b10: interp_output = (1-gain) * sine_wave[2] + gain * sine_wave[3];
            2'b11: interp_output = (1-gain) * sine_wave[3] + gain * sine_wave[0];
        endcase
        
        #time_precision recovered_clock = (interp_output >= 0) ? 1 : 0;
    end

    always @(posedge recovered_clock) begin
        data_clock = ~data_clock;
    end

    always @(negedge recovered_clock) begin
        phase_clock = ~phase_clock;
    end    

    initial begin
        data_clock = 0;
        phase_clock = 0;
        recovered_clock = 0;
    end

endmodule
