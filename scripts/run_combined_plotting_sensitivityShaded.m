close all;
clear all;

dataDir = '/media/geo5/SoilData/data/level1/SaSoil2002/00_full_dataset/';
dataDirMet = '/media/geo5/SoilData/data/level1/SaMet2002/00_full_dataset/';

modelDir = '/home/jnitzbon/remote/jnitzbon/CryoGrid/github/CryoGrid3_infiltration_xice/runs/VALIDATION-WET-DEFAULT-20180221/';
runSet2 = 'VALIDATION_201110-201312_stratWET_rf1_sf1_maxSnow1.0_snowDens=225.0_maxWater0.5_extFlux0.0005_fc0.50_rd0.20*';
runSet1 = 'VALIDATION_201110-201312_stratWET_rf1_sf1_maxSnow1.0_snowDens=225.0_maxWater0.5_extFlux0.0010_fc0.50_rd0.20*';

runListing1 = dir( [ modelDir runSet1 ] );
runListing2 = dir( [ modelDir runSet2 ] );


%run = [ 'VALIDATION-DRY_' num2str(year-2) '10-' num2str(year+2) '01_rf1_sf1_maxSnow1.0_snowDens=225.0_maxWater0.0_extFlux-0.0010_fc0.50_rd0.10' ] ;

%mask_center = not( cellfun( 'isempty',  strfind( dataLabels, 'vwc_center' ) ) );
depths_vwc_center = [  8, 13, 23, 33, 43 ];
depths_T_center = [  5, 10, 20, 30, 40 ];

%mask_rim = not( cellfun( 'isempty',  strfind( dataLabels, 'vwc_rim' ) ) );
depths_vwc_rim = [ 5,  15,  34,  50,  60 ] ; %[  5, 12, 15, 22, 26, 34, 37, 50, 60, 70 ];
depths_T_rim = [ 6, 16, 33, 51, 61 ] ; %[  2, 6, 11, 16, 21, 27, 33, 38, 51, 61, 71 ];

%mask_slope = not( cellfun( 'isempty',  strfind( dataLabels, 'vwc_slope' ) ) );
depths_vwc_slope = [ 5,  14,  23,  33,  43 ] ;

depthsMapVWC = containers.Map( {'center', 'slope', 'rim'}, { depths_vwc_center, depths_vwc_slope, depths_vwc_rim } );
depthsMapT = containers.Map( {'center', 'rim'}, { depths_T_center, depths_T_rim } );

keys_depthMapVWC = keys( depthsMapVWC );
%%

for i=1:length(runListing1)
    
    disp( ['Processing run ' runListing1(i).name ' ...'] );
    
    % load model settings
    outputListing1 = dir( [ modelDir runListing1(i).name '/*output*' ] );
    outputListing2 = dir( [ modelDir runListing2(i).name '/*output*' ] );

    settingsFile1 = dir( [ modelDir runListing1(i).name '/*settings*' ] );
    settingsFile2 = dir( [ modelDir runListing2(i).name '/*settings*' ] );

    SETTINGS1 = load( [ modelDir runListing1(i).name '/' settingsFile1.name ] );
    SETTINGS2 = load( [ modelDir runListing2(i).name '/' settingsFile2.name ] );
    
    maxYear = str2double(datestr(SETTINGS1.PARA.technical.endtime, 'yyyy'));
        
    % loop over all years
    for j=1:length(outputListing1)
        disp( ['... at file ' outputListing1(j).name ] );
        % load output for this year
        OUT1 = load( [ modelDir runListing1(i).name '/' outputListing1(j).name ] );
        OUT2 = load( [ modelDir runListing2(i).name '/' outputListing2(j).name ] );
        year=str2double(datestr(OUT1.OUT.timestamp(1), 'yyyy'));   
        
        if year<maxYear+1   % this is just to exclude runs ending at 1.1.XXXX 

         
            if year>2001 % no data before 2002

                % plot water tables
                fig_WT_vs_time = plot_waterTable_vs_time_sensitivityShaded( OUT1.OUT, OUT2.OUT,  SETTINGS1.PARA, SETTINGS2.PARA );
                hold on;
                ax = gca;
                ax.ColorOrderIndex = 1; % reset color order
                % load field data for this year
                dataFile = [ dataDirMet sprintf('SaMet2002_%d_lv1.dat',year) ];
                DATA = readtable( dataFile, 'TreatAsEmpty', {'NA'} );
                DATA.UTC = datenum( DATA.UTC ) ;%, 'yyyy-mm-dd HH:MM');
                ts =  DATA.UTC;
                dataLabels = DATA.Properties.VariableNames;
                valueLabel = sprintf( 'WT' );
                flagLabel = sprintf( 'WT_fl' );
                values = table2array( DATA(:, valueLabel) );
                flags = table2array( DATA(:, flagLabel) );
                values( flags>0 ) = NaN;
                values = (values)./100;
                ts_values_hourly = timeseries( values, ts );
                scatter( ts_values_hourly.time, ts_values_hourly.data , 'DisplayName', 'Data (SaMet2002)');
                legend('show', 'Location', 'SouthWest');
                %axis( [ts(1), ts(end), -0.1, 1. ] );
                title( sprintf( 'Water tables model vs data for year: %d \n Model runs: %s \n vs: %s' , year, runListing1(i).name, runListing2(i).name ), 'FontSize', 8 );
                hold off;
                
                saveas( fig_WT_vs_time, [ '/home/jnitzbon/Documents/projects/polygon/reports/validation/plots/' runListing1(i).name '_WT_vs_time_sensitivity_' num2str(year) '.png' ] );
                
            end
                
                
                %             % plot soil moistures
%             if year>2001 % no data before 2002
% 
%                 % load field data for this year
%                 dataFile = [ dataDir sprintf('SaSoil2002_%d_lv1.dat',year) ];
%                 DATA = readtable( dataFile, 'TreatAsEmpty', {'NA'} );
%                 DATA.UTC = datenum( DATA.UTC ) ;%, 'yyyy-mm-dd HH:MM');
%                 ts =  DATA.UTC;
%                 dataLabels = DATA.Properties.VariableNames;
% 
%                 % loop over center / rim / slope data
%                 for k=1:length(depthsMapVWC)
% 
%                     profile = keys_depthMapVWC{k};
% 
%                     % plot vwc
%                     fig_VLWCs_vs_time = plot_VLWCs_vs_time( OUT, GRID, PARA, depthsMapVWC(profile)/100 );
%                     hold on;
%                     set(fig_VLWCs_vs_time, 'visible', 'off');
%                     ax = gca;
%                     ax.ColorOrderIndex = 1; % reset color order
% 
%                     for depth=depthsMapVWC(profile)
% 
%                         valueLabel = sprintf( 'vwc_%s_%d', profile, depth );
%                         flagLabel = sprintf( 'vwc_%s_%d_fl', profile, depth );
% 
%                         values = table2array( DATA(:, valueLabel) );
%                         flags = table2array( DATA(:, flagLabel) );
%                         values( flags>0 ) = NaN;
%                         ts_values_hourly = timeseries( values, ts );
%                         %ts_values_daily = resample( ts_values_hourly, ts(1):0.5:ts(end) );
%                         scatter( ts_values_hourly.time, ts_values_hourly.data , 'DisplayName', sprintf( 'z=%0.2fm', depth/100) );
%                     end
%                     datetick('x');
%                     grid on;
%                     legend('show', 'Location', 'NorthWest');
%                     axis( [ts(1), ts(end), -0.1, 1. ] );
%                     title( sprintf( 'Year: %d \n Model run: %s \n Dataset: %s' , year, runListing(i).name, profile ), 'FontSize', 10 );
%                     hold off;
% 
%                     saveas( fig_VLWCs_vs_time, [ modelDir runListing(i).name '/' runListing(i).name '_VLWCs_vs_time_DATA' profile '_' datestr(OUT.timestamp(1), 'yyyy') '.png' ] );
% 
%                 end
% 
%             end
            
        end
            
    end
    
end


% % % plot temperatures
% % fig_T = plot_Ts_vs_time( OUT, GRID, PARA, depthsMapT(profile)/100 );
% % hold on;
% % set(fig_T, 'visible', 'on');
% % 
% % ax = gca;
% % ax.ColorOrderIndex = 1;
% % 
% % for depth=depthsMapT(profile)
% %     
% %     valueLabel = sprintf( 'Ts_%s_%d', profile, depth );
% %     flagLabel = sprintf( 'Ts_%s_%d_fl', profile, depth );
% %     
% %     values = table2array( DATA(:, valueLabel) );
% %     flags = table2array( DATA(:, flagLabel) );
% %     
% %     values( flags>0 ) = NaN;
% %     
% %     ts_values_hourly = timeseries( values, ts );
% %     
% %     ts_values_daily = resample( ts_values_hourly, ts(1):0.5:ts(end) );
% %     
% %     scatter( ts_values_hourly.time, ts_values_hourly.data , 'DisplayName', sprintf( 'z=%0.2fm', depth/100) );
% %     
% %     
% % end
% % datetick('x');
% % grid on;
% % legend('show', 'Location', 'NorthWest');
% % axis( [ts(1), ts(end), 40, 20 ] );
% % 
% % title( run );



