module eye_sampler (
    input clock_with_shift,
    input real data,
    output real sample
);

    always @(posedge clock_with_shift) begin
        sample <= data;
    end
    
endmodule