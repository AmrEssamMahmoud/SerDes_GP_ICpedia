module parameter_update (
    input logic clock_with_shift,
    input real opening,
    input logic opening_ready,
    output logic [8:0] guess_frequency
);

    parameter TARGET = 0.96;
    parameter NUMBER_OF_DIVIDES = 3;
    parameter NUMBER_OF_SAMPLES = 6;
    parameter LINEAR_RANGE = 512 / (2 ** NUMBER_OF_DIVIDES);

    real diff;
    int min, i;
    int phase_counter = 0;
    int iteration = 0;
    real samples [0:LINEAR_RANGE-1];
    logic [8:0] step = 512 / (NUMBER_OF_SAMPLES - 1);
    logic [8:0] base = 0;

    initial guess_frequency = 0;

    always @(posedge opening_ready) begin
        if (phase_counter < NUMBER_OF_DIVIDES) begin
            samples[iteration] = loss(opening);
            if (iteration == NUMBER_OF_SAMPLES - 1) begin
                phase_counter += 1;
                iteration = 0;
                step = step >> 1;
                
                min = 0;
                for (i = 0; i < NUMBER_OF_SAMPLES; i++) begin
                    if (samples[i] < samples[min])
                        min = i;
                end
                
                if (min >= NUMBER_OF_SAMPLES/2) begin
                    base += step * (NUMBER_OF_SAMPLES-1);
                end

                guess_frequency = base;

            end else begin
                iteration += 1;
                guess_frequency += step;
            end
        end else if (phase_counter == NUMBER_OF_DIVIDES) begin
            samples[iteration] = loss(opening);
            if (iteration == LINEAR_RANGE - 1) begin
                phase_counter += 1;

                min = 0;
                for (i = 0; i < LINEAR_RANGE; i++) begin
                    if (samples[i] < samples[min])
                        min = i;
                end

                guess_frequency = base + min;
            end else begin
                iteration += 1;
                guess_frequency += 1;
            end
        end
    end

    function real loss(input real x);
        diff = x - TARGET;
        return (diff < 0.0) ? -diff : diff;
    endfunction

endmodule