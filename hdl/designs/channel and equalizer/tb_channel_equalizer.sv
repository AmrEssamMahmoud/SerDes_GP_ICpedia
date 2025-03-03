`timescale 1ps/10fs  

module tb_channel_equalizer;

    real channel_in;       // Input signal
    real channel_out;      // Output of the channel (low-pass filtered)
    real equalizer_out;    // Output of the equalizer
    reg clk;               // Clock signal

    // Instantiate the low-pass filter (channel)
    channel #(.T(1.0e-12), .TAU(200.0e-12)) channel (
        .clk(clk),
        .channel_in(channel_in),
        .channel_out(channel_out)
    );

    // Instantiate the equalizer
    equalizer #(.T(1.0e-12), .TAU(200.0e-12)) eq (
        .clk(clk),
        .equalizer_in(channel_out),
        .equalizer_out(equalizer_out)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #0.5 clk = ~clk;  // Toggle clock every 5ps (10ps period)
    end

    initial begin
        // Create a VCD file for waveform dumping
        $dumpfile("waveform.vcd");
        $dumpvars(0, tb_channel_equalizer);

        // Test input: Square wave
        repeat (5) begin
            channel_in = 1.0;
            #20;  
            channel_in = 0.0;
            #20;  
        end

        $finish;
    end

    // Monitor the signals
    initial begin
        $monitor("Time = %0t: channel_in = %f, channel_out = %f, equalizer_out = %f",
                 $time, channel_in, channel_out, equalizer_out);
    end

endmodule