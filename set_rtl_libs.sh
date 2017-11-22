set design_root ./
set library_root ../OSU/cadence/lib/ami05/lib
echo "1111"
set_attribute lib_search_path $library_root/
echo "2222"
set_attribute hdl_search_path $design_root/
echo "3333"
set_attribute hdl_language v2001
echo "4444"
set_attribute library {osu05_stdcells.lib}