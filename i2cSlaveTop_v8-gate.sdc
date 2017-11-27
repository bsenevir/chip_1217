# ####################################################################

#  Created by Encounter(R) RTL Compiler RC14.23 - v14.20-s027_1 on Fri Nov 24 18:51:32 -0500 2017

# ####################################################################

set sdc_version 1.7

set_units -capacitance 1000.0fF
set_units -time 1000.0ps

# Set the current design
current_design i2cSlaveTop_v8

create_clock -name "clkin" -add -period 10.0 -waveform {8.0 8.0} [get_ports clk]
set_clock_transition -min 0.1 [get_clocks clkin]
set_clock_transition -max 0.2 [get_clocks clkin]
set_clock_gating_check -setup 0.0 
set_input_delay -clock [get_clocks clkin] -add_delay 1.0 [get_ports sda]
set_input_delay -clock [get_clocks clkin] -add_delay 1.0 [get_ports scl]
set_input_delay -clock [get_clocks clkin] -add_delay 1.0 [get_ports rst]
set_input_delay -clock [get_clocks clkin] -add_delay 1.0 [get_ports {clk_px[0]}]
set_input_delay -clock [get_clocks clkin] -add_delay 1.0 [get_ports {clk_px[1]}]
set_input_delay -clock [get_clocks clkin] -add_delay 1.0 [get_ports {clk_px[2]}]
set_input_delay -clock [get_clocks clkin] -add_delay 1.0 [get_ports {clk_px[3]}]
set_input_delay -clock [get_clocks clkin] -add_delay 1.0 [get_ports {clk_px[4]}]
set_input_delay -clock [get_clocks clkin] -add_delay 1.0 [get_ports {clk_px[5]}]
set_input_delay -clock [get_clocks clkin] -add_delay 1.0 [get_ports {clk_px[6]}]
set_input_delay -clock [get_clocks clkin] -add_delay 1.0 [get_ports {clk_px[7]}]
set_input_delay -clock [get_clocks clkin] -add_delay 1.0 [get_ports {clk_px[8]}]
set_input_delay -clock [get_clocks clkin] -add_delay 1.0 [get_ports {clk_px[9]}]
set_input_delay -clock [get_clocks clkin] -add_delay 1.0 [get_ports {clk_px[10]}]
set_input_delay -clock [get_clocks clkin] -add_delay 1.0 [get_ports {clk_px[11]}]
set_input_delay -clock [get_clocks clkin] -add_delay 1.0 [get_ports {clk_px[12]}]
set_input_delay -clock [get_clocks clkin] -add_delay 1.0 [get_ports {clk_px[13]}]
set_input_delay -clock [get_clocks clkin] -add_delay 1.0 [get_ports {clk_px[14]}]
set_input_delay -clock [get_clocks clkin] -add_delay 1.0 [get_ports {clk_px[15]}]
set_input_delay -clock [get_clocks clkin] -add_delay 1.0 [get_ports {clk_px[16]}]
set_input_delay -clock [get_clocks clkin] -add_delay 1.0 [get_ports {clk_px[17]}]
set_input_delay -clock [get_clocks clkin] -add_delay 1.0 [get_ports {clk_px[18]}]
set_input_delay -clock [get_clocks clkin] -add_delay 1.0 [get_ports {clk_px[19]}]
set_input_delay -clock [get_clocks clkin] -add_delay 1.0 [get_ports clk]
set_output_delay -clock [get_clocks clkin] -add_delay 1.0 [get_ports sda]
set_output_delay -clock [get_clocks clkin] -add_delay 1.0 [get_ports drdy]
set_output_delay -clock [get_clocks clkin] -add_delay 1.0 [get_ports {stop_osc[0]}]
set_output_delay -clock [get_clocks clkin] -add_delay 1.0 [get_ports {stop_osc[1]}]
set_output_delay -clock [get_clocks clkin] -add_delay 1.0 [get_ports {stop_osc[2]}]
set_output_delay -clock [get_clocks clkin] -add_delay 1.0 [get_ports {stop_osc[3]}]
set_output_delay -clock [get_clocks clkin] -add_delay 1.0 [get_ports {stop_osc[4]}]
set_output_delay -clock [get_clocks clkin] -add_delay 1.0 [get_ports {px_addr[0]}]
set_output_delay -clock [get_clocks clkin] -add_delay 1.0 [get_ports {px_addr[1]}]
set_wire_load_mode "enclosed"
set_dont_use [get_lib_cells osu05_stdcells/PADFC]
set_dont_use [get_lib_cells osu05_stdcells/PADNC]
set_dont_use [get_lib_cells osu05_stdcells/PADVDD]
set_dont_use [get_lib_cells osu05_stdcells/PADGND]
