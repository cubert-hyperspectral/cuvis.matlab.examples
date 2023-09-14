
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
    subplot(2,1,1);
    imagesc(squeeze(mesu.data.cube.value(:,:,13)));
    axis image;
    subplot(2,1,2);
    plot(mesu.data.cube.wl, squeeze(mesu.data.cube.value(150,200,:)));
    xlabel('wavelength /nm');
    grid on;
    
    
end

if (isfield(mesu.data,'GPS_data'))
    disp(mesu.data.GPS_data)
end

