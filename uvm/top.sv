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

    `ifdef TOP
        top_if top_if (BitCLK, BitCLK_10);
        top_module top_module (
            .BitCLK(BitCLK),
            .BitCLK_10(BitCLK_10),
            .Reset(top_if.Reset),
            .TxDataK(top_if.TxDataK),
            .TxParallel_8(top_if.TxParallel_8[7:0]),
            .RxDataK(top_if.RxDataK),
            .RxParallel_8(top_if.RxParallel_8[7:0])
        );
        bind top_module assertions_top assertions_top_i(top_if.DUT);
    `elsif ENCODER
        encoder_if encoder_if (BitCLK_10);
        encoder encoder(
            .BitCLK_10(BitCLK_10),
            .Reset(Reset),
            .TxParallel_8(encoder_if.TxParallel_8[7:0]),
            .TxDataK(encoder_if.TxDataK),
            .TxParallel_10(encoder_if.TxParallel_10)
        );
        bind encoder assertions_encoder assertions_encoder_i(encoder_if.DUT);
    `elsif PISO
        piso_if piso_if (BitCLK);
        PISO piso(
            .BitCLK(BitCLK),
            .Reset(Reset),
            .Serial(piso_if.Serial),
            .TxParallel_10(piso_if.TxParallel_10)
        );
        bind PISO assertions_piso assertions_piso_i(piso_if.DUT);
    `elsif SIPO
        sipo_if sipo_if (BitCLK);
        SIPO sipo(
            .BitCLK(BitCLK),
            .Reset(Reset),
            .Serial(sipo_if.Serial),
            .RxParallel_10(sipo_if.RxParallel_10),
            .Comma(sipo_if.Comma)
        );
        bind SIPO assertions_sipo assertions_sipo_i(sipo_if.DUT);
    `elsif DECODER
        decoder_if decoder_if (BitCLK_10);
        decoder decoder(
            .BitCLK_10(BitCLK_10),
            .Reset(Reset),
            .RxParallel_10(decoder_if.RxParallel_10),
            .RxDataK(decoder_if.RxDataK),
            .RxParallel_8(decoder_if.RxParallel_8[7:0])
        );
        bind decoder assertions_decoder assertions_decoder_i(decoder_if.DUT);
    `endif

    initial begin
        `ifdef TOP
            uvm_config_db #(virtual top_if)::set(null, "*", "top_if", top_if);
        `elsif ENCODER
            uvm_config_db #(virtual encoder_if)::set(null, "*", "encoder_if", encoder_if);
        `elsif PISO
            uvm_config_db #(virtual piso_if)::set(null, "*", "piso_if", piso_if);
        `elsif SIPO
            uvm_config_db #(virtual sipo_if)::set(null, "*", "sipo_if", sipo_if);
        `elsif DECODER
            uvm_config_db #(virtual decoder_if)::set(null, "*", "decoder_if", decoder_if);
        `endif
        run_test("test");
    end

endmodule