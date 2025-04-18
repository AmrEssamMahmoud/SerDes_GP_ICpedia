module parameter_update (
    input logic clock_with_shift,
    input real opening,
    input logic opening_ready,
    output real frequency
);

    real prev_frequency;
    real prev_opening = 0.0;
    real gradient = 1e-7;
    real velocity = 0.0;
    real target = 1.0; //سايبهالك تعملها لو عايز تحط مارجين سواء هنا او في الكوندشن
    real learning_rate = 1e13; //حطها انت يا علي مثلا 200 ولا 100
    real diff = 0.0;
    real rho = 0.99;
    logic first = 1;

    always @(posedge clock_with_shift) begin
        // if (opening_ready) begin
            // if (first || fabs(opening - target) < fabs(prev_best - target)) begin
            //     prev_best = opening;
            //     first = 0;
            // end
            if (opening_ready) begin
                if (frequency != prev_frequency && !first) begin
                    gradient = (loss(opening) - loss(prev_opening)) / (frequency - prev_frequency);
                end
                first = 0;
                velocity = rho * velocity + gradient;
                prev_frequency <= frequency;
                prev_opening <= opening;
                frequency <= frequency + learning_rate * velocity;
            end
        // end
    end

    initial begin
        frequency = 100e6 + gradient;
        prev_frequency = 100e6;
    end

    function real loss(input real x);
        diff = x - target;
        return (diff < 0.0) ? -diff : diff;
    endfunction
endmodule