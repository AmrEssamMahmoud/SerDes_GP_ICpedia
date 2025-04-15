module parameter_update (
    input logic clk,
    input real opening,
    input logic opening_ready,
    output real frequency
);

    real prev_best = 0.0;
    real target = 1.0; //سايبهالك تعملها لو عايز تحط مارجين سواء هنا او في الكوندشن
    real gain = 100; //حطها انت يا علي مثلا 200 ولا 100
    logic first = 1;

    always_ff @(posedge clk) begin
        if (opening_ready) begin
            if (first || fabs(opening - target) < fabs(prev_best - target)) begin
                prev_best = opening;
                first = 0;
            end
            frequency <= frequency + gain * (opening - prev_best);
        end
    end

    initial begin
        frequency = 100e6
    end

    function real fabs(input real x);
        return (x < 0.0) ? -x : x;
    endfunction
endmodule