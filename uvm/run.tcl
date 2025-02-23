
#Change this variable to one of the following values
#SERDES_TOP ENCODER PISO SIPO DECODER
set design_block SERDES_TOP

set design_block_if [string cat [string tolower $design_block] _if]
set path top
switch $design_block {
    SERDES_TOP {
        set path serdes_top
    }
    ENCODER {
        set path tx/encoder
    }
    PISO {
        set path tx/piso
    }
    SIPO {
        set path rx/sipo
    }
    DECODER {
        set path rx/decoder
    }
    CDR {
        set path rx/cdr
    }
}
vlog -f $path/runfiles.f +define+$design_block +cover

vsim -voptargs=+acc -voptargs="+cover=bcefst" work.top -cover -classdebug +UVM_TESTNAME=test +UVM_VERBOSITY=UVM_HIGH -sv_seed 1

add wave /top/$design_block_if/*
switch $design_block {
    ENCODER {
        add wave /top/encoder/assertions_encoder_i/five_consecutive_bits_assert
        add wave /top/encoder/assertions_encoder_i/five_consecutive_bits_cover
        add wave /top/encoder/assertions_encoder_i/disparity_assert
        add wave /top/encoder/assertions_encoder_i/disparity_cover
    }
    SIPO {
        add wave /top/sipo/assertions_sipo_i/comma_check_assert
        add wave /top/sipo/assertions_sipo_i/comma_check_cover
    }
    DECODER {
        add wave /top/decoder/assertions_decoder_i/disparity_error_assert 
        add wave /top/decoder/assertions_decoder_i/disparity_error_cover
    }
    CDR {
        add wave /top/loop_filter/assertions_cdr_i/RESET_ASSERT
        # add wave /top/loop_filter/assertions_cdr_i/NO_TRANSITION_ASSERT
        # add wave /top/loop_filter/assertions_cdr_i/EARLY_ASSERT
        # add wave /top/loop_filter/assertions_cdr_i/LATE_ASSERT
        # add wave /top/loop_filter/assertions_cdr_i/COVER_RESET
        # add wave /top/loop_filter/assertions_cdr_i/COVER_NO_TRANSITION
        # add wave /top/loop_filter/assertions_cdr_i/COVER_EARLY
        # add wave /top/loop_filter/assertions_cdr_i/COVER_LATE
    }
}

# un-comment the following line to generate the coverage file
# coverage save coverage.ucdb -onexit 

run -all

# run the vcover command on terminal to generate the report from the coverage file
# vcover report coverage.ucdb -details -annotate -html -output coverage_reports/$path

# un-comment the following line to generate fuctional coverage report
# coverage report -output functional_coverage_report.txt -srcfile=* -detail -all -dump -annotate -directive -cvg

# you can add -option to functional coverage
# you can add -classdebug in vsim command to access the classes in waveform
# you can add -uvmcontrol=all  in vsim command in case uvm
# in windows to create sourcefile.txt use dir /b > sourcefile.txt
