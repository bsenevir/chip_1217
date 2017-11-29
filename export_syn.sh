write -mapped > $design_root/chip_v2-gate.v
write_sdc > $design_root/chip_v2-gate.sdc
write_sdf > $design_root/chip_v2-gate.sdf
report area > $design_root/area_original_singleShot.rpt