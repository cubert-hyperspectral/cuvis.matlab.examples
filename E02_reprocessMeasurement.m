
% initialize
clear variables;
example_measurement_path = '../cuvis_3.20_sample_data/sample_data/set_examples/set0_lab/x20_calib_color.cu3s';
example_measurement_dark_path = '../cuvis_3.20_sample_data/sample_data/set_examples/set0_lab/x20_calib_color_dark.cu3s';
example_measurement_white_path = '../cuvis_3.20_sample_data/sample_data/set_examples/set0_lab/x20_calib_color_white.cu3s';
example_measurement_distance_path = '../cuvis_3.20_sample_data/sample_data/set_examples/set0_lab/x20_calib_color_distance.cu3s';

% check if installation is correct
if size(ls('cuvis.matlab'),1) == 2
    error('cuvis.matlab submodule not initialized')
end

% add matlab wrapepr
addpath('cuvis.matlab');
cuvis_init();


mesus = cuvis_session_file(example_measurement_path);
mesu = mesus.get_measurement(1, 'session_item_type_frames')
dark = cuvis_session_file(example_measurement_dark_path).get_measurement(1, 'session_item_type_frames');
white = cuvis_session_file(example_measurement_white_path).get_measurement(1, 'session_item_type_frames');
distance = cuvis_session_file(example_measurement_distance_path).get_measurement(1, 'session_item_type_frames');

%load calibration from session file
proc = cuvis_proc_cont(mesus);

proc.set_reference(dark,'dark');
proc.set_reference(white,'white');
proc.set_reference(distance,'distance');

if proc.is_capable(mesu,'Cube_Raw')
    figure;
    proc.set_processing_mode('Cube_Raw');
    proc.apply(mesu);
    plot(mesu.data.cube.wl, squeeze(mesu.data.cube.value(150,200,:)),'DisplayName','Raw');
    xlabel('Wavelength [nm]');
    ylabel('Counts [a.u.]');
    grid on;
    
    
    title(mesu.processing_mode,'Interpreter','None');
    
    
else
    disp('Cube_Raw not available');
end


if proc.is_capable(mesu,'Cube_DarkSubtract')
    figure;
    proc.set_processing_mode('Cube_DarkSubtract');
    proc.apply(mesu);
    plot(mesu.data.cube.wl, squeeze(mesu.data.cube.value(150,200,:)),'DisplayName','DS');
    xlabel('Wavelength [nm]');
    ylabel('Counts [a.u.]');
    grid on;
    
    title(mesu.processing_mode,'Interpreter','None');
    
else
    disp('Cube_DarkSubtract not available');
end

if proc.is_capable(mesu,'Cube_Reflectance')
    figure;
    proc.set_processing_mode('Cube_Reflectance');
    proc.apply(mesu);
    plot(mesu.data.cube.wl, single(squeeze(mesu.data.cube.value(150,200,:)))./100,'DisplayName','Ref');
    xlabel('Wavelength [nm]');
    ylabel('Reflectance [%]');
    grid on;
    
    
    title(mesu.processing_mode,'Interpreter','None');
else
    disp('Cube_Reflectance not available');
end

if proc.is_capable(mesu,'Cube_SpectralRadiance')
    figure;
    proc.set_processing_mode('Cube_SpectralRadiance');
    proc.apply(mesu);
    plot(mesu.data.cube.wl, squeeze(mesu.data.cube.value(150,200,:)),'DisplayName','SpRad');
    xlabel('Wavelength [nm]');
    ylabel('Radiance [W / (sr m^2 µm)]');
    grid on;
    title(mesu.processing_mode,'Interpreter','None');
    
else
    disp('Cube_SpectralRadiance not available');
end



clear mesu;
clear dark;
clear white;
clear distance;


clear proc;
clear calib;

