module digital_top (
    input TxBitCLK, RxBitCLK,
    input TxBitCLK_10, RxBitCLK_10,
    input Reset,
    input TxDataK_in,
    input [7:0] TxParallel_8_in,
    input [9:0] TxParallel_10_in, RxParallel_10_in,
    input Serial_in,
    output Serial_out,
    input data_clock,
    input phase_clock,
    input Dn_in, Dn_1_in, Pn_in,
    output Dn_out, Dn_1_out, Pn_out,
    input [1:0] decision_in,
    output [1:0] decision_out,
    input recovered_clock,
    output [8:0] phase_shift,
    output [9:0] TxParallel_10_out, RxParallel_10_out,
    output RxDataK_out,
    output [7:0] RxParallel_8_out
);
    
    encoder encoder(.BitCLK_10(TxBitCLK_10), .Reset(Reset), .TxParallel_8(TxParallel_8_in), .TxDataK(TxDataK_in), .TxParallel_10(TxParallel_10_out));
    PISO PISO(.BitCLK(TxBitCLK), .Reset(Reset), .Serial(Serial_out), .TxParallel_10(TxParallel_10_in));
    SIPO SIPO(.BitCLK(RxBitCLK), .Reset(Reset), .Serial(Serial_in), .RxParallel_10(RxParallel_10_out));
    decoder decoder(.BitCLK_10(RxBitCLK_10), .Reset(Reset), .RxParallel_10(RxParallel_10_in), .RxDataK(RxDataK_out), .RxParallel_8(RxParallel_8_out));

    wire [1:0] gainsel;
    assign gainsel = 0;

    sampler sampler(.Reset(Reset), .data_clock(data_clock), .phase_clock(phase_clock), .Serial(Serial_in), .Dn_1(Dn_1_out), .Dn(Dn_out), .Pn(Pn_out));
    phase_detector phase_detector(.recovered_clock(recovered_clock), .Reset(Reset), .Dn_1(Dn_1_in), .Dn(Dn_in), .Pn(Pn_in), .decision(decision_out));
    loop_filter loop_filter(.input_signal(decision_in), .recovered_clock(recovered_clock), .Reset(Reset), .gainsel(gainsel), .output_signal(phase_shift));

endmodule
