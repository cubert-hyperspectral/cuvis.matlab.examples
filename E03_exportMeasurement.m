
clear variables;

addpath('../lib');
cuvis_init('../../sample_data/set1/settings');


mesu = cuvis_measurement('../../sample_data/set1/processed/vegetation_ref.cu3');

up_path = '../../sample_data/userplugin/cai.xml';


tiff_exporter_single  = cuvis_exporter_tiff('export_dir','export/single' ,'format','Single');
tiff_exporter_multi  = cuvis_exporter_tiff('export_dir','export' ,'format','MultiChannel');
envi_exporter  = cuvis_exporter_envi('export_dir','export');
cube_single_exporter  = cuvis_exporter_cube('export_dir','export' ,'allow_overwrite',true,'allow_session_file',false);
cube_session_exporter  = cuvis_exporter_cube('export_dir','export' ,'allow_overwrite',true);
view_exporter  = cuvis_exporter_view('export_dir','view' ,'userplugin',fileread(up_path));

tiff_exporter_single.apply(mesu);
tiff_exporter_multi.apply(mesu);
envi_exporter.apply(mesu);
cube_single_exporter.apply(mesu);
cube_session_exporter.apply(mesu);
view_exporter.apply(mesu);


clear mesu;
clear tiff_exporter_single;
clear tiff_exporter_multi;
clear envi_exporter;
clear cube_single_exporter;
clear cube_session_exporter;
clear view_exporter;

