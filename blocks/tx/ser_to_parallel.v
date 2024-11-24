module ser_to_parallel(
    input clk,
    input rst,
    input [9:0] ip,
    output op);
    reg TR;
    reg [3:0] count;
    always @(posedge clk or rst) begin
        if (rst) begin
            count <=4'b0000;
            TR<=0;
        end else begin
            case (count)
                1'h0:
                TR<=ip[0];
                1'h1:
                TR<=ip[1];
                1'h2:
                TR<=ip[2];
                1'h3:
                TR<=ip[3];
                1'h4:
                TR<=ip[4];
                1'h5:
                TR<=ip[5];
                1'h6:
                TR<=ip[6];
                1'h7:
                TR<=ip[7];
                1'h8:
                TR<=ip[8];
                1'h9:
                TR<=ip[9];
                1'hA:
                TR<=ip[0];
                1'hB:
                TR<=ip[1];
                1'hC:
                TR<=ip[2];
                1'hD:
                TR<=ip[3];
                1'hE:
                TR<=ip[4];
                1'hF:
                TR<=ip[5];
            endcase
            if (count==1'hF) begin
                count<=1'h6;
            end else begin
                count<=count+1;
            end
        end
    end
    assign op = TR;
endmodule