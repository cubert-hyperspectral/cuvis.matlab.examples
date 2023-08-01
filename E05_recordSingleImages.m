
clear variables;

addpath('../lib');
cuvis_init('C:\\Program Files\\Cuvis\\user\\settings');


calib = cuvis_calibration('C:\\Program Files\\Cuvis\\factory');

disp('load processing context');
proc = cuvis_proc_cont(calib);

disp('load acquisition context');
acq = cuvis_acq_cont(calib);
up_path = '../../sample_data/userplugin/cai.xml';

viewer = cuvis_viewer('userplugin',fileread(up_path));

cube_exporter  = cuvis_exporter_cube('export_dir','export' ,'allow_overwrite',true);

disp('done loading.');

%% wait for device online

while strcmp(acq.get_state(),'hardware_state_offline')
    pause(1);
    disp('waiting for camera to become online...');
end

%% init

disp('initialize.');


cb=acq.set_integration_time(100);
cb(0);
cb=acq.set_operation_mode('Software');
cb(0);
proc.set_processing_mode('Cube_Raw');


%% capture


disp('start recording');


for k=1:10
    
    
    callback = acq.capture();
    [isok, mesu] = callback(1000);
    
    if ~isok
        disp('mesu invalid ');
    else
        %image valid
        tic
        proc.apply(mesu);
        
        %cube_exporter.apply(mesu);
        view = viewer.apply(mesu);
        
        image(view.view.value);
        axis image;
        drawnow;
        
        clear view;
        clear mesu;
        
        toc
    end
    
    
    pause(1);
end
