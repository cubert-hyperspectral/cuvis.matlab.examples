
clear variables;

addpath('../lib');
cuvis_init('C:\\Program Files\\cuvis\\user\\settings');

calib = cuvis_calibration('C:\\Program Files\\cuvis\\factory');

disp('load processing context');
proc = cuvis_proc_cont(calib);

disp('load acquisition context');
acq = cuvis_acq_cont(calib);

cube_exporter  = cuvis_exporter_cube('export_dir','export' ,'allow_overwrite',true,'allow_session_file',true);

disp('done loading.');

%% wait for device online

while strcmp(acq.get_state(),'hardware_state_offline')
    pause(1);
end

%% init

disp('initialize.');

acq.set_session_info('example_vid',10,10);

cb=acq.set_operation_mode('Internal');
cb(0);
cb=acq.set_integration_time(100);
cb(0);
cb=acq.set_fps(5);
cb(0);
proc.set_processing_mode('Cube_Raw');

worker = cuvis_worker();
worker.set_acq_cont(acq);
worker.set_proc_cont(proc);
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
        [isok, mesu, view] = worker.get_next_mesurement();
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
                
                clear mesu;
                %cube_exporter.apply(mesu);
            end
            
        end
    end
end

%% cleanup
close(fig);

clear all;

function myKeyPressFcn(hObject, event)
global KEY_IS_PRESSED
KEY_IS_PRESSED  = 1;
disp('key is pressed - stopping.')
end