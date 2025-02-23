import uvm_pkg::*;
`include "uvm_macros.svh"
import test::*;

module top();

    bit BitCLK_10, BitCLK;

    initial begin
        forever begin
            #10 BitCLK_10 = ~BitCLK_10;
        end
    end
    initial begin
        forever begin
            #1 BitCLK = ~BitCLK;
        end
    end

    `ifdef SERDES_TOP
        serdes_top_if serdes_top_if (BitCLK, BitCLK_10);
        serdes_top_module serdes_top_module (
            .BitCLK(BitCLK),
            .BitCLK_10(BitCLK_10),
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
        encoder_if encoder_if (BitCLK_10);
        encoder encoder(
            .BitCLK_10(BitCLK_10),
            .Reset(encoder_if.Reset),
            .TxParallel_8(encoder_if.TxParallel_8[7:0]),
            .TxDataK(encoder_if.TxDataK),
            .TxParallel_10(encoder_if.TxParallel_10)
        );
        bind encoder assertions_encoder assertions_encoder_i(encoder_if.DUT);
    `elsif PISO
        piso_if piso_if (BitCLK);
        PISO piso(
            .BitCLK(BitCLK),
            .Reset(piso_if.Reset),
            .Serial(piso_if.Serial),
            .TxParallel_10(piso_if.TxParallel_10)
        );
        bind PISO assertions_piso assertions_piso_i(piso_if.DUT);
    `elsif SIPO
        sipo_if sipo_if (BitCLK);
        SIPO sipo(
            .BitCLK(BitCLK),
            .Reset(sipo_if.Reset),
            .Serial(sipo_if.Serial),
            .RxParallel_10(sipo_if.RxParallel_10)
        );
        bind SIPO assertions_sipo assertions_sipo_i(sipo_if.DUT);
    `elsif DECODER
        decoder_if decoder_if (BitCLK_10);
        decoder decoder(
            .BitCLK_10(BitCLK_10),
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
    `endif

    initial begin
        `ifdef SERDES_TOP
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
        `endif
        run_test("test");
    end

endmodule