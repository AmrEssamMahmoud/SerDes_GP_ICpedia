module assertions_decoder (decoder_if.DUT _if);
    
    int disparity;
    int i;

    initial begin
        disparity=-1;
        forever begin
            @(negedge _if.BitCLK_10)
            if(_if.Reset) begin
                for (i = 0; i < 10; i++) begin
                    if(_if.RxParallel_10[i])
                        disparity = disparity + 1;
                    else
                        disparity = disparity - 1;
                end
            end
        end
    end

    property disparity_error_check;
        @(negedge _if.BitCLK_10 ) disable iff(!_if.Reset)
        (disparity > 2 || disparity < -2) |-> _if.Disparity_Error;
    endproperty

    disparity_error_assert: assert property (disparity_error_check);

    disparity_error_cover: cover property (disparity_error_check);

endmodule