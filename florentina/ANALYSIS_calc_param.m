function [] = ANALYSIS_calc_param( OUTPUT, PARAMS, GRID, SAVE

% Plotting Script to visualise Parameters
% Author: Florentina M�nzner (FM)
% Begin: 22.01.2018
% ------------------------
% Script to get access to parameters:
%
%   Active Layer Depth = ALD
%   Soil Temperature, at all depths = T_soil_depth[m]
%   Water Table = H_watertable
%   Soil Moisture /vol. water content = theta
%   Timing of snowmelt/snowfall
%% LOAD DATA
% load data: OUTPUT and SETTINGS file
filepath_out = [setdir + '/' + folder + '/' + folder + '_output.mat'];
filepath_set = [setdir + '/' + folder + '/' + folder + '_settings.mat'];
output = load(filepath_out) ;
settings = load(filepath_set) ;

OUTPUT = output.OUT;
PARAMS = settings.PARA;
GRID = settings.GRID;
FORCING = settings.FORCING;

%% Definition

% Temperature
Ts = OUTPUT.cryoGrid3();
% create centered z-grid (positive values into depth)
zs = 1 .* GRID.general.cT_grid();
zs_delta = 1 .* GRID.general.cT_delta();
altitude_grid = zs;
% time
ts = OUTPUT.timestamp();
% absolute soil depth
% soil_surface_altitude = (nanmin(OUTPUT.soil.topPosition, OUTPUT.soil.lakeFloor).' + PARAMS.location.altitude) ;
soil_surface_altitude = OUTPUT.soil.topPosition.' + PARAMS.location.altitude;
lakefloor = (nanmin(OUTPUT.soil.topPosition, OUTPUT.soil.lakeFloor).' + PARAMS.location.altitude);
%water content
LWCs = OUTPUT.liquidWater;
% relative null


%% Active layer depth
% Determines the deepest position of the active layer
ALD = nan( size( Ts, 2 ), 1); 
Tsearch = [];
for i= 1:length(ts)
    Tsearch = Ts( zs<0 & zs>-5, : ); % Temperatures between 0 m und 5 m depth
end
for i = 1:length(ALD)
    ald_idx = find(Ts(:, i) > 0, 1, 'last');
    if isempty(ald_idx)
        ALD(i) = soil_surface_altitude(i); % if there is no value, use soil_surface altitude
    else
        ALD(i)= -(zs(ald_idx) + 0.5 * zs_delta (ald_idx+1)) + PARAMS.location.altitude;
    end
end

%% Soil Temperature

depth_delta = OUTPUT.soil.topPosition;
new_depth = nan( length(depth), length(ts)); % leeres array max tiefe mal max zeit
k = nan( length(depth), length(ts)); % leeres array, hilfsarray, 
index = nan( length(depth), length(ts)); % leeres array, hilfsarray f�r indexfindung, anzahl der angefragten tiefen mal zeit
T_depth = nan( length(depth), length(ts)); % leeres array, gibt sp�ter aus, in welcher temperatur in der angefragten tiefe vorherrscht
% Schleife: Neuberechnung des Abstandes zw. Bodenoberkante und angefragter
% tiefe
for i=1:length(depth)
    new_depth(i,:) = depth(i) - depth_delta;
end
% Schleife: 
for j=1:size(new_depth,1) % f�r alle Tiefen
    for i=1:length(ts) % f�r alle Zeitpunkte
        k(j,i) = find(zs > new_depth(j,i), 1, 'first'); % finde index, wo grid-tiefe kleiner als die neue tiefe ist. nimm den letzten wert.
    end
end
% Schleife: Vergleicht die Tiefe des Indexes k mit der Tiefe des n�chsten
% Indexes (k+1), es wird ein neuer index abgespeichert, zugeh�rig der Tiefe
% die einen geringeren Abstand hat zur Zieltiefe
for j=1:size(new_depth,1)
    for i=1:length(ts)
        [M,I] = min ( [abs(zs(k(j,i)) - depth) abs(zs(k(j,i) + 1) - depth)] );
        if I == double(1)
            index(j,i) = k(j,i);
        else
            index(j,i) = k(j,i)+1;
        end
        %Sicherungs_tiefe(j,i) = zs(index(:,:));
        T_depth(j,i) = Ts(index(j,i),i);
        Moist_depth(j,i) = LWCs(index(j,i), i);
    end
end

%% Water Table
% uses relative values
LWCs = OUTPUT.liquidWater;
WT = nan( 1, size(Ts,2));
porosity = 1 - GRID.soil.cT_mineral-GRID.soil.cT_organic;
for i=1:size(LWCs,2);
    WT_idx = find( LWCs(GRID.soil.cT_domain_ub:GRID.soil.cT_domain_lb,i) == porosity, 1, 'first');
    if isempty(WT_idx);
        WT(i)= soil_surface_altitude(i);
    else
        WT(i)= -(zs( GRID.soil.cT_domain_ub + WT_idx -1 ))+PARAMS.location.altitude;
    end
end
% quick bugfix for values too low
WT(WT<-1)=nan;

%% get total snow height

snow_height = OUTPUT.snow.topPosition.' + PARAMS.location.altitude; %- new_depth(1,:);
