module eye_calculation (
    input logic clock_with_shift,
    input real sample,
    output real opening,
    output logic opening_ready
);

    parameter THRESHOLD = 0.5;
    parameter SAMPLE_COUNT = 1000;

    int counter = 0;
    int count_high = 0, count_low = 0;
    real sum_high = 0.0, sum_low = 0.0;
    real avg_high, avg_low;

    initial opening = 1;

    always @(posedge clock_with_shift) begin

        counter++;
        if (sample >= THRESHOLD) begin
            sum_high += sample;
            count_high++;
        end else begin
            sum_low += sample;
            count_low++;
        end

        if (counter == SAMPLE_COUNT) begin
            avg_high = (count_high > 0) ? (sum_high / count_high) : 0.0;
            avg_low  = (count_low  > 0) ? (sum_low  / count_low ) : 0.0;
            opening = avg_high - avg_low;
            opening_ready = 1;

            counter = 0;
            sum_high = 0.0;
            sum_low = 0.0;
            count_high = 0;
            count_low = 0;
        end else begin
            opening_ready = 0;
        end
    end

endmodule