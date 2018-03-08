% Plotting script for temperature and water content fields
% Author: Jan Nitzbon
%
%function plot_output(dirname, runname, number_of_realizations)

clear all
close all

dirname = '../runs/';
runname = 'TESTRUN_197907-197908_stratSam_rf1_sf1_maxSnow1.0_snowDens=200.0_wt0.0_extFlux0.0000_fc0.40';
number_of_realizations=1;

year = 1979;
startDate = datenum(year, 1, 1);
endDate = datenum(year,9, 1);
number_of_realizations = 1;

%% load output data and settings from files of all workers


dir = dirname;
cm=load( [ './cm_blueautumn.mat' ] );

OUTS = {};

for i=1:number_of_realizations
    run = runname;
    if number_of_realizations>1
        run = [ run num2str(i) ];
    end
    outputfile = [dir run  '/' run '_output' num2str(year) '.mat'];
    configfile = [dir run  '/' run '_settings.mat'];
    
    load(outputfile);
    load(configfile);
    
    OUTS{i}.OUT=OUT;
    OUTS{i}.PARA = PARA;
    OUTS{i}.GRID = GRID;
    OUTS{i}.FORCING = FORCING;
    
    clear OUT PARA GRID FORCING
end

%%

for i=1:number_of_realizations
    
    ts = OUTS{i}.OUT.timestamp();
    [~, startIndex] = min( abs( ts - startDate ) );
    [~, endIndex] = min( abs( ts- endDate ) );
    
    

    % water balance
    figure;
    hold on;
    
    DW_soil = cumsum( OUTS{i}.OUT.WB.dW_soil( startIndex:endIndex ) );
    DW_snow = cumsum( OUTS{i}.OUT.WB.dW_snow( startIndex:endIndex ) );
    Dp_rain = cumsum( OUTS{i}.OUT.WB.dp_rain( startIndex:endIndex ) );
    Dp_snow = cumsum( OUTS{i}.OUT.WB.dp_snow( startIndex:endIndex ) );
    De = cumsum( OUTS{i}.OUT.WB.de( startIndex:endIndex ) );
    Ds = cumsum( OUTS{i}.OUT.WB.ds( startIndex:endIndex ) );
    Dr_surface = cumsum( OUTS{i}.OUT.WB.dr_surface( startIndex:endIndex ) );
    Dr_external = cumsum( OUTS{i}.OUT.WB.dr_external( startIndex:endIndex ) );
    Dr_snowmelt = cumsum( OUTS{i}.OUT.WB.dr_snowmelt( startIndex:endIndex ) );
    Dr_excessSnow = cumsum( OUTS{i}.OUT.WB.dr_excessSnow( startIndex:endIndex ) );
    Dr_lateralSnow = cumsum( OUTS{i}.OUT.WB.dr_lateralSnow( startIndex:endIndex ) );
    Dr_rain = cumsum( OUTS{i}.OUT.WB.dr_rain( startIndex:endIndex ) );
    Dr_lateral = cumsum( OUTS{i}.OUT.WB.dr_lateral( startIndex:endIndex ) );
    Dm_lacking = cumsum( OUTS{i}.OUT.WB.dm_lacking( startIndex:endIndex ) );
 
    y = [  DW_soil(end),...
           DW_snow(end), ...
           Dp_rain(end), ...
           Dp_snow(end), ...
           De(end), ...
           Ds(end), ...
           Dr_surface(end), ...
           Dr_external(end), ...
           Dr_snowmelt(end), ...
           Dr_excessSnow(end), ...
           Dr_lateralSnow(end), ...
           Dr_rain(end), ...
           Dr_lateral(end), ...
           Dm_lacking(end)];
    y = [ y, sum(y)-2*y(1)-2*y(2) ];
    
    x = { 'Wsoil', 'Wsnow', 'prain', 'psnow', 'e', 's', 'rsurface', 'rexternal', 'rsnowmelt', 'rexcessSnow', 'rlateralSnow', 'rrain', 'rlateral', 'mlacking', 'C'};
    
    %c = { 'g'; 'b'; 'r'; 'c'; 'm'; 'b'};

    bar( y );
    set(gca,'xticklabel',x, 'xtick',1:numel(x))
    hold off;

end