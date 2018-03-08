% Plotting Script to visualise Parameters
% Author: Florentina M�nzner (FM)
% Begin: 22.01.2018
%% run this script
clear all
close all

%define your directories
workdir = '/home/jnitzbon/remote/linux3/home/jnitzbon/CryoGrid/github/CryoGrid3_infiltration_xice/';
rundir = [ workdir 'runs/' ];

runSet = 'TESTRUN_197906-201406_stratSam_rf1_sf1_maxSnow1.0_snowDens=200.0_maxWater0.5_extFlux0.0000_fc0.50*';

runListing = dir( [ rundir runSet ] );

for i=1:length(runListing)
    
    disp( ['Processing run ' runListing(i).name ' ...'] );
    
    outputListing = dir( [ rundir runListing(i).name '/*output1979*' ] );
    %stateListing = dir( [ rundir runListing(i).name '/*finalState*' ] );
    settingsFile = dir( [ rundir runListing(i).name '/*settings*' ] );
    settings = load( [ rundir runListing(i).name '/' settingsFile.name ] );
    PARAMS = settings.PARA;
    GRID = settings.GRID;
    FORCING = settings.FORCING;
    
    % loop over all years
    for j=1:length(outputListing)
        
        disp( ['... at file ' outputListing(j).name ] );
    
        output = load( [ rundir runListing(i).name '/' outputListing(j).name ] );
        OUTPUT = output.OUT;

        % call plotting functions
        fig_Ts_vs_time = plot_Ts_vs_time( OUTPUT, depths );
            
        
        
    end
    
end
    
% %% add path for analysis files
% addpath( [ workdir 'validation/' ] );
% % insert depth here at which temp. and moisture is evaluated
% depth = [0 0.5 1 2]; 
% 
% 
% 
% %% ausf�hren
% 
% 
% 
% run ANALYSIS_calc_param.m               % rechnet die Parameter aus
% run ANALYSIS_plot_param.m               % plotter die Parameter
% %run ANALYSIS_T_d_diagrams.m            % rechnet und plottet T-D Diagramme