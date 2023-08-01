
clear variables;

addpath('../lib');
cuvis_init('../../sample_data/set1/settings');

mesu = cuvis_measurement('../../sample_data/set1/vegetation_000/vegetation_000_000_snapshot.cu3');


if (isfield(mesu.data,'cube'))
    
    figure('NumberTitle', 'off', 'Name','cube');
    subplot(1,2,1);
    rgb(:,:,1) = mesu.data.cube.value(:,:,10);
    
    rgb(:,:,2) = mesu.data.cube.value(:,:,30);
    
    rgb(:,:,3) = mesu.data.cube.value(:,:,50);
    
    image(rgb*64);
    axis image;
    
end

calib = cuvis_calibration('../../sample_data/set1/factory');
proc = cuvis_proc_cont(calib);


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
