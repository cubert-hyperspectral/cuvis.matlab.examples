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


if (isfield(mesu.data,'cube'))
    
    figure('NumberTitle', 'off', 'Name','cube');
    subplot(1,2,1);
    rgb(:,:,1) = mesu.data.cube.value(:,:,10);
    
    rgb(:,:,2) = mesu.data.cube.value(:,:,30);
    
    rgb(:,:,3) = mesu.data.cube.value(:,:,50);
    
    image(rgb*64);
    axis image;
    
end
proc = cuvis_proc_cont(sess);


%set distance to 1m
proc.calc_distance(1000);
proc.set_processing_mode('Cube_Raw');
proc.apply(mesu);


if (isfield(mesu.data,'cube'))
    subplot(1,2,2);
    rgb(:,:,1) = mesu.data.cube.value(:,:,10);
    
    rgb(:,:,2) = mesu.data.cube.value(:,:,30);
    
    rgb(:,:,3) = mesu.data.cube.value(:,:,50);
    
    image(rgb*64);
    axis image;
    
end

clear mesu;
clear proc;
clear rgb;
clear sess;
