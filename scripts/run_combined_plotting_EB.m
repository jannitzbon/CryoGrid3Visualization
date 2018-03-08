close all;
clear all;

modelDir = '/home/jnitzbon/remote/jnitzbon/CryoGrid/github/CryoGrid3_infiltration_xice/runs/VALIDATION-WET-DRY-20180220/';
run = 'VALIDATION-DRY_200710-201101_rf1_sf1_maxSnow1.0_snowDens=225.0_maxWater0.0_extFlux-0.0010_fc0.50_rd0.10';

year = 2008;

strat = 'DRY';

% load model settings
outputFile =  [ modelDir run '/' run '_output' num2str(year) '.mat' ] ;
settingsFile = [ modelDir run '/' run '_settings.mat' ] ;
load( outputFile );
load( settingsFile );


if year==2007
    startDate = datenum( year, 7, 12 );
    endDate = datenum( year, 8, 23 );
elseif year==2008
    startDate = datenum( year, 6, 7 );
    endDate = datenum( year, 8, 30 );
else
    startDate = datenum( year, 6, 1 );
    endDate = datenum( year, 9, 1 );
end

%%
ts = OUT.timestamp();
[~, startIndex] = min( abs( ts - startDate ) );
[~, endIndex] = min( abs( ts- endDate ) );

dt = OUT.timestamp(2)-OUT.timestamp(1);

fig=figure('visible','on');
hold on;

Q_net = cumsum( OUT.EB.Qnet ( startIndex:endIndex ) .* dt .*24 .*3600 );
Q_h = cumsum( OUT.EB.Qh( startIndex:endIndex ) .* dt .* 24 .*3600 );
Q_e = cumsum( OUT.EB.Qe ( startIndex:endIndex ) .* dt .* 24 .* 3600 );
Q_g = cumsum( OUT.EB.Qg ( startIndex:endIndex ) .* dt .* 24 .* 3600 );
Q_geo = cumsum( OUT.EB.Qgeo ( startIndex:endIndex ) .* dt .* 24 .* 3600 );
Q_lateral = cumsum( OUT.EB.Q_lateral ( startIndex:endIndex ) .* dt .* 24 .* 3600 )';
DE_soilsens = cumsum( OUT.EB.dE_soil_sens ( startIndex:endIndex ) );
DE_soillat = cumsum( OUT.EB.dE_soil_lat ( startIndex:endIndex ) );
DE_snowsens = cumsum( OUT.EB.dE_snow_sens ( startIndex:endIndex ) );
DE_snowlat = cumsum( OUT.EB.dE_snow_lat ( startIndex:endIndex ) );

dp_rain = OUT.WB.dp_rain(  startIndex:endIndex );
de = OUT.WB.de( startIndex:endIndex );
ds = OUT.WB.ds( startIndex:endIndex );
dr_surface = OUT.WB.dr_surface( startIndex:endIndex );
dr_external = OUT.WB.dr_external( startIndex:endIndex );
dr_lateral = OUT.WB.dr_lateral( startIndex:endIndex );
DE_Qevaporation = cumsum( de ./ 1000 .* PARA.constants.L_sl .* PARA.constants.rho_w );
%DE_Qsublimation = cumsum( ds ./ 1000. * PARA.constants.L_sl .* PARA.constants.rho_w );
DE_liquidRunoff = cumsum ( (dr_surface + dr_external + dr_lateral) ./ 1000 .* PARA.constants.L_sl .* PARA.constants.rho_w );
DE_rain = cumsum( dp_rain ./ 1000 .* PARA.constants.L_sl .* PARA.constants.rho_w );
DE_Q_WB = DE_rain+DE_liquidRunoff+DE_Qevaporation;

C = (DE_soilsens+DE_soillat+DE_snowsens+DE_snowlat) - (Q_g+Q_geo+Q_lateral+DE_Q_WB);

y = [  Q_net(end),...
    Q_h(end), ...
    Q_e(end), ...
    Q_g(end), ...
    0.0];

% Q_geo(end), ...
%     Q_lateral(end), ...
%     DE_soilsens(end), ...
%     DE_soillat(end), ...
%     DE_snowsens(end), ...
%     DE_snowlat(end), ...
%     DE_Q_WB(end), ...

y = y ./ (endDate-startDate) ./ (3600*24); % now in W/m^2
%% comp data from Langer 2011

if year == 2007
    y = [ y ; [ 81.0, 14.0, 40.0, 15.0, 12.0 ] ];
elseif year == 2008
    if strcmp( strat, 'DEFAULT')
        y = [ y ; [ 104.0, 22.0, 44.0, 20.0, 18.0 ] ];
    elseif strcmp( strat, 'WET')
        y = [ y ; [ nan,   1.0,  64.0, nan, nan ] ];
    elseif strcmp( strat, 'DRY')
        y = [ y ; [ nan,   36.0, 28.0, nan, nan ] ];
    end
end
y = y';

ylabel( 'Mean fluxes [W/m^2]' );
xlabels = { 'Qnet', 'Qh', 'Qe', 'Qg',  'C'};
%c = { 'g'; 'b'; 'r'; 'c'; 'm'; 'b'};
b = bar( y );
b(1).FaceColor = 'r';
b(2).FaceColor = 'k' ;

b(1).DisplayName = 'Model';
b(2).DisplayName = 'Data - Langer2011a';
ax=gca;
set(ax,'xticklabel',xlabels, 'xtick',1:numel(xlabels));
ylim([ -120, 120 ] )

bowenRatio = Q_h(end)./Q_e(end);
text( 0, -10, sprintf( 'Bowen ratio model = %0.2f', bowenRatio ) );
text( 0, -20, sprintf( 'Bowen ratio data = %0.2f', y(2,2)./y(3,2) ) );

grid('on');
legend(b, 'Location', 'northeast');

title( sprintf( 'Energy balance from %s to %s \n Model run: %s' , datestr(startDate), datestr(endDate), run ), 'FontSize', 8 );
hold off;

saveas( fig,  [ modelDir run '/' run '_EBsummerDATA_' num2str(year) '.png' ] );
