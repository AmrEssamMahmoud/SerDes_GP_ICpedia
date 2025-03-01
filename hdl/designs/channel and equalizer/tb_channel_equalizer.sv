module tb_channel_equalizer;

    real channel_in;       // Input signal
    real channel_out;   // Output of the channel (low-pass filtered)
    real equalizer_out; // Output of the equalizer

    // Instantiate the low-pass filter (channel)
    channel #(.T(1.0e-3), .TAU(1.0e-3)) channel (
        .channel_in(channel_in),
        .channel_out(channel_out)
    );

    // Instantiate the equalizer
    equalizer #(.T(1.0e-3), .TAU(1.0e-3)) eq (
        .equalizer_in(channel_out),
        .equalizer_out(equalizer_out)
    );

    initial begin
        // Create a VCD file for waveform dumping
        $dumpfile("waveform.vcd");
        $dumpvars(0, tb_channel_equalizer); 

        // Test input: Square wave
        repeat (5) begin
            channel_in = 1.0;
            #10;
            channel_in = 0.0;
            #10;
        end

        $finish;
    end

    // Monitor the signals
    initial begin
        $monitor("Time = %0t: channel_in = %f, channel_out = %f, equalizer_out = %f",
                 $time, channel_in, channel_out, equalizer_out);
    end

endmodule