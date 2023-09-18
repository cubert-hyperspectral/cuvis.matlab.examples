% initialize
clear variables;

example_measurement_path = '../cuvis_3.20_sample_data/sample_data/set_examples/set0_lab/x20_calib_color.cu3s';

% check if installation is correct
if size(ls('cuvis.matlab'),1) == 2
    error('cuvis.matlab submodule not initialized')
end

% add matlab wrapepr
addpath('cuvis.matlab');
cuvis_init();

sess = cuvis_session_file(example_measurement_path);
mesu = sess.get_measurement(1, 'session_item_type_frames'); %get first frame

up_path = '../cuvis_3.20_sample_data/sample_data/set_examples/userplugin/cai.xml';


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
clear sess;
clear up_path;
clear tiff_exporter_single;
clear tiff_exporter_multi;
clear envi_exporter;
clear cube_single_exporter;
clear cube_session_exporter;
clear view_exporter;

