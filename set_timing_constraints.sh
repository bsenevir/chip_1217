define_clock -period 10000 -fall 80 -rise 80 -name clkin /designs/chip_v2/ports_in/clk
set_attribute slew {100 100 200 200} [find -clock clkin]
external_delay -input 1000 -clock [find -clock clkin] -edge_rise [find /des* -port ports_in/*]
external_delay -output 1000 -clock [find -clock clkin] -edge_rise [find /des* -port ports_out/*]
synthesize -to_mapped -effort high