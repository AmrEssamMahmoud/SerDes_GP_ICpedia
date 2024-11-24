module ser_to_parallel(
    input clk,
    input rst,
    output [9:0] op,
    input ip);
    reg [9:0] TR;
    reg [3:0] count;
    always @(posedge clk or rst) begin
        if (rst) begin
            count <=4'b0000;
            TR<=0;
        end else begin
            case (count)
                1'h0:
                TR[0]<=ip;
                1'h1:
                TR[1]<=ip;
                1'h2:
                TR[2]<=ip;
                1'h3:
                TR[3]<=ip;
                1'h4:
                TR[4]<=ip;
                1'h5:
                TR[5]<=ip;
                1'h6:
                TR[6]<=ip;
                1'h7:
                TR[7]<=ip;
                1'h8:
                TR[8]<=ip;
                1'h9:
                TR[9]<=ip;
                1'hA:
                TR[0]<=ip;
                1'hB:
                TR[1]<=ip;
                1'hC:
                TR[2]<=ip;
                1'hD:
                TR[3]<=ip;
                1'hE:
                TR[4]<=ip;
                1'hF:
                TR[5]<=ip;
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