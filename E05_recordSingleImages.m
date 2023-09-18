
clear variables;

% check if installation is correct
if size(ls('cuvis.matlab'),1) == 2
    error('cuvis.matlab submodule not initialized')
end

% add matlab wrapepr
addpath('cuvis.matlab');
cuvis_init();

calibration = cuvis_calibration('C:\\Program Files\\Cuvis\\factory');

disp('load processing context');
processingContext = cuvis_proc_cont(calibration);

disp('load acquisition context');
acquisitionContext = cuvis_acq_cont(calibration);
up_path = '../cuvis_3.20_sample_data/sample_data/set_examples/userplugin/cai.xml';


viewer = cuvis_viewer('userplugin',fileread(up_path));

cube_exporter  = cuvis_exporter_cube('export_dir','export' ,'allow_overwrite',true);

disp('done loading.');

disp(acquisitionContext.get_state());
%% wait for device online
sec = 0;
while strcmp(acquisitionContext.get_state(),'hardware_state_offline')
    pause(1);
    sec = sec+1;
    disp('waiting for camera to become online...');
end

%% init

disp('initialize.');


cb=acquisitionContext.set_integration_time(100);
cb(0);
cb=acquisitionContext.set_operation_mode('Software');
cb(0);
processingContext.set_processing_mode('Cube_Raw');


%% capture


disp('start recording');


for k=1:10
    
    
    callback = acquisitionContext.capture();
    [isok, mesu] = callback(1000);
    
    if ~isok
        disp('mesu invalid ');
    else
        %image valid
        tic
        processingContext.apply(mesu);
        
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
%%
clear calibration;
clear ans;
clear callback;
clear processingContext;
clear acquisitionContext;
clear cube_exporter;
clear up_path;
clear cb;
clear isok;
clear k;
clear viewer;