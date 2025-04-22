module eye_calculation #(
    parameter SAMPLE_COUNT = 300
) (
    input logic clock_with_shift,
    input real sample,
    output real opening,
    output logic opening_ready
);

    real samples[$];
    // real samples [0:SAMPLE_COUNT-1];
    int counter = 0;
    real sum_high = 0.0, sum_low = 0.0;
    int count_high = 0, count_low = 0;
    real threshold = 0.5;
    real avg_high, avg_low;
    real old_sample;
    // bit [4:0] counter = 1;

    initial opening = 1;
    // initial opening_ready = 0;
    // assign opening_ready = counter == 0;

    // always @(posedge clock_with_shift) begin
    //     samples.push_back(sample);
    //     if (sample >= threshold) begin
    //         sum_high += sample;
    //     end else begin
    //         sum_low += sample;
    //     end

    //     opening = (sum_high - sum_low) / samples.size();
        
    //     if (samples.size() > 500) begin
    //         // opening_ready = 1;
    //         counter = counter + 1;

    //         old_sample = samples.pop_front();
    //         if (old_sample >= threshold) begin
    //             sum_high -= old_sample;
    //         end else begin
    //             sum_low -= old_sample;
    //         end
    //     end
    // end

    always @(posedge clock_with_shift) begin
        samples.push_back(sample);

        if (sample >= threshold) begin
            sum_high += sample;
            count_high++;
        end else begin
            sum_low += sample;
            count_low++;
        end

        counter++;

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