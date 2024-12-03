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

always @(*) begin
    RxDataK_5 = 0;
    RxParallel_5 = 0;
    case (RxParallel_10[5:0])
        6'h03: begin
            RxDataK_5 = 1;
            RxParallel_5 = 5'h1C;
        end
        6'h05: RxParallel_5 = 5'h0F;
        6'h06: RxParallel_5 = 5'h00;
        6'h07: RxParallel_5 = 5'h07;
        6'h09: RxParallel_5 = 5'h10;
        6'h0A: RxParallel_5 = 5'h1F;
        6'h0B: RxParallel_5 = 5'h0B;
        6'h0C: RxParallel_5 = 5'h18;
        6'h0D: RxParallel_5 = 5'h0D;
        6'h0E: RxParallel_5 = 5'h0E;
        6'h11: RxParallel_5 = 5'h01;
        6'h12: RxParallel_5 = 5'h02;
        6'h13: RxParallel_5 = 5'h13;
        6'h14: RxParallel_5 = 5'h04;
        6'h15: RxParallel_5 = 5'h15;
        6'h16: RxParallel_5 = 5'h16;
        6'h17: RxParallel_5 = 5'h17;
        6'h18: RxParallel_5 = 5'h08;
        6'h19: RxParallel_5 = 5'h19;
        6'h1A: RxParallel_5 = 5'h1A;
        6'h1B: RxParallel_5 = 5'h1B;
        6'h1C: RxParallel_5 = 5'h1C;
        6'h1D: RxParallel_5 = 5'h1D;
        6'h1E: RxParallel_5 = 5'h1E;
        6'h21: RxParallel_5 = 5'h1E;
        6'h22: RxParallel_5 = 5'h1D;
        6'h23: RxParallel_5 = 5'h03;
        6'h24: RxParallel_5 = 5'h1B;
        6'h25: RxParallel_5 = 5'h05;
        6'h26: RxParallel_5 = 5'h06;
        6'h27: RxParallel_5 = 5'h08;
        6'h28: RxParallel_5 = 5'h17;
        6'h29: RxParallel_5 = 5'h09;
        6'h2A: RxParallel_5 = 5'h0A;
        6'h2B: RxParallel_5 = 5'h04;
        6'h2C: RxParallel_5 = 5'h0C;
        6'h2D: RxParallel_5 = 5'h02;
        6'h2E: RxParallel_5 = 5'h01;
        6'h31: RxParallel_5 = 5'h11;
        6'h32: RxParallel_5 = 5'h12;
        6'h33: RxParallel_5 = 5'h18;
        6'h34: RxParallel_5 = 5'h14;
        6'h35: RxParallel_5 = 5'h1F;
        6'h36: RxParallel_5 = 5'h10;
        6'h38: RxParallel_5 = 5'h07;
        6'h39: RxParallel_5 = 5'h00;
        6'h3A: RxParallel_5 = 5'h0F;
        6'h3C: begin
            RxDataK_5 = 1;
            RxParallel_5 = 5'h1C;
        end
        default: RxParallel_5 = 0;
    endcase
end

always @(*) begin
    RxDataK_3 = 0;
    RxParallel_3 = 0;
    if (RxDataK_5) begin        
        case (RxParallel_10[9:6])
            4'h1: RxParallel_3 = 3'h7;
            4'h2: RxParallel_3 = 3'h0;
            4'h3: RxParallel_3 = 3'h3;
            4'h4: RxParallel_3 = 3'h4;
            4'h5: begin
                if (RxParallel_10[5:0] == 6'h03) begin
                    RxParallel_3 = 3'h2;
                end else begin
                    RxParallel_3 = 3'h5;
                end
            end
            4'h6: begin
                if (RxParallel_10[5:0] == 6'h03) begin
                    RxParallel_3 = 3'h1;
                end else begin
                    RxParallel_3 = 3'h6;
                end
            end
            4'h9: begin
                if (RxParallel_10[5:0] == 6'h03) begin
                    RxParallel_3 = 3'h6;
                end else begin
                    RxParallel_3 = 3'h1;
                end
            end
            4'hA: begin
                if (RxParallel_10[5:0] == 6'h03) begin
                    RxParallel_3 = 3'h5;
                end else begin
                    RxParallel_3 = 3'h2;
                end
            end
            4'hB: RxParallel_3 = 3'h4;
            4'hC: RxParallel_3 = 3'h3;
            4'hD: RxParallel_3 = 3'h0;
            4'hE: RxParallel_3 = 3'h7;
            default: RxParallel_3 = 0;
        endcase
    end else begin
        case (RxParallel_10[9:6])
            4'h1: begin
                if (RxParallel_5 == 23 || RxParallel_5 == 27 || RxParallel_5 == 29 || RxParallel_5 == 30) begin
                    RxDataK_3 = 1;
                end
                RxParallel_3 = 3'h7;
            end
            4'h2: RxParallel_3 = 3'h0;
            4'h3: RxParallel_3 = 3'h3;
            4'h4: RxParallel_3 = 3'h4;
            4'h5: RxParallel_3 = 3'h5;
            4'h6: RxParallel_3 = 3'h6;
            4'h7: RxParallel_3 = 3'h7;
            4'h8: RxParallel_3 = 3'h7;
            4'h9: RxParallel_3 = 3'h1;
            4'hA: RxParallel_3 = 3'h2;
            4'hB: RxParallel_3 = 3'h4;
            4'hC: RxParallel_3 = 3'h3;
            4'hD: RxParallel_3 = 3'h0;
            4'hE: begin
                if (RxParallel_5 == 23 || RxParallel_5 == 27 || RxParallel_5 == 29 || RxParallel_5 == 30) begin
                    RxDataK_3 = 1;
                end
                RxParallel_3 = 3'h7;
            end
            default: RxParallel_3 = 0;
        endcase
    end
end

endmodule