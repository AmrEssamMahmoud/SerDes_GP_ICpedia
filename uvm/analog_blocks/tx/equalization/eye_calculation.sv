module eye_calculation #(
    parameter SAMPLE_COUNT = 100
) (
    input logic clock_with_shift,
    input real sample,
    output real opening,
    output logic opening_ready
);

    real samples [0:SAMPLE_COUNT-1];
    int counter = 0;
    real sum_high = 0.0, sum_low = 0.0;
    int count_high = 0, count_low = 0;
    real threshold = 0.5;

    always_ff @(posedge clock_with_shift) begin
        samples[counter] = sample;

        if (sample >= threshold) begin
            sum_high += sample;
            count_high++;
        end else begin
            sum_low += sample;
            count_low++;
        end

        counter++;

        if (counter == SAMPLE_COUNT) begin
            real avg_high = (count_high > 0) ? (sum_high / count_high) : 0.0;
            real avg_low  = (count_low  > 0) ? (sum_low  / count_low ) : 0.0;
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