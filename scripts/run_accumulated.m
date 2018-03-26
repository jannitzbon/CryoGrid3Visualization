% Plotting script for accumulated water balance
% Author: Jan Nitzbon
%
% function plot_output(dirname, runname, number_of_realizations)

clear all
close all

addpath( '../functions' );

rundir = '/home/jnitzbon/remote/cirrus/data/scratch/nitzbon/CryoGrid/CryoGrid3_infiltration_xice_mpi/runs';
runname = 'TESTRUN-MPI_200010-201410_stratSAM_geomHEX_extFluxT-0.0025_xH1_xW1_xS1_rf1_sf1_bugfixWaterCells';
number_of_realizations = 3;

year = 2011;

startDate = datenum( year, 6, 1 );
endDate = datenum( year, 9, 1 );
dt_tot = abs( startDate - endDate );

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
[ ~, startIndexOUT ] = min( abs( RESULTS{1}.OUT.timestamp - startDate ) );
[ ~, endIndexOUT ] = min( abs( RESULTS{1}.OUT.timestamp - endDate ) );

[ ~, startIndexFORCING ] = min( abs( RESULTS{1}.FORCING.data.t_span - startDate ) );
[ ~, endIndexFORCING ] = min( abs( RESULTS{1}.FORCING.data.t_span - endDate ) );



%%

% times
ts_OUT = RESULTS{1}.OUT.timestamp( startIndexOUT:endIndexOUT );
dt_OUT = abs( ts_OUT(1) - ts_OUT(2) );
ts_FORCING = RESULTS{1}.FORCING.data.t_span( startIndexFORCING:endIndexFORCING );
dt_FORCING = abs( ts_FORCING(1) - ts_FORCING(2) );
% precipitation from FORCING
P = RESULTS{1}.FORCING.data.rainfall(startIndexFORCING:endIndexFORCING) .* dt_FORCING ; % in [mm]

% evapotranspiration from OUT per realization
ET_C = RESULTS{1}.OUT.WB.de( startIndexOUT:endIndexOUT );
ET_R = RESULTS{2}.OUT.WB.de( startIndexOUT:endIndexOUT );
ET_T = RESULTS{3}.OUT.WB.de( startIndexOUT:endIndexOUT );

% net lateral flux
LF_C =  nansum( RESULTS{1}.OUT.lateral.water_fluxes( startIndexOUT:endIndexOUT, : ).* 1000 .* 24 .* 3600 .* dt_OUT , 2 );
LF_R =  nansum( RESULTS{2}.OUT.lateral.water_fluxes( startIndexOUT:endIndexOUT, : ).* 1000 .* 24 .* 3600 .* dt_OUT , 2 );
LF_T =  nansum( RESULTS{3}.OUT.lateral.water_fluxes( startIndexOUT:endIndexOUT, : ).* 1000 .* 24 .* 3600 .* dt_OUT , 2 );

% runoff
R_C = RESULTS{1}.OUT.WB.dr_surface( startIndexOUT:endIndexOUT ) + RESULTS{1}.OUT.WB.dr_external( startIndexOUT:endIndexOUT ) + RESULTS{1}.OUT.WB.dr_lateral( startIndexOUT:endIndexOUT );
R_R = RESULTS{2}.OUT.WB.dr_surface( startIndexOUT:endIndexOUT ) + RESULTS{2}.OUT.WB.dr_external( startIndexOUT:endIndexOUT ) + RESULTS{2}.OUT.WB.dr_lateral( startIndexOUT:endIndexOUT );
R_T = RESULTS{3}.OUT.WB.dr_surface( startIndexOUT:endIndexOUT ) + RESULTS{3}.OUT.WB.dr_external( startIndexOUT:endIndexOUT ) + RESULTS{3}.OUT.WB.dr_lateral( startIndexOUT:endIndexOUT );



%% plot accumulated water fluxes

figure;
hold on;
plot( ts_FORCING, cumsum( P ), 'DisplayName', 'P' , 'LineWidth', 2);
plot( ts_OUT, cumsum( ET_C ), 'DisplayName', 'ET_C' , 'LineWidth', 2);
plot( ts_OUT, cumsum( ET_R ), 'DisplayName', 'ET_R' , 'LineWidth', 2);
plot( ts_OUT, cumsum( ET_T ), 'DisplayName', 'ET_T' , 'LineWidth', 2);
% plot( ts_OUT, cumsum( NLF_C ), 'DisplayName', 'NLF_C' , 'LineWidth', 2);
% plot( ts_OUT, cumsum( NLF_R ), 'DisplayName', 'NLF_R' , 'LineWidth', 2);
% plot( ts_OUT, cumsum( NLF_T ), 'DisplayName', 'NLF_T' , 'LineWidth', 2);
plot( ts_OUT, cumsum( R_C ), 'DisplayName', 'R_C', 'LineWidth', 2 );
plot( ts_OUT, cumsum( R_R ), 'DisplayName', 'R_R', 'LineWidth', 2 );
plot( ts_OUT, cumsum( R_T ), 'DisplayName', 'R_T', 'LineWidth', 2 );



grid on;
datetick( 'x', 'mmm-yyyy' )
legend( 'show', 'Location', 'northwest' );
hold off;

%% plot mean water fluxes
dt_tot = abs( startDate - endDate );

figure;
hold on;
scatter( mean(ts_FORCING), sum( P )./dt_tot , 'DisplayName', 'P' , 'LineWidth', 2);
scatter( mean(ts_OUT), sum( ET_C )./dt_tot, 'DisplayName', 'ET_C' , 'LineWidth', 2);
scatter( mean(ts_OUT), sum( ET_R )./dt_tot, 'DisplayName', 'ET_R' , 'LineWidth', 2);
scatter( mean(ts_OUT), sum( ET_T )./dt_tot, 'DisplayName', 'ET_T' , 'LineWidth', 2);
scatter( mean(ts_OUT), sum( R_C )./dt_tot, 'DisplayName', 'R_C' , 'LineWidth', 2);
scatter( mean(ts_OUT), sum( R_R )./dt_tot, 'DisplayName', 'R_R' , 'LineWidth', 2);
scatter( mean(ts_OUT), sum( R_T )./dt_tot, 'DisplayName', 'R_T' , 'LineWidth', 2);
grid on;
datetick( 'x', 'mmm-yyyy' )
legend( 'show', 'Location', 'northwest' );
hold off;


