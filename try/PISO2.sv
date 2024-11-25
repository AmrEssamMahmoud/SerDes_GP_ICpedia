// module PISO(
//     input wire[9:0] parallel_in,
//     input wire clk,
//     input wire rst_n,
//     output reg serial_out
//     );
// reg[9:0] temp_reg;
// reg [3:0] bit_count;
// always @(posedge clk or negedge rst_n) begin
//     if(!rst_n)begin
//         temp_reg<=10'b0;
//         serial_out<=0;
//         bit_count<=0;
//     end 
//     else begin
//         if (bit_count == 0) begin
//         temp_reg<=parallel_in; 
//         bit_count<=9;  
//         end
//         else begin
//         serial_out<=temp_reg[9];
//         temp_reg<={temp_reg[8:0],0};
//         bit_count<=bit_count-1;
//         end
//     end
// end

// endmodule
// module PISO(
//     PISO_Interface.DUT dut_if
// );

//     // Internal registers
//     reg [9:0] temp_reg;
//     reg [3:0] bit_count;

//     always @(posedge dut_if.clk or negedge dut_if.rst_n) begin
//         if (!dut_if.rst_n) begin
//             temp_reg <= 10'b0;
//             dut_if.serial_out <= 0;
//             bit_count <= 0;
//         end 
//         else begin
//             if (bit_count == 0) begin
//                 temp_reg <= dut_if.parallel_in; 
//                 bit_count <= 9;  
//             end
//             else begin
//                 dut_if.serial_out <= temp_reg[9];
//                 temp_reg <= {temp_reg[8:0], 1'b0};
//                 bit_count <= bit_count - 1;
//             end
//         end
//     end

// endmodule
// module PISO(
//   PISO_Interface.DUT dut_if
//   );
// reg[9:0] temp_reg;  //temp_reg to hold the input parallel data
// reg [3:0] bit_count; //couter to keep track the number of input bits
// //shifting the input bits to serialize them 
// always @(posedge dut_if.clk or negedge dut_if.rst_n) begin
//   if(!dut_if.rst_n)begin
//       temp_reg<=10'b0;
//       bit_count<=0;
//   end 
//   else begin
//       if (bit_count == 0) begin
//       temp_reg<=dut_if.parallel_in; 
//       bit_count<=9;     
//       end
//       else begin
//       temp_reg<=temp_reg>>1;
//       bit_count<=bit_count-1;
//       end
//   end
// end
// assign dut_if.serial_out = temp_reg[0];
// endmodule
module PISO (
    PISO_Interface.DUT dut_if  // Input interface declaration
);
    reg [9:0] temp_reg;        // Temporary register to hold parallel data
    reg [3:0] bit_count;       // Counter to track the number of input bits

    // Shifting the input bits to serialize them
    always @(posedge dut_if.clk or negedge dut_if.rst_n) begin
        if (!dut_if.rst_n) begin
            temp_reg <= 10'b0;    // Reset temp_reg
            bit_count <= 0;       // Reset bit count
        end 
        else begin
            if (bit_count == 0) begin
                temp_reg <= dut_if.parallel_in;  // Load parallel data
                bit_count <= 10;                 // Initialize bit counter
            end
            else begin
                temp_reg <= temp_reg >> 1;      // Shift data
                bit_count <= bit_count - 1;     // Decrement bit counter
            end
        end
    end

    assign dut_if.serial_out = temp_reg[0]; // Assign LSB as serial output
endmodule
