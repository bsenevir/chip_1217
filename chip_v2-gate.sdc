# ####################################################################

#  Created by Encounter(R) RTL Compiler RC14.23 - v14.20-s027_1 on Sat Dec 02 12:09:28 -0500 2017

# ####################################################################

set sdc_version 1.7

set_units -capacitance 1000.0fF
set_units -time 1000.0ps

# Set the current design
current_design chip_v2

create_clock -name "clkin" -add -period 10.0 -waveform {8.0 8.0} [get_ports clk]
set_clock_transition -min 0.1 [get_clocks clkin]
set_clock_transition -max 0.2 [get_clocks clkin]
set_clock_gating_check -setup 0.0 
set_input_delay -clock [get_clocks clkin] -add_delay 1.0 [get_ports sda]
set_input_delay -clock [get_clocks clkin] -add_delay 1.0 [get_ports testSig]
set_input_delay -clock [get_clocks clkin] -add_delay 1.0 [get_ports scl]
set_input_delay -clock [get_clocks clkin] -add_delay 1.0 [get_ports rst]
set_input_delay -clock [get_clocks clkin] -add_delay 1.0 [get_ports clk]
set_output_delay -clock [get_clocks clkin] -add_delay 1.0 [get_ports sda]
set_output_delay -clock [get_clocks clkin] -add_delay 1.0 [get_ports drdy]
set_wire_load_mode "enclosed"
set_dont_use [get_lib_cells osu05_stdcells/PADFC]
set_dont_use [get_lib_cells osu05_stdcells/PADNC]
set_dont_use [get_lib_cells osu05_stdcells/PADVDD]
set_dont_use [get_lib_cells osu05_stdcells/PADGND]
