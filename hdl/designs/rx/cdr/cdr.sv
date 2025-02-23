module cdr (
    input Reset,
    input Serial,
    input data_clock,
    input phase_clock,
    input recovered_clock,
    output [8:0] phase_shift
);
    
    wire Dn, Dn_1, Pn;
    wire [1:0] decision, gainsel;

    assign gainsel = 0;

    sampler sampler(.Reset(Reset), .data_clock(data_clock), .phase_clock(phase_clock), .Serial(Serial), .Dn_1(Dn_1), .Dn(Dn), .Pn(Pn));
    phase_detector phase_detector(.recovered_clock(recovered_clock), .Reset(Reset), .Dn_1(Dn_1), .Dn(Dn), .Pn(Pn), .decision(decision));
    loop_filter loop_filter(.input_signal(decision), .recovered_clock(recovered_clock), .Reset(Reset), .gainsel(gainsel), .output_signal(phase_shift));

endmodule