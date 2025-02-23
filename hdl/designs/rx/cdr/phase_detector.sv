module phase_detector (
	input wire recovered_clock, Reset,
    input wire Dn_1,          // Previous data sample
    input wire Pn,            // Phase sample
    input wire Dn,            // Current data sample
    output reg [1:0] decision // Decision output: 2 bits to represent {early, late}
);

	wire early, late;
	reg [1:0] decision_comb;

	assign early = Dn ^ Pn; 
	assign late = Pn ^ Dn_1; 

	always @(posedge recovered_clock or negedge Reset) begin
		if (!Reset) begin
			decision <= 0;
		end else begin
			decision <= decision_comb;
		end
	end

	always @(*) begin
		if (early && !late) begin
			decision_comb = 2'b11;               
		end
		else if (late && !early) begin
			decision_comb = 2'b01;
		end
		else begin
			decision_comb = 2'b00;
		end
	end

endmodule