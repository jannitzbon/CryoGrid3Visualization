% Plotting script for temperature and water content fields
% Author: Jan Nitzbon
%
% function plot_output(dirname, runname, number_of_realizations)

clear all
close all

addpath( '../functions' );

rundir = '/home/jnitzbon/remote/cirrus/data/scratch/nitzbon/CryoGrid/CryoGrid3_infiltration_xice_mpi/runs';
runname = 'POLYGON-EXPLORE-197910-201412fC0.30_fR0.60_fT0.10_dxiceC0.90_dxiceR0.60_dxiceT0.30_extFlux-0.0010_dE0.02_K0.000010';
number_of_realizations = 3;

dataDirMet = '/media/geo5/SoilData/data/level1/SaMet2002/00_full_dataset/';


startYear = 1979;
endYear = 1980;

year = 2010;

%mkdir( [rundir '/' runname '/movie' ] );

cm=load( [ '../colormaps/' 'cm_blueautumn.mat' ] );

saveFigs=true;

%%
for year=startYear:endYear

    % load results
    RESULTS = {};
    for i=1:number_of_realizations

        outputfile = [rundir '/' runname '/' runname '_realization' num2str(i) '_output' num2str(year) '.mat'];
        configfile = [rundir '/' runname '/' runname '_realization' num2str(i) '_settings.mat'];

        load(outputfile);
        load(configfile);

        RESULTS{i}.OUT= OUT;
        RESULTS{i}.PARA = PARA;
        RESULTS{i}.GRID = GRID;
        RESULTS{i}.FORCING = FORCING;

        clear OUT PARA GRID FORCING
    end
    %%

    disp( [ 'At year: ' num2str(year) ' ...' ] );
    
    % water tables ( with data from 2007-2014)
%     fig = plot_waterTable_vs_time( RESULTS{1}.OUT, RESULTS{1}.PARA );
%     if year>2007 % no data before 2002
% 
%         plot water tables
%         hold on;
%         ax = gca;
%         ax.ColorOrderIndex = 1; % reset color order
%         load field data for this year
%         dataFile = [ dataDirMet sprintf('SaMet2002_%d_lv1.dat',year) ];
%         DATA = readtable( dataFile, 'TreatAsEmpty', {'NA'} );
%         DATA.UTC = datenum( DATA.UTC ) ;%, 'yyyy-mm-dd HH:MM');
%         ts =  DATA.UTC;
%         dataLabels = DATA.Properties.VariableNames;
%         valueLabel = sprintf( 'WT' );
%         flagLabel = sprintf( 'WT_fl' );
%         values = table2array( DATA(:, valueLabel) );
%         flags = table2array( DATA(:, flagLabel) );
%         values( flags>0 ) = NaN;
%         values = (values)./100;
%         ts_values_hourly = timeseries( values, ts );
%         scatter( ts_values_hourly.time, ts_values_hourly.data , 'DisplayName', 'water table - data');
%         legend('show', 'Location', 'NorthWest');
%         axis( [ts(1), ts(end), -0.1, 1. ] );
%         title( sprintf( 'Year: %d' , year ), 'FontSize', 10 );
%         hold off;
% 
% 
%     end
%     saveas( fig, [rundir '/' runname '/' runname '_WT_vs_time_' num2str(year) '.png' ] );
    fig = plot_Tfield_vs_time_mpi( RESULTS, number_of_realizations, cm);
    if saveFigs
        saveas( fig, [rundir '/' runname '/' runname '_Tfield_vs_time_' num2str(year) '.png'] );
    end        
    fig = plot_VLWCfield_vs_time_mpi(RESULTS, number_of_realizations);
    if saveFigs
        saveas( fig, [rundir '/' runname '/' runname '_VLWCfield_vs_time_' num2str(year) '.png'] );
    end  
    % winter energy balance 01.01. - 31.03.
    fig = plot_EBseasonal_mpi( RESULTS, number_of_realizations, datenum(year, 1, 1), datenum(year,4,1), -20, 5 );
    saveas( fig, [rundir '/' runname '/' runname '_EBwinter' num2str(year) '.png'] );    
    
    % summer energy balance 01.06 - 31.08.
    fig = plot_EBseasonal_mpi( RESULTS, number_of_realizations, datenum(year, 6, 1), datenum(year,9,1), 0, 140 );
    saveas( fig, [rundir '/' runname '/' runname '_EBsummer' num2str(year) '.png'] );

    % altitudes
    fig = plot_altitudes_vs_time_mpi( RESULTS, number_of_realizations );
    saveas( fig, [rundir '/' runname '/' runname '_altitudes_vs_time' num2str(year) '.png'] );
    % 
    %altitudes and fluxes
    fig = plot_altitudes_fluxes_vs_time_mpi( RESULTS, number_of_realizations );
    saveas( fig, [rundir '/' runname '/' runname '_altitudes_waterFluxes_vs_time' num2str(year) '.png'] );

%     % altitude states
%     for date=datenum(year,1,1):10:datenum(year,12,31)
%         
%         disp( [ 'At date: ' datestr(date) ' ...' ] ); 
%         fig = plot_altitudes_vs_area_mpi( RESULTS, number_of_realizations, date);
%         saveas( fig, [rundir '/' runname '/movie/' runname '_altitudes_vs_area_' datestr(date, 'yyyymmdd') '.png'] );
% 
%     end
    
    clear RESULTS
end