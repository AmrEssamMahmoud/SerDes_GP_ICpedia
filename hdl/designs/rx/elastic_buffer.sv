
module elastic_buffer (
    // Recovered Clock Domain signals
    input wire          rclk,        // Recovered clock
    input wire          rrst_n,      // Recovered clock domain reset, active low
    input wire [9:0]    data_in,     // Input data (10 bits)
    input wire          data_in_vld, // Input data valid
    output wire         full,        // Buffer full indicator
    
    // Local Clock Domain signals
    input wire          lclk,        // Local clock
    input wire          lrst_n,      // Local clock domain reset, active low
    output reg [9:0]    data_out,    // Output data (10 bits)
    output reg          data_out_vld,// Output data valid
    output wire         empty        // Buffer empty indicator
);

    // Define SKP symbols as per USB 3.0 specifications
    // COM symbol followed by SKP symbol
    localparam [9:0] SKP_SYM1 = 10'h0f9; // First SKP symbol (COM)
    localparam [9:0] SKP_SYM2 = 10'h306; // Second SKP symbol (SKP)

    // Buffer size parameters
    localparam FIFO_DEPTH = 16;         // Total buffer depth
    localparam ADDR_WIDTH = 4;          // Address width = log2(FIFO_DEPTH)
    localparam HALF_FULL = 8;           // Half-full threshold
    localparam ADD_THRESHOLD = 6;       // Threshold to add SKP
    localparam DEL_THRESHOLD = 10;      // Threshold to delete SKP

    // Memory element (dual-port RAM)
    reg [9:0] mem [0:FIFO_DEPTH-1];
    
    // Write pointer control (Recovered Clock Domain)
    reg [ADDR_WIDTH-1:0] wr_ptr_bin;       // Binary write pointer
    reg [ADDR_WIDTH-1:0] wr_ptr_gray;      // Gray-coded write pointer
    wire [ADDR_WIDTH-1:0] wr_ptr_bin_next;
    wire [ADDR_WIDTH-1:0] wr_ptr_gray_next;
    
    // Read pointer control (Local Clock Domain)
    reg [ADDR_WIDTH-1:0] rd_ptr_bin;       // Binary read pointer
    reg [ADDR_WIDTH-1:0] rd_ptr_gray;      // Gray-coded read pointer
    wire [ADDR_WIDTH-1:0] rd_ptr_bin_next;
    wire [ADDR_WIDTH-1:0] rd_ptr_gray_next;
    
    // Synchronization registers for crossing clock domains
    reg [ADDR_WIDTH-1:0] wr_ptr_gray_sync1, wr_ptr_gray_sync2; // Sync to local clock
    reg [ADDR_WIDTH-1:0] rd_ptr_gray_sync1, rd_ptr_gray_sync2; // Sync to recovered clock
    
    // Binary converted synchronized pointers
    wire [ADDR_WIDTH-1:0] wr_ptr_sync_bin; // Write pointer in local clock domain
    wire [ADDR_WIDTH-1:0] rd_ptr_sync_bin; // Read pointer in recovered clock domain
    
    // Control signals
    reg is_skp;                         // Flag to detect SKP symbols
    reg skp_delete_req;                 // Request to delete SKP
    reg skp_delete;                     // Delete SKP command
    reg skp_add_req;                    // Request to add SKP
    reg skp_add;                        // Add SKP command
    reg read_pause;                     // Pause read pointer flag
    reg write_pause;                    // Pause write pointer flag
    reg is_output_skp;                  // Flag indicating output is SKP
    reg [3:0] valid_data_count;         // Count of valid data in FIFO
    
    reg skp_pair_detected;              // Flag for detecting SKP symbol pair
    reg [1:0] skp_count;                // Counter for SKP symbol pair
    reg skp_insert;                     // Flag to insert SKP symbols
    reg [1:0] skp_insert_count;         // Counter for inserting SKP symbols
    
    // Convert from Gray code to binary
    function [ADDR_WIDTH-1:0] gray2bin;
        input [ADDR_WIDTH-1:0] gray;
        reg [ADDR_WIDTH-1:0] bin;
        integer i;
        begin
            bin = 0;
            for (i = 0; i < ADDR_WIDTH; i = i + 1)
                bin[i] = ^(gray >> i);
            gray2bin = bin;
        end
    endfunction
    
    // Convert from binary to Gray code
    function [ADDR_WIDTH-1:0] bin2gray;
        input [ADDR_WIDTH-1:0] bin;
        begin
            bin2gray = bin ^ (bin >> 1);
        end
    endfunction
    
    // Calculate valid data count based on synchronized pointers
    always @* begin
        if (wr_ptr_sync_bin >= rd_ptr_bin)
            valid_data_count = wr_ptr_sync_bin - rd_ptr_bin;
        else
            valid_data_count = FIFO_DEPTH + wr_ptr_sync_bin - rd_ptr_bin;
    end
    
    // Input SKP detection logic (Recovered Clock Domain)
    always @(posedge rclk or negedge rrst_n) begin
        if (!rrst_n) begin
            skp_count <= 2'd0;
            skp_pair_detected <= 1'b0;
        end else if (data_in_vld) begin
            if (data_in == SKP_SYM1 && skp_count == 2'd0) begin
                skp_count <= 2'd1;
                skp_pair_detected <= 1'b0;
            end else if (data_in == SKP_SYM2 && skp_count == 2'd1) begin
                skp_count <= 2'd0;
                skp_pair_detected <= 1'b1;
            end else begin
                skp_count <= 2'd0;
                skp_pair_detected <= 1'b0;
            end
        end
    end
    
    // SKP delete request logic (Recovered Clock Domain)
    always @(posedge rclk or negedge rrst_n) begin
        if (!rrst_n) begin
            skp_delete_req <= 1'b0;
        end else begin
            skp_delete_req <= (valid_data_count > DEL_THRESHOLD);
        end
    end
    
    // SKP delete control logic (Recovered Clock Domain)
    always @(posedge rclk or negedge rrst_n) begin
        if (!rrst_n) begin
            skp_delete <= 1'b0;
        end else begin
            skp_delete <= skp_delete_req && skp_pair_detected && !full;
        end
    end
    
    // Write pointer logic (Recovered Clock Domain)
    always @(posedge rclk or negedge rrst_n) begin
        if (!rrst_n) begin
            wr_ptr_bin = {ADDR_WIDTH{HALF_FULL}};
            wr_ptr_gray = bin2gray(wr_ptr_bin);
            write_pause <= 1'b0;
        end else if (data_in_vld) begin
            if (skp_delete) begin
                // Pause write pointer for SKP deletion
                write_pause <= 1'b1;
            end else begin
                // Normal write operation
                wr_ptr_bin <= wr_ptr_bin_next;
                wr_ptr_gray <= wr_ptr_gray_next;
                write_pause <= 1'b0;
            end
        end else begin
            write_pause <= 1'b0;
        end
    end
    
    // Calculate next write pointer values
    assign wr_ptr_bin_next = (write_pause) ? wr_ptr_bin : ((wr_ptr_bin == FIFO_DEPTH-1) ? {ADDR_WIDTH{1'b0}} : wr_ptr_bin + 1'b1);
    assign wr_ptr_gray_next = bin2gray(wr_ptr_bin_next);
    
    // Write data to memory (Recovered Clock Domain)
    always @(posedge rclk) begin
        if (data_in_vld && !full && !write_pause) begin
            mem[wr_ptr_bin] <= data_in;
        end
    end
    
    // Synchronize write pointer to local clock domain
    always @(posedge lclk or negedge lrst_n) begin
        if (!lrst_n) begin
            wr_ptr_gray_sync1 <= {ADDR_WIDTH{1'b0}};
            wr_ptr_gray_sync2 <= {ADDR_WIDTH{1'b0}};
        end else begin
            wr_ptr_gray_sync1 <= wr_ptr_gray;
            wr_ptr_gray_sync2 <= wr_ptr_gray_sync1;
        end
    end
    
    // Convert synchronized Gray code write pointer to binary
    assign wr_ptr_sync_bin = gray2bin(wr_ptr_gray_sync2);
    
    // SKP add request logic (Local Clock Domain)
    always @(posedge lclk or negedge lrst_n) begin
        if (!lrst_n) begin
            skp_add_req <= 1'b0;
        end else begin
            skp_add_req <= (valid_data_count < ADD_THRESHOLD);
        end
    end
    
    // Output SKP detection and SKP add control logic (Local Clock Domain)
    always @(posedge lclk or negedge lrst_n) begin
        if (!lrst_n) begin
            is_output_skp <= 1'b0;
            skp_add <= 1'b0;
            skp_insert <= 1'b0;
            skp_insert_count <= 2'd0;
        end else begin
            // Detect if current output data is a SKP symbol
            if (mem[rd_ptr_bin] == SKP_SYM1) begin
                is_output_skp <= 1'b1;
            end else if (mem[rd_ptr_bin] == SKP_SYM2 && is_output_skp) begin
                is_output_skp <= 1'b0;
                // Activate SKP add if needed
                skp_add <= skp_add_req && !empty;
            end else begin
                is_output_skp <= 1'b0;
                skp_add <= 1'b0;
            end
            
            // Control SKP insertion process
            if (skp_add) begin
                skp_insert <= 1'b1;
                skp_insert_count <= 2'd0;
            end else if (skp_insert) begin
                if (skp_insert_count == 2'd1) begin
                    skp_insert <= 1'b0;
                end else begin
                    skp_insert_count <= skp_insert_count + 1'b1;
                end
            end
        end
    end
    
    // Read pointer logic (Local Clock Domain)
    always @(posedge lclk or negedge lrst_n) begin
        if (!lrst_n) begin
            rd_ptr_bin <= {ADDR_WIDTH{1'b0}};
            rd_ptr_gray <= {ADDR_WIDTH{1'b0}};
            read_pause <= 1'b0;
        end else if (!empty) begin
            if (skp_insert) begin
                // Pause read pointer for SKP insertion
                read_pause <= 1'b1;
            end else begin
                // Normal read operation
                rd_ptr_bin <= rd_ptr_bin_next;
                rd_ptr_gray <= rd_ptr_gray_next;
                read_pause <= 1'b0;
            end
        end else begin
            read_pause <= 1'b0;
        end
    end
    
    // Calculate next read pointer values
    assign rd_ptr_bin_next = (read_pause) ? rd_ptr_bin : ((rd_ptr_bin == FIFO_DEPTH-1) ? {ADDR_WIDTH{1'b0}} : rd_ptr_bin + 1'b1);
    assign rd_ptr_gray_next = bin2gray(rd_ptr_bin_next);
    
    // Read data and control output (Local Clock Domain)
    always @(posedge lclk or negedge lrst_n) begin
        if (!lrst_n) begin
            data_out <= 10'd0;
            data_out_vld <= 1'b0;
        end else begin
            if (skp_insert) begin
                // Output SKP symbols during insertion
                data_out_vld <= 1'b1;
                if (skp_insert_count == 2'd0) begin
                    data_out <= SKP_SYM1; // First SKP symbol
                end else begin
                    data_out <= SKP_SYM2; // Second SKP symbol
                end
            end else if (!empty) begin
                // Normal read operation
                data_out <= mem[rd_ptr_bin];
                data_out_vld <= 1'b1;
            end else begin
                data_out_vld <= 1'b0;
            end
        end
    end
    
    // Synchronize read pointer to recovered clock domain
    always @(posedge rclk or negedge rrst_n) begin
        if (!rrst_n) begin
            rd_ptr_gray_sync1 <= {ADDR_WIDTH{1'b0}};
            rd_ptr_gray_sync2 <= {ADDR_WIDTH{1'b0}};
        end else begin
            rd_ptr_gray_sync1 <= rd_ptr_gray;
            rd_ptr_gray_sync2 <= rd_ptr_gray_sync1;
        end
    end
    
    // Convert synchronized Gray code read pointer to binary
    assign rd_ptr_sync_bin = gray2bin(rd_ptr_gray_sync2);
    
    // Generate empty and full flags
    assign empty = (rd_ptr_gray == wr_ptr_gray_sync2);
    assign full = (wr_ptr_gray == {~rd_ptr_gray_sync2[ADDR_WIDTH-1:ADDR_WIDTH-2], rd_ptr_gray_sync2[ADDR_WIDTH-3:0]});


property write_ptr_increments;
  @(posedge rclk)
  disable iff (!rrst_n)
  data_in_vld |=> ((wr_ptr_bin == $past(wr_ptr_bin) + 1) || (wr_ptr_bin == 0 && $past(wr_ptr_bin) == FIFO_DEPTH-1));
endproperty

assert property (write_ptr_increments);
cover property (write_ptr_increments);

property read_ptr_increments;
  @(posedge lclk)
  disable iff (!lrst_n)
  data_out_vld |-> ((rd_ptr_bin == $past(rd_ptr_bin) + 1) || (rd_ptr_bin == 0 && $past(rd_ptr_bin) == FIFO_DEPTH-1));
endproperty

assert property (read_ptr_increments);
cover property (read_ptr_increments);

property fifo_empty_flag_check;
  @(posedge rclk)
  disable iff (rrst_n)
  (rd_ptr_sync_bin == wr_ptr_sync_bin) |-> empty;
endproperty

assert property (fifo_empty_flag_check);
cover property (fifo_empty_flag_check);

property fifo_full_flag_check;
  @(posedge lclk)
  disable iff (lrst_n)
  ((wr_ptr_sync_bin + 1) % FIFO_DEPTH == rd_ptr_sync_bin) |-> empty;
endproperty

assert property (fifo_full_flag_check);
cover property (fifo_full_flag_check);

endmodule