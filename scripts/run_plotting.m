% Plotting Script to visualise Parameters
% Author: Florentina M�nzner (FM)
% Begin: 22.01.2018
%% run this script
clear all
close all

saveFigs = 1;
if saveFigs
    set(0,'DefaultFigureVisible','off')
end
%define your directories
workdir = '/home/nitzbon/CryoGrid/CryoGrid3/';
rundir = [ workdir 'runs/' ];

runSet = 'TESTRUN_197906-201406_stratSam_rf1_sf1_maxSnow1.0_snowDens=200.0_maxWater0.5*';

runListing = dir( [ rundir runSet ] );

requestedTdepths = [ 0.05, 0.15, 0.4, 1.0, 5., 10. ];
requestedVWCdepths = [0.05, 0.15, 0.4, 0.6, 0.8, 1.0 ];

for i=1:length(runListing)
    
    disp( ['Processing run ' runListing(i).name ' ...'] );
    
    outputListing = dir( [ rundir runListing(i).name '/*output*' ] );
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
        
        fig_altitudes_vs_time = plot_altitudes_vs_time( OUTPUT, PARAMS );
        if saveFigs
            saveas( fig_altitudes_vs_time, [ rundir runListing(i).name '/' runListing(i).name '_altitudes_vs_time_' datestr(OUTPUT.timestamp(1), 'yyyy') '.fig' ] );
            saveas( fig_altitudes_vs_time, [ rundir runListing(i).name '/' runListing(i).name '_altitudes_vs_time_' datestr(OUTPUT.timestamp(1), 'yyyy') '.png' ] );
        end
        

        fig_VLWCs_vs_time = plot_VLWCs_vs_time( OUTPUT, GRID, PARAMS, requestedVWCdepths );
        if saveFigs
            saveas( fig_VLWCs_vs_time, [ rundir runListing(i).name '/' runListing(i).name '_VLWCs_vs_time_' datestr(OUTPUT.timestamp(1), 'yyyy') '.fig' ] );
            saveas( fig_VLWCs_vs_time, [ rundir runListing(i).name '/' runListing(i).name '_VLWCs_vs_time_' datestr(OUTPUT.timestamp(1), 'yyyy') '.png' ] );
        end
        
        fig_Ts_vs_time = plot_Ts_vs_time( OUTPUT, GRID, PARAMS, requestedTdepths );
        if saveFigs
            saveas( fig_Ts_vs_time, [ rundir runListing(i).name '/' runListing(i).name '_Ts_vs_time_' datestr(OUTPUT.timestamp(1), 'yyyy') '.fig' ] );
            saveas( fig_Ts_vs_time, [ rundir runListing(i).name '/' runListing(i).name '_Ts_vs_time_' datestr(OUTPUT.timestamp(1), 'yyyy') '.png' ] );
        end
    end 
end