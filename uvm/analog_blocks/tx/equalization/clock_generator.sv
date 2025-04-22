module clock_generator (
    input clk,
    output clock_with_shift
);

    bit [8:0] shift = 0;
    // always @(posedge clk) shift = shift + 0;
    int counter = 0;
    always @(posedge clk) begin
        counter = counter + 1;
        if (counter == 50) begin
            shift = shift - 1;
            counter = 0;
        end
    end

    phase_interpolator #(.time_scale(1e-12)) phase_interpolator(.clk(clk), .phase_shift(shift), .recovered_clock(clock_with_shift));

endmodule