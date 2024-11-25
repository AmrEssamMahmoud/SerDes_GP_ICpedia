module encoder (
    input BitCLK_10,
    input Reset,
    input [7:0] TxParallel_8,
    input TxDataK,
    output [9:0] TxParallel_10
);

reg disparity;
reg [5:0] TxParallel_6;
reg [3:0] TxParallel_4;

assign TxParallel_10 = {TxParallel_6, TxParallel_4};

always @(posedge BitCLK_10, negedge Reset) begin
    if (!Reset) begin
        TxParallel_6 = 0;
    end else begin
        TxParallel_6 = 0;
        if (disparity) begin
            case (TxParallel_8[4:0])
                5'h0: TxParallel_6 = 6'b100111;
                5'h1: TxParallel_6 = 6'b011101;
                5'h2: TxParallel_6 = 6'b101101;
                5'h3: TxParallel_6 = 6'b110001;
                5'h4: TxParallel_6 = 6'b110101;
                5'h5: TxParallel_6 = 6'b101001;
                5'h6: TxParallel_6 = 6'b011001;
                5'h7: TxParallel_6 = 6'b111000;
                5'h8: TxParallel_6 = 6'b111001;
                5'h9: TxParallel_6 = 6'b100101;
                5'hA: TxParallel_6 = 6'b010101;
                5'hB: TxParallel_6 = 6'b110100;
                5'hC: TxParallel_6 = 6'b001101;
                5'hD: TxParallel_6 = 6'b101100;
                5'hE: TxParallel_6 = 6'b011100;
                5'hF: TxParallel_6 = 6'b010111;
                5'h10: TxParallel_6 = 6'b011011;
                5'h11: TxParallel_6 = 6'b100011;
                5'h12: TxParallel_6 = 6'b010011;
                5'h13: TxParallel_6 = 6'b110010;
                5'h14: TxParallel_6 = 6'b001011;
                5'h15: TxParallel_6 = 6'b101010;
                5'h16: TxParallel_6 = 6'b011010;
                5'h17: TxParallel_6 = 6'b111010;
                5'h18: TxParallel_6 = 6'b110011;
                5'h19: TxParallel_6 = 6'b100110;
                5'h1A: TxParallel_6 = 6'b010110;
                5'h1B: TxParallel_6 = 6'b110110;
                5'h1C: begin
                    if (TxDataK)
                        TxParallel_6 = 6'b001111;
                    else
                        TxParallel_6 = 6'b001110;
                end
                5'h1D: TxParallel_6 = 6'b101110;
                5'h1E: TxParallel_6 = 6'b011110;
                5'h1F: TxParallel_6 = 6'b101011;
                default: TxParallel_6 = 0;
            endcase
        end else begin
            case (TxParallel_8[4:0])
                5'h0: TxParallel_6 = 6'b011000;
                5'h1: TxParallel_6 = 6'b100010;
                5'h2: TxParallel_6 = 6'b010010;
                5'h3: TxParallel_6 = 6'b110001;
                5'h4: TxParallel_6 = 6'b001010;
                5'h5: TxParallel_6 = 6'b101001;
                5'h6: TxParallel_6 = 6'b011001;
                5'h7: TxParallel_6 = 6'b000111;
                5'h8: TxParallel_6 = 6'b000110;
                5'h9: TxParallel_6 = 6'b100101;
                5'hA: TxParallel_6 = 6'b010101;
                5'hB: TxParallel_6 = 6'b110100;
                5'hC: TxParallel_6 = 6'b001101;
                5'hD: TxParallel_6 = 6'b101100;
                5'hE: TxParallel_6 = 6'b011100;
                5'hF: TxParallel_6 = 6'b101000;
                5'h10: TxParallel_6 = 6'b100100;
                5'h11: TxParallel_6 = 6'b100011;
                5'h12: TxParallel_6 = 6'b010011;
                5'h13: TxParallel_6 = 6'b110010;
                5'h14: TxParallel_6 = 6'b001011;
                5'h15: TxParallel_6 = 6'b101010;
                5'h16: TxParallel_6 = 6'b011010;
                5'h17: TxParallel_6 = 6'b000101;
                5'h18: TxParallel_6 = 6'b001100;
                5'h19: TxParallel_6 = 6'b100110;
                5'h1A: TxParallel_6 = 6'b010110;
                5'h1B: TxParallel_6 = 6'b001001;
                5'h1C: begin
                    if (TxDataK)
                        TxParallel_6 = 6'b110000;
                    else
                        TxParallel_6 = 6'b001110;
                end
                5'h1D: TxParallel_6 = 6'b010001;
                5'h1E: TxParallel_6 = 6'b100001;
                5'h1F: TxParallel_6 = 6'b010100;
                default: TxParallel_6 = 0;
            endcase
        end
    end
end

always @(posedge BitCLK_10, negedge Reset) begin
    if (!Reset) begin
        TxParallel_4 = 0;
    end else begin
        TxParallel_4 = 0;
        if (TxDataK) begin
            if (disparity) begin
                case (TxParallel_8[7:5])
                    3'h0: TxParallel_4 = 4'b1011;
                    3'h1: TxParallel_4 = 4'b0110;
                    3'h2: TxParallel_4 = 4'b1010;
                    3'h3: TxParallel_4 = 4'b1100;
                    3'h4: TxParallel_4 = 4'b1101;
                    3'h5: TxParallel_4 = 4'b0101;
                    3'h6: TxParallel_4 = 4'b1001;
                    3'h7: TxParallel_4 = 4'b0111;
                    default: TxParallel_4 = 0;
                endcase
            end else begin
                case (TxParallel_8[7:5])
                    3'h0: TxParallel_4 = 4'b0100;
                    3'h1: TxParallel_4 = 4'b1001;
                    3'h2: TxParallel_4 = 4'b0101;
                    3'h3: TxParallel_4 = 4'b0011;
                    3'h4: TxParallel_4 = 4'b0010;
                    3'h5: TxParallel_4 = 4'b1010;
                    3'h6: TxParallel_4 = 4'b0110;
                    3'h7: TxParallel_4 = 4'b1000;
                    default: TxParallel_4 = 0;
                endcase
            end
        end else begin
            if (disparity) begin
                case (TxParallel_8[7:5])
                    3'h0: TxParallel_4 = 4'b1011;
                    3'h1: TxParallel_4 = 4'b1001;
                    3'h2: TxParallel_4 = 4'b0101;
                    3'h3: TxParallel_4 = 4'b1100;
                    3'h4: TxParallel_4 = 4'b1101;
                    3'h5: TxParallel_4 = 4'b1010;
                    3'h6: TxParallel_4 = 4'b0110;
                    3'h7: begin
                        if (TxParallel_8[4:0] == 17 || TxParallel_8[4:0] == 18 || TxParallel_8[4:0] == 20)
                            TxParallel_4 = 4'b0111;
                        else
                            TxParallel_4 = 4'b1110;
                    end
                    default: TxParallel_4 = 0;
                endcase
            end else begin
                case (TxParallel_8[7:5])
                    3'h0: TxParallel_4 = 4'b0100;
                    3'h1: TxParallel_4 = 4'b1001;
                    3'h2: TxParallel_4 = 4'b0101;
                    3'h3: TxParallel_4 = 4'b0011;
                    3'h4: TxParallel_4 = 4'b0010;
                    3'h5: TxParallel_4 = 4'b1010;
                    3'h6: TxParallel_4 = 4'b0110;
                    3'h7: begin
                        if (TxParallel_8[4:0] == 17 || TxParallel_8[4:0] == 18 || TxParallel_8[4:0] == 20)
                            TxParallel_4 = 4'b1000; 
                        else
                            TxParallel_4 = 4'b0001;
                    end
                    default: TxParallel_4 = 0;
                endcase
            end
        end
    end
end
    
always @(posedge BitCLK_10, negedge Reset) begin
    if (!Reset) begin
        disparity <= 0;
    end else begin
        if (^TxParallel_6 || TxParallel_6 == 6'b111000 || TxParallel_6 == 6'b000111) begin
            disparity <= disparity + 1;
        end
    end
    
end

endmodule