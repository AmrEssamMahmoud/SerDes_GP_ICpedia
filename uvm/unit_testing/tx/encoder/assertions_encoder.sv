import enums ::*;
module assertions_encoder (encoder_if.DUT _if);
    
    int disparity;
    int i;

    initial begin
        disparity=-1;
        forever begin
            @(negedge _if.BitCLK_10)
            if(_if.Reset) begin
                for (i = 0; i < 10; i++) begin
                    if(_if.TxParallel_10[i])
                        disparity = disparity + 1;
                    else
                        disparity = disparity - 1;
                end
            end
        end
    end
    
    // Property to check for no 5 consecutive 1s or 0s in TxParallel_10
    property five_consecutive_bits;
        @(negedge _if.BitCLK_10 ) disable iff (!_if.Reset || (_if.TxDataK && (_if.TxParallel_8 == S_28_1 || _if.TxParallel_8 == S_28_5 || _if.TxParallel_8 == S_28_7))) // Disable the property during reset and during k28.1, k28.5, k28.7
            ##1 !(
                _if.TxParallel_10[9:5] == 5'b11111 || _if.TxParallel_10[9:5] == 5'b00000 ||
                _if.TxParallel_10[8:4] == 5'b11111 || _if.TxParallel_10[8:4] == 5'b00000 ||  
                _if.TxParallel_10[7:3] == 5'b11111 || _if.TxParallel_10[7:3] == 5'b00000 || 
                _if.TxParallel_10[6:2] == 5'b11111 || _if.TxParallel_10[6:2] == 5'b00000 || 
                _if.TxParallel_10[5:1] == 5'b11111 || _if.TxParallel_10[5:1] == 5'b00000 ||
                _if.TxParallel_10[4:0] == 5'b11111 || _if.TxParallel_10[4:0] == 5'b00000
            );   
    endproperty
    
    property disparity_check;
        @(negedge _if.BitCLK_10 ) disable iff(!_if.Reset)
        !(disparity > 2 || disparity < -2);
    endproperty
        
    // Assert the property
    five_consecutive_bits_assert: assert property (five_consecutive_bits)
        else $error("5 consecutive 1s or 0s detected in TxParallel_10: %b", _if.TxParallel_10);
        
    five_consecutive_bits_cover: cover property (five_consecutive_bits);

    disparity_assert: assert property (disparity_check)
        else $error("disparity error");

    disparity_cover: cover property (disparity_check);

endmodule