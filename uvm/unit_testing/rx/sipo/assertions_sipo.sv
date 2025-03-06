import enums::*;

module assertions_sipo (sipo_if.DUT _if);
    
    bit [9:0] serial_in;

    initial begin
        forever begin
            @(negedge _if.BitCLK)
            serial_in = {_if.Serial, serial_in[9:1]};            
        end
    end

    sequence comma_detect;
        (serial_in == K_28_1_p || serial_in == K_28_1_n || serial_in == K_28_5_p || serial_in == K_28_5_n || serial_in == K_28_7_p || serial_in == K_28_7_n);
    endsequence

    sequence output_aligned;
        $past(_if.RxParallel_10) != _if.RxParallel_10;
    endsequence

    comma_check_assert: assert property(@(negedge _if.BitCLK) disable iff(!_if.Reset) comma_detect |-> ##10 output_aligned);

    comma_check_cover: cover property(@(negedge _if.BitCLK) disable iff(!_if.Reset) comma_detect |-> ##10 output_aligned);

endmodule