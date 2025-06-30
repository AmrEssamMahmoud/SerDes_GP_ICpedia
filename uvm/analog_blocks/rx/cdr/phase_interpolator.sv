module phase_interpolator #(parameter time_scale = 10e-15) (
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
    real frequency = 5e9;
    real current_time;
    int count = 0;
    logic recovered_clock_temp;

    always @(posedge clk) begin

        current_time = $time * time_scale;

        sine_wave[0] = $sin(2*pi*frequency*current_time);          // phase 0
        sine_wave[1] = $sin(2*pi*frequency*current_time + pi/2);     // phase 90
        sine_wave[2] = $sin(2*pi*frequency*current_time + pi);    // phase pi
        sine_wave[3] = $sin(2*pi*frequency*current_time + 3 * pi / 2);    // phase 270
        
        gain = phase_shift[6:0] / 128.0;
        
        case (phase_shift[8:7])
            2'b00: interp_output = (1-gain) * sine_wave[0] + gain * sine_wave[1];
            2'b01: interp_output = (1-gain) * sine_wave[1] + gain * sine_wave[2];
            2'b10: interp_output = (1-gain) * sine_wave[2] + gain * sine_wave[3];
            2'b11: interp_output = (1-gain) * sine_wave[3] + gain * sine_wave[0];
        endcase

        recovered_clock_temp = (interp_output >= 0) ? 1 : 0;
        count = count + 1;
    end

    always @(recovered_clock_temp) begin
        if (count > 20) begin
            recovered_clock = recovered_clock_temp;
            count = 0;
        end
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
        recovered_clock = 1;
    end

endmodule
