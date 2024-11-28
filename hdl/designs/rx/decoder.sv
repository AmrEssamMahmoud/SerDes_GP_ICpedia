module decoder (
    input BitCLK_10,
    input Reset,
    input [9:0] RxParallel_10,
    output RxDataK,
    output [7:0] RxParallel_8
);

reg disparity, RxDataK_5, RxDataK_3;
reg [4:0] RxParallel_5;
reg [2:0] RxParallel_3;

assign RxDataK = RxDataK_3 || RxDataK_5;
assign RxParallel_8 = {RxParallel_3, RxParallel_5};

always @(posedge BitCLK_10, negedge Reset) begin
    if (!Reset) begin
        RxDataK_5 = 0;
        RxParallel_5 = 0;
    end else begin
        RxDataK_5 = 0;
        RxParallel_5 = 0;
        case (RxParallel_10[9:4])
            6'h5: RxParallel_5 = 5'h17;
            6'h6: RxParallel_5 = 5'h8;
            6'h7: RxParallel_5 = 5'h7;
            6'h9: RxParallel_5 = 5'h1B;
            6'hA: RxParallel_5 = 5'h4;
            6'hB: RxParallel_5 = 5'h14;
            6'hC: RxParallel_5 = 5'h18;
            6'hD: RxParallel_5 = 5'hC;
            6'hE: RxParallel_5 = 5'h1C;
            6'hF: begin
                RxDataK_5 = 1;
                RxParallel_5 =  5'h1C;
            end
            6'h11: RxParallel_5 = 5'h1D;
            6'h12: RxParallel_5 = 5'h2;
            6'h13: RxParallel_5 = 5'h12;
            6'h14: RxParallel_5 = 5'h1F;
            6'h15: RxParallel_5 = 5'hA;
            6'h16: RxParallel_5 = 5'h1A;
            6'h17: RxParallel_5 = 5'hF;
            6'h18: RxParallel_5 = 5'h0;
            6'h19: RxParallel_5 = 5'h6;
            6'h1A: RxParallel_5 = 5'h16;
            6'h1B: RxParallel_5 = 5'h10;
            6'h1C: RxParallel_5 = 5'hE;
            6'h1D: RxParallel_5 = 5'h1;
            6'h1E: RxParallel_5 = 5'h1E;
            6'h21: RxParallel_5 = 5'h1E;
            6'h22: RxParallel_5 = 5'h1;
            6'h23: RxParallel_5 = 5'h11;
            6'h24: RxParallel_5 = 5'h10;
            6'h25: RxParallel_5 = 5'h9;
            6'h26: RxParallel_5 = 5'h19;
            6'h27: RxParallel_5 = 5'h0;
            6'h28: RxParallel_5 = 5'hF;
            6'h29: RxParallel_5 = 5'h5;
            6'h2A: RxParallel_5 = 5'h15;
            6'h2B: RxParallel_5 = 5'h1F;
            6'h2C: RxParallel_5 = 5'hD;
            6'h2D: RxParallel_5 = 5'h2;
            6'h2E: RxParallel_5 = 5'h1D;
            6'h30: begin
                RxDataK_5 = 1;
                RxParallel_5 = 5'h1C;
            end
            6'h31: RxParallel_5 = 5'h3;
            6'h32: RxParallel_5 = 5'h13;
            6'h33: RxParallel_5 = 5'h18;
            6'h34: RxParallel_5 = 5'hB;
            6'h35: RxParallel_5 = 5'h4;
            6'h36: RxParallel_5 = 5'h1B;
            6'h38: RxParallel_5 = 5'h7;
            6'h39: RxParallel_5 = 5'h8;
            6'h3A: RxParallel_5 = 5'h17;
            default: RxParallel_5 = 0;
        endcase
    end
end

always @(posedge BitCLK_10, negedge Reset) begin
    if (!Reset) begin
        RxDataK_3 = 0;
        RxParallel_3 = 0;
    end else begin
        RxDataK_3 = 0;
        RxParallel_3 = 0;
        case (RxParallel_10[3:0])
            4'h1: RxParallel_3 = 3'h7;
            4'h2: RxParallel_3 = 3'h4;
            4'h3: RxParallel_3 = 3'h3;
            4'h4: RxParallel_3 = 3'h0;
            4'h5: RxParallel_3 = 3'h2;
            4'h6: RxParallel_3 = 3'h6;
            4'h7: begin
                if (RxParallel_5 == 23 || RxParallel_5 == 27 || RxParallel_5 == 29 || RxParallel_5 == 30) begin
                    RxDataK_3 = 1;
                end
                RxParallel_3 = 3'h7;
            end
            4'h8: begin
                if (RxParallel_5 == 23 || RxParallel_5 == 27 || RxParallel_5 == 29 || RxParallel_5 == 30) begin
                    RxDataK_3 = 1;
                end
                RxParallel_3 = 3'h7;
            end
            4'h9: RxParallel_3 = 3'h1;
            4'hA: RxParallel_3 = 3'h5;
            4'hB: RxParallel_3 = 3'h0;
            4'hC: RxParallel_3 = 3'h3;
            4'hD: RxParallel_3 = 3'h4;
            4'hE: RxParallel_3 = 3'h7;
            default: RxParallel_3 = 0;
        endcase
    end
end

endmodule