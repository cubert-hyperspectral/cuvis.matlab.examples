clear variables;

autoExp = false;


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

while strcmp(acquisitionContext.get_state(),'hardware_state_offline')
    pause(1);
    disp('waiting for camera to become online...');
end

%% init

disp('initialize.');

acquisitionContext.set_session_info('example_vid',10,10);

cb=acquisitionContext.set_operation_mode('Internal');
cb(0);
cb=acquisitionContext.set_integration_time(100); %in ms
cb(0);
cb=acquisitionContext.set_fps(0.5);
cb(0);
processingContext.set_processing_mode('Cube_Raw');
cb=acquisitionContext.set_continuous(true);
cb(0);
cb=acquisitionContext.set_auto_exp(autoExp);
cb(0);

worker = cuvis_worker();
worker.set_acq_cont(acquisitionContext);
worker.set_proc_cont( processingContext);
worker.set_exporter(cube_exporter);

%%
disp('start recording');



global KEY_IS_PRESSED
KEY_IS_PRESSED = 0;

fig=figure;
gcf
set(gcf, 'KeyPressFcn', @myKeyPressFcn)

tic;

while  ~KEY_IS_PRESSED
    
    
    while ~worker.has_next_measurement() &&  ~KEY_IS_PRESSED
        pause(0.01)
    end
    
    
    while worker.has_next_measurement() &&  ~KEY_IS_PRESSED
        %drop images in queue
        [isok, mesu, view] = worker.get_next_mesurement(1000);
    end
    
    
    if ~KEY_IS_PRESSED
        
        if ~isok
            disp('mesu invalid ');
            
        else
            %sensor raw processing => only preview
            
            if ~isempty(mesu)
                
                
                
                subplot(1,2,1);
                
                g = squeeze(mesu.data.preview);
                rgb(:,:,1) = g;
                rgb(:,:,2) = g;
                rgb(:,:,3) = g;
                
                %show an overlay of all potentially bad pixels
                if (isfield(mesu.data,'cube_info_layer'))
                    
                    for x = 1:size(mesu.data.cube_info_layer,1)
                        for y = 1:size(mesu.data.cube_info_layer,2)
                            if mod(x+y,2) == 0
                                if (mesu.data.cube_info_layer(x,y) > 0)
                                    rgb(x,y,:)=0+mod(round(toc*3.314),2)*128;
                                end
                            end
                        end
                    end
                    
                end
                
                image(rgb);
                colormap(gray(255));
                axis image;
                title(num2str(mesu.sequence_no));
                
                subplot(1,2,2);
                
                if (isfield(mesu.data,'cube'))
                
                    g = squeeze(mesu.data.cube.value(150,200,:));
                    
                    
                    
                    plot(mesu.data.cube.wl, g);

                    xlabel('wavelength /nm');
                    grid on;
                end
                
                
                drawnow;
                
                
                %cube_exporter.apply(mesu);
                clear mesu;
            end
            
        end
    end
end

cb=acquisitionContext.set_continuous(false);
cb(0);
%% cleanup
close(fig);
clear all;

function myKeyPressFcn(hObject, event)
global KEY_IS_PRESSED
KEY_IS_PRESSED  = 1;
disp('key is pressed - stopping.')
end
