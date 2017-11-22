write -mapped > $design_root/adc8_v4-gate.v
write_sdc > $design_root/adc8_v4-gate.sdc
write_sdf > $design_root/adc8_v4-gate.sdf
report area > $design_root/area_original_singleShot.rpt
set_attribute lp_default_toggle_rate adc8_v4 0.1 #GHz
report power>$design_root/power.rpt