import uvm_pkg::*;
`include "uvm_macros.svh"
import test::*;

`ifdef EQUALIZATION
    `define EQUALIZATION_CLOCKS
`elsif EQUALIZATION_TOP
    `define EQUALIZATION_CLOCKS
`endif

`ifdef TOP
    `define CDR_CLOCKS
`elsif CDR_TOP
    `define CDR_CLOCKS
`elsif BUFFER
    `define CDR_CLOCKS
`endif

`ifdef EQUALIZATION_CLOCKS
    `timescale 1ps/1ps
`elsif CDR_CLOCKS
    `timescale 1ps/10fs
`else
    `timescale 100ps/100ps
`endif

module top();

    bit TxBitCLK, TxBitCLK_10;
    bit RxBitCLK, RxBitCLK_10;
    bit continous_clock;
    bit continous_clock_equalization;

    `ifdef EQUALIZATION_CLOCKS
        parameter phase_delay = 0;
        parameter tx_clk_delay = 100;
        parameter rx_clk_delay = 100;

        initial begin
            forever begin
                #1 continous_clock = ~continous_clock;
            end
        end
    `elsif TOP
        
        real phase = 0;
        real phase_delay = 200 + (200 * phase / 360);
        real abs_ppm = $urandom_range(300, 0);
        real ppm = $urandom_range(1, 0) ? abs_ppm : -1 * abs_ppm;
        real tx_clk_delay = 100 - (ppm * 1e-4);
        real rx_clk_delay = 100;
        
        initial begin
            forever begin
                #0.05 continous_clock = ~continous_clock;
            end
        end
        initial begin
            forever begin
                #1 continous_clock_equalization = ~continous_clock_equalization;
            end
        end
    `elsif CDR_TOP
        
        real phase = 0;
        real ppm = 0;

        real phase_delay = 200 + (200 * phase / 360);
    
        // delay = (ppm / 1e6) * (UI time period / simulation time unit)
        // delay = (ppm / 1e6) * (200 ps / 1 ps) = ppm * 2e-4
        real tx_clk_delay = 100 - (ppm * 1e-4);
        real rx_clk_delay = 100;

        // bit inc_or_dec = 1;

        // initial begin
        //     forever begin
        //         #(333333.33);
        //         if (inc_or_dec) begin
        //             ppm = ppm + 100;
        //         end else begin
        //             ppm = ppm - 100;
        //         end
        //         if (ppm == 5000) begin
        //             inc_or_dec = 0;
        //         end else if (ppm == 0) begin
        //             inc_or_dec = 1;
        //         end
        //         tx_clk_delay = 100 - (ppm * 1e-4);
        //     end
        // end

        initial begin
            forever begin
                #0.05 continous_clock = ~continous_clock;
            end
        end
    `elsif BUFFER

        real phase_delay = 0;
        real abs_ppm = $urandom_range(5300, 4000);
        real ppm = $urandom_range(1, 0) ? abs_ppm : -1 * abs_ppm;
        real tx_clk_delay = 100 - (ppm * 1e-4);
        real rx_clk_delay = 100;

    `else
        parameter phase_delay = 0;
        parameter tx_clk_delay = 1;
        parameter rx_clk_delay = 1;
    `endif

    initial begin
        $timeformat(-12, 2, " ps");
        #(phase_delay);
        forever begin
            #(10*tx_clk_delay) TxBitCLK_10 = ~TxBitCLK_10;
        end
    end
    initial begin
        #(phase_delay);
        forever begin
            #(tx_clk_delay) TxBitCLK = ~TxBitCLK;
        end
    end
    initial begin
        forever begin
            #(10*rx_clk_delay) RxBitCLK_10 = ~RxBitCLK_10;
        end
    end
    initial begin
        forever begin
            #(rx_clk_delay) RxBitCLK = ~RxBitCLK;
        end
    end

    `ifdef TOP
        real channel_response;
        top_if top_if (TxBitCLK, TxBitCLK_10, RxBitCLK, RxBitCLK_10);
        top_module top_module (
            .TxBitCLK(TxBitCLK),
            .TxBitCLK_10(TxBitCLK_10),
            .RxBitCLK(RxBitCLK),
            .RxBitCLK_10(RxBitCLK_10),
            .Reset(top_if.Reset),
            .TxDataK(top_if.TxDataK),
            .Serial_in(top_if.Serial_in),
            .TxParallel_8(top_if.TxParallel_8[7:0]),
            .data_clock(top_if.data_clock),
            .phase_clock(top_if.phase_clock),
            .recovered_clock(top_if.recovered_clock),
            .RxDataK(top_if.RxDataK),
            .Serial_out(top_if.Serial_out),
            .rx_status(top_if.rx_status),
            .RxParallel_8(top_if.RxParallel_8[7:0]),
            .phase_shift(top_if.phase_shift)
        );
        phase_interpolator phase_interpolator (
            .clk(continous_clock),
            .data_clock(top_if.data_clock),
            .phase_clock(top_if.phase_clock),
            .recovered_clock(top_if.recovered_clock),
            .phase_shift(top_if.phase_shift)
        );
        channel channel (
            .clk(continous_clock_equalization),
            .channel_in(top_if.Serial_out),
            .channel_out(channel_response)
        );
        equalizer equalizer (
            .clk(continous_clock_equalization),
            .equalizer_in(channel_response),
            .equalizer_out(top_if.Serial_in)
        );
        bind top_module assertions_top assertions_top_i(top_if.DUT);
    `elsif EQUALIZATION_TOP
        real channel_response;
        equalization_top_if equalization_top_if (TxBitCLK, TxBitCLK_10);
        equalization_top_module equalization_top_module (
            .BitCLK(TxBitCLK),
            .BitCLK_10(TxBitCLK_10),
            .Reset(equalization_top_if.Reset),
            .TxDataK(equalization_top_if.TxDataK),
            .Serial_in(equalization_top_if.Serial_in),
            .TxParallel_8(equalization_top_if.TxParallel_8[7:0]),
            .RxDataK(equalization_top_if.RxDataK),
            .Serial_out(equalization_top_if.Serial_out),
            .Decode_Error(equalization_top_if.Decode_Error),
            .Disparity_Error(equalization_top_if.Disparity_Error),
            .RxParallel_8(equalization_top_if.RxParallel_8[7:0])
        );
        channel channel (
            .clk(continous_clock),
            .channel_in(equalization_top_if.Serial_out),
            .channel_out(channel_response)
        );
        equalizer equalizer (
            .clk(continous_clock),
            .equalizer_in(channel_response),
            .equalizer_out(equalization_top_if.Serial_in)
        );
        bind equalization_top_module assertions_equalization_top assertions_equalization_top_i(equalization_top_if.DUT);
    `elsif CDR_TOP
        cdr_top_if cdr_top_if (TxBitCLK, TxBitCLK_10, RxBitCLK, RxBitCLK_10, ppm);
        cdr_top_module cdr_top_module (
            .TxBitCLK(TxBitCLK),
            .TxBitCLK_10(TxBitCLK_10),
            .RxBitCLK(TxBitCLK),
            .RxBitCLK_10(TxBitCLK_10),
            .Reset(cdr_top_if.Reset),
            .TxDataK(cdr_top_if.TxDataK),
            .TxParallel_8(cdr_top_if.TxParallel_8[7:0]),
            .data_clock(cdr_top_if.data_clock),
            .phase_clock(cdr_top_if.phase_clock),
            .recovered_clock(cdr_top_if.recovered_clock),
            .RxDataK(cdr_top_if.RxDataK),
            .Decode_Error(cdr_top_if.Decode_Error),
            .Disparity_Error(cdr_top_if.Disparity_Error),
            .RxParallel_8(cdr_top_if.RxParallel_8[7:0]),
            .phase_shift(cdr_top_if.phase_shift)
        );
        phase_interpolator phase_interpolator (
            .clk(continous_clock),
            .data_clock(cdr_top_if.data_clock),
            .phase_clock(cdr_top_if.phase_clock),
            .recovered_clock(cdr_top_if.recovered_clock),
            .phase_shift(cdr_top_if.phase_shift)
        );
        bind cdr_top_module assertions_cdr_top assertions_cdr_top_i(cdr_top_if.DUT);
    `elsif SERDES_TOP
        serdes_top_if serdes_top_if (TxBitCLK, TxBitCLK_10);
        serdes_top_module serdes_top_module (
            .BitCLK(TxBitCLK),
            .BitCLK_10(TxBitCLK_10),
            .Reset(serdes_top_if.Reset),
            .TxDataK(serdes_top_if.TxDataK),
            .TxParallel_8(serdes_top_if.TxParallel_8[7:0]),
            .RxDataK(serdes_top_if.RxDataK),
            .Decode_Error(serdes_top_if.Decode_Error),
            .Disparity_Error(serdes_top_if.Disparity_Error),
            .RxParallel_8(serdes_top_if.RxParallel_8[7:0])
        );
        bind serdes_top_module assertions_serdes_top assertions_serdes_top_i(serdes_top_if.DUT);
    `elsif ENCODER
        encoder_if encoder_if (TxBitCLK_10);
        encoder encoder(
            .BitCLK_10(TxBitCLK_10),
            .Reset(encoder_if.Reset),
            .TxParallel_8(encoder_if.TxParallel_8[7:0]),
            .TxDataK(encoder_if.TxDataK),
            .TxParallel_10(encoder_if.TxParallel_10)
        );
        bind encoder assertions_encoder assertions_encoder_i(encoder_if.DUT);
    `elsif PISO
        piso_if piso_if (TxBitCLK);
        PISO piso(
            .BitCLK(TxBitCLK),
            .Reset(piso_if.Reset),
            .Serial(piso_if.Serial),
            .TxParallel_10(piso_if.TxParallel_10)
        );
        bind PISO assertions_piso assertions_piso_i(piso_if.DUT);
    `elsif SIPO
        sipo_if sipo_if (TxBitCLK);
        SIPO sipo(
            .BitCLK(TxBitCLK),
            .Reset(sipo_if.Reset),
            .Serial(sipo_if.Serial),
            .RxParallel_10(sipo_if.RxParallel_10)
        );
        bind SIPO assertions_sipo assertions_sipo_i(sipo_if.DUT);
    `elsif DECODER
        decoder_if decoder_if (TxBitCLK_10);
        decoder decoder(
            .BitCLK_10(TxBitCLK_10),
            .Reset(decoder_if.Reset),
            .RxParallel_10(decoder_if.RxParallel_10),
            .RxDataK(decoder_if.RxDataK),
            .RxParallel_8(decoder_if.RxParallel_8[7:0]),
            .Decode_Error(decoder_if.Decode_Error),
            .Disparity_Error(decoder_if.Disparity_Error)
        );
        bind decoder assertions_decoder assertions_decoder_i(decoder_if.DUT);
    `elsif CDR
        cdr_if cdr_if (BitCLK);
        
        bit [1:0] decision;
        phase_detector phase_detector(
            .Dn_1(cdr_if.Dn_1),
            .Dn(cdr_if.Dn),
            .Pn(cdr_if.Pn),
            .decision(decision)
        );
        loop_filter loop_filter(
            .input_signal(decision),
            .clk(BitCLK),
            .Reset(cdr_if.Reset),
            .gainsel(2'b0),
            .output_signal(cdr_if.phase_shift)
        );
        bind loop_filter assertions_cdr assertions_cdr_i(cdr_if.DUT);
    `elsif EQUALIZATION
        real channel_response;
        equalization_if equalization_if (TxBitCLK);
        channel channel (
            .clk(continous_clock),
            .channel_in(equalization_if.Serial_out),
            .channel_out(channel_response)
        );
        equalizer equalizer (
            .clk(continous_clock),
            .equalizer_in(channel_response),
            .equalizer_out(equalization_if.Serial_in)
        );
        bind equalizer assertions_equalization assertions_equalization_i(equalization_if.DUT);
    `elsif BUFFER
        buffer_if buffer_if (.recovered_clock(TxBitCLK_10), .local_clock(RxBitCLK_10));
        elastic_buffer elastic_buffer(
            .recovered_clock(TxBitCLK_10),
            .local_clock(RxBitCLK_10),
            .recovered_reset(buffer_if.recovered_reset),
            .local_reset(buffer_if.local_reset),
            .data_in(buffer_if.data_in),
            .data_out(buffer_if.data_out),
            .underflow(buffer_if.underflow),
            .overflow(buffer_if.overflow),
            .skip_added(buffer_if.skip_added),
            .skip_removed(buffer_if.skip_removed)
        );
        bind elastic_buffer assertions_buffer assertions_buffer_i(buffer_if.DUT);
    `endif

    initial begin
        `ifdef TOP
            uvm_config_db #(virtual top_if)::set(null, "*", "top_if", top_if);
        `elsif EQUALIZATION_TOP
            uvm_config_db #(virtual equalization_top_if)::set(null, "*", "equalization_top_if", equalization_top_if);
        `elsif CDR_TOP
            uvm_config_db #(virtual cdr_top_if)::set(null, "*", "cdr_top_if", cdr_top_if);
        `elsif SERDES_TOP
            uvm_config_db #(virtual serdes_top_if)::set(null, "*", "serdes_top_if", serdes_top_if);
        `elsif ENCODER
            uvm_config_db #(virtual encoder_if)::set(null, "*", "encoder_if", encoder_if);
        `elsif PISO
            uvm_config_db #(virtual piso_if)::set(null, "*", "piso_if", piso_if);
        `elsif SIPO
            uvm_config_db #(virtual sipo_if)::set(null, "*", "sipo_if", sipo_if);
        `elsif DECODER
            uvm_config_db #(virtual decoder_if)::set(null, "*", "decoder_if", decoder_if);
        `elsif CDR
            uvm_config_db #(virtual cdr_if)::set(null, "*", "cdr_if", cdr_if);
        `elsif EQUALIZATION
            uvm_config_db #(virtual equalization_if)::set(null, "*", "equalization_if", equalization_if);
        `elsif BUFFER
            uvm_config_db #(virtual buffer_if)::set(null, "*", "buffer_if", buffer_if);
        `endif
        run_test("test");
    end

endmodule