% Plotting Script to visualise Parameters
% Author: Florentina M�nzner (FM)
% Begin: 22.01.2018
%% run this script
clear all
close all

saveFigs = 0;
if saveFigs
    set(0,'DefaultFigureVisible','off')
end
showFigs = 1;
if showFigs
    set(0,'DefaultFigureVisible','on')
end
%define your directories
workdir = '/home/jnitzbon/remote/jnitzbon/CryoGrid/github/CryoGrid3_infiltration_xice/';
rundir = [ workdir 'runs/' ];

runSet = 'VALIDATION_200710-200910_stratSamWET_rf1_sf1_maxSnow1.0_snowDens=200.0_maxWater0.5_extFlux0.0010_fc0.60*';

runListing = dir( [ rundir runSet ] );

requestedTdepths = [ 0.05, 0.15, 0.4, 0.8 ];
requestedVWCdepths = [0.05, 0.15, 0.4, 0.8 ];

cm=load( [ workdir 'cm_blueautumn.mat' ] );

%%
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
        
        year=str2double(datestr(OUTPUT.timestamp(1), 'yyyy'));
        
%         fig_Tfield_vs_time = plot_Tfield_vs_time( OUTPUT, PARAMS, GRID, cm);
%         if saveFigs
%             saveas( fig_Tfield_vs_time, [ rundir runListing(i).name '/' runListing(i).name '_Tfield_vs_time_' datestr(OUTPUT.timestamp(1), 'yyyy') '.fig' ] );
%             saveas( fig_Tfield_vs_time, [ rundir runListing(i).name '/' runListing(i).name '_Tfield_vs_time_' datestr(OUTPUT.timestamp(1), 'yyyy') '.png' ] );
%         end        
%         fig = plot_VLWCfield_vs_time(OUTPUT, PARAMS, GRID);
%         if saveFigs
%             saveas( fig_Tfield_vs_time, [ rundir runListing(i).name '/' runListing(i).name '_VLWCfield_vs_time_' datestr(OUTPUT.timestamp(1), 'yyyy') '.fig' ] );
%             saveas( fig_Tfield_vs_time, [ rundir runListing(i).name '/' runListing(i).name '_VLWCfield_vs_time_' datestr(OUTPUT.timestamp(1), 'yyyy') '.png' ] );
%         end
        
        startDate = datenum( year, 6, 1 );
        endDate = datenum( year, 9, 1 );
        fig_WBsummer = plot_WBseasonal( OUTPUT, startDate, endDate );
        if saveFigs
            saveas( fig_WBsummer, [ rundir runListing(i).name '/' runListing(i).name '_WBsummer_' datestr(OUTPUT.timestamp(1), 'yyyy') '.fig' ] );
            saveas( fig_WBsummer, [ rundir runListing(i).name '/' runListing(i).name '_WBsummer_' datestr(OUTPUT.timestamp(1), 'yyyy') '.png' ] );
        end        
        fig_EBsummer = plot_EBseasonal( OUTPUT, PARAMS, startDate, endDate );
        if saveFigs
            saveas( fig_EBsummer, [ rundir runListing(i).name '/' runListing(i).name '_EBsummer_' datestr(OUTPUT.timestamp(1), 'yyyy') '.fig' ] );
            saveas( fig_EBsummer, [ rundir runListing(i).name '/' runListing(i).name '_EBsummer_' datestr(OUTPUT.timestamp(1), 'yyyy') '.png' ] );
        end
%         startDate = datenum( year, 10, 1 );
%         endDate = datenum( year+1, 1, 1 );
%         
%                 fig_WBwinter = plot_WBseasonal( OUTPUT, startDate, endDate );
%         if saveFigs
%             saveas( fig_WBwinter, [ rundir runListing(i).name '/' runListing(i).name '_WBwinter_' datestr(OUTPUT.timestamp(1), 'yyyy') '.fig' ] );
%             saveas( fig_WBwinter, [ rundir runListing(i).name '/' runListing(i).name '_WBwinter_' datestr(OUTPUT.timestamp(1), 'yyyy') '.png' ] );
%         end        
%         fig_EBwinter = plot_EBseasonal( OUTPUT, PARAMS, startDate, endDate );
%         if saveFigs
%             saveas( fig_EBwinter, [ rundir runListing(i).name '/' runListing(i).name '_EBwinter_' datestr(OUTPUT.timestamp(1), 'yyyy') '.fig' ] );
%             saveas( fig_EBwinter, [ rundir runListing(i).name '/' runListing(i).name '_EBwinter_' datestr(OUTPUT.timestamp(1), 'yyyy') '.png' ] );
%         end 
%         fig_altitudes_vs_time = plot_altitudes_vs_time( OUTPUT, PARAMS );
%         if saveFigs
%             saveas( fig_altitudes_vs_time, [ rundir runListing(i).name '/' runListing(i).name '_altitudes_vs_time_' datestr(OUTPUT.timestamp(1), 'yyyy') '.fig' ] );
%             saveas( fig_altitudes_vs_time, [ rundir runListing(i).name '/' runListing(i).name '_altitudes_vs_time_' datestr(OUTPUT.timestamp(1), 'yyyy') '.png' ] );
%         end
%         
% 
%         fig_VLWCs_vs_time = plot_VLWCs_vs_time( OUTPUT, GRID, PARAMS, requestedVWCdepths );
%         if saveFigs
%             saveas( fig_VLWCs_vs_time, [ rundir runListing(i).name '/' runListing(i).name '_VLWCs_vs_time_' datestr(OUTPUT.timestamp(1), 'yyyy') '.fig' ] );
%             saveas( fig_VLWCs_vs_time, [ rundir runListing(i).name '/' runListing(i).name '_VLWCs_vs_time_' datestr(OUTPUT.timestamp(1), 'yyyy') '.png' ] );
%         end
%         
%         fig_Ts_vs_time = plot_Ts_vs_time( OUTPUT, GRID, PARAMS, requestedTdepths );
%         if saveFigs
%             saveas( fig_Ts_vs_time, [ rundir runListing(i).name '/' runListing(i).name '_Ts_vs_time_' datestr(OUTPUT.timestamp(1), 'yyyy') '.fig' ] );
%             saveas( fig_Ts_vs_time, [ rundir runListing(i).name '/' runListing(i).name '_Ts_vs_time_' datestr(OUTPUT.timestamp(1), 'yyyy') '.png' ] );
%         end
    end 
end