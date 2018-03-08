% Plotting Script for WB
% Water Balance
% Author: Florentina Münzner (FM)
% Begin: 07.02.2018
%% run this script
clear all
close all

dirname = "N:/geo4/HGF_Boike/Personal_Accounts/Florentina/Project_Jan/MATLAB/CryoGrid3/CryoGrid3_infiltration_xice_20180111";
runname = 'TESTRUN_197906-198906_stratSam_rf1_sf1_maxSnow1.0_snowDens=200.0_maxWater0.0_extFlux0.0000_fc0.50';
number_of_realizations=1;

year = [1979 1980 1981 1982 1983 1984 1985 1986 1987 1988 1989];
startDate = datenum(year(1), 1, 1);
endDate = datenum(year(end),12, 31);
number_of_realizations = 1;

%% load output data and settings from files of all workers

cm=load( [ './cm_blueautumn.mat' ] );

OUTS = {};

for i=1:length(year)
    run = runname;
    if number_of_realizations>1
        run = [ run num2str(i) ];
    end
    outputfile = [dirname + '/' + runname + '/' + runname + '_output' + num2str(year(i)) + '.mat'];
    configfile = [dirname + '/' + runname + '/' + runname + '_settings.mat'];
    
    load(outputfile);
    load(configfile);
    
    OUTS{i}.OUT=OUT;
    OUTS{i}.PARA = PARA;
    OUTS{i}.GRID = GRID;
    OUTS{i}.FORCING = FORCING;
    
    %clear OUT PARA GRID FORCING
end


%% Variablen anfragen und plotten

for i=1:length(year)
    
    ts = OUTS{i}.OUT.timestamp();
    [~, startIndex] = min( abs( ts - startDate ) );
    [~, endIndex] = min( abs( ts- endDate ) );
    
    % load vars for water balance
    
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
    
    % define categories
    
    cat_W = categorical({'Soil', 'Snow'});
    x_W = [DW_soil(end); DW_snow(end)];
    cat_P = categorical({'Rain', 'Snow'});
    x_P = [Dp_rain(end), Dp_snow(end)];
    cat_R = categorical({'Rain', 'Snowmelt', 'LateralSnow', 'XSnow', 'Surface', 'External', 'Lateral'});
    x_R = [Dr_rain(end), Dr_snowmelt(end), Dr_lateralSnow(end), Dr_excessSnow(end), Dr_surface(end), Dr_external(end), Dr_lateral(end)];
    cat_ES = categorical({'EvapoTrans', 'Sublim'});
    x_ES = [De(end); Ds(end)];
    cat_M = categorical({'Lacking'});
    x_M = [Dm_lacking(end)];
 
    
    f = figure();
    grid on
    p = uipanel('Parent',f,'BorderType','none');
    p.Title = ['Water Balance Bar Charts of year ', num2str(year(i))];
    p.TitlePosition = 'centertop'; 
    p.FontSize = 12;
    p.FontWeight = 'bold';
    sub1 = uipanel('Parent',p,'Title','Charts','FontSize',12,'Position',[0 0.2 1 .8]);
    sub2 = uipanel('Parent',p,'Title','Furth Information','FontSize',12,'Position',[0 0 1 .2]);
    
    subplot(1,5,1,'Parent',sub1)
    bar(cat_W, x_W, 'Barwidth', 0.2)%, 'stacked')
    ylim([-200, 200])
    title('Water Balance')
    
    subplot(1,5,2,'Parent',sub1)
    bar(cat_P, x_P, 'Barwidth', 0.2)%, 'stacked')
    ylim([-200, 200])
    title('Precipitation')
    
    subplot(1,5,3,'Parent',sub1)
    bar(cat_R, x_R, 'Barwidth', 0.7)%, 'stacked')
    ylim([-200, 200])
    title('Runoff')
    
    subplot(1,5,4,'Parent',sub1)
    bar(cat_ES, x_ES, 'Barwidth', 0.2)%, 'stacked')
    ylim([-200, 200])
    title('Phase Change')

    subplot(1,5,5,'Parent',sub1)
    bar(cat_M, x_M, 'Barwidth', 0.1)%, 'stacked')
    ylim([-200, 200])
    title('Lacking')
    
    %savefig([dirname + '/' + runname + '/' + runname + num2str(year(i)) + '_WB.png']);
    %close(f)
    
end