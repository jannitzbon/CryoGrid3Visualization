close all;
clear all;

host=2;

if host==1 %laptop

    dataDir = '/media/geo5/SoilData/data/level1/SaSoil2002/00_full_dataset/';
    dataDirMet = '/media/geo5/SoilData/data/level1/SaMet2002/00_full_dataset/';

    modelDir = '/home/jnitzbon/remote/linux3/scratch1/jnitzbon/CryoGrid3/CryoGrid3_infiltration_xice/runs/';
    
elseif host==2 %linux3
    dataDir = '/geo5/SoilData/data/level1/SaSoil2002/00_full_dataset/';
    dataDirMet = '/geo5/SoilData/data/level1/SaMet2002/00_full_dataset/';

    modelDir = '/scratch1/jnitzbon/CryoGrid3/CryoGrid3_infiltration_xice/runs/';
    
end

runSet = 'VALIDATION*stratDRY*';
runListing = dir( [ modelDir runSet ] );

%mask_center = not( cellfun( 'isempty',  strfind( dataLabels, 'vwc_center' ) ) );
depths_vwc_center = [  8, 13, 23, 33, 43 ];
depths_T_center = [  5, 10, 20, 30, 40 ];

%mask_rim = not( cellfun( 'isempty',  strfind( dataLabels, 'vwc_rim' ) ) );
depths_vwc_rim = [ 5,  15,  34,  50,  60 ] ; %[  5, 12, 15, 22, 26, 34, 37, 50, 60, 70 ];
depths_T_rim = [ 6, 16, 33, 51, 61 ] ; %[  2, 6, 11, 16, 21, 27, 33, 38, 51, 61, 71 ];

%mask_slope = not( cellfun( 'isempty',  strfind( dataLabels, 'vwc_slope' ) ) );
depths_vwc_slope = [ 5,  14,  23,  33,  43 ] ;
depths_T_slope = [ 7, 16, 22, 32, 42 ];

depthsMapVWC = containers.Map( {'center', 'slope', 'rim'}, { depths_vwc_center, depths_vwc_slope, depths_vwc_rim } );
depthsMapT = containers.Map( {'center', 'slope', 'rim'}, { depths_T_center, depths_T_slope, depths_T_rim } );

keys_depthMapVWC = keys( depthsMapVWC );
keys_depthMapT = keys(depthsMapT);
%%

for i=1:length(runListing)
    
    disp( ['Processing run ' runListing(i).name ' ...'] );
    
    % load model settings
    outputListing = dir( [ modelDir runListing(i).name '/*output*' ] );
    settingsFile = dir( [ modelDir runListing(i).name '/*settings*' ] );
    load( [ modelDir runListing(i).name '/' settingsFile.name ] );
    
    maxYear = str2double(datestr(PARA.technical.endtime, 'yyyy'));
    
    % loop over all years
    for j=1:length(outputListing)
        disp( ['... at file ' outputListing(j).name ] );
        % load output for this year
        load( [ modelDir runListing(i).name '/' outputListing(j).name ] );
        year=str2double(datestr(OUT.timestamp(1), 'yyyy'));   
        
        
        
        if year<maxYear+1   % this is just to exclude runs ending at 1.1.XXXX 
            % plot altitudes
            fig_altitudes_vs_time = plot_altitudes_vs_time( OUT, PARA );
            hold on;
            title( sprintf( 'Year: %d \n Model run: %s' , year, runListing(i).name ), 'FontSize', 10 );
            hold off;
            saveas( fig_altitudes_vs_time, [ modelDir runListing(i).name '/' runListing(i).name '_altitudes_vs_time_' datestr(OUT.timestamp(1), 'yyyy') '.png' ] );
    
            % plot summer water balance
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
            fig_WBsummer = plot_WBseasonal( OUT, startDate, endDate );
            hold on;
            title( sprintf( 'Water balance from %s to %s \n Model run: %s' , datestr(startDate), datestr(endDate), runListing(i).name ), 'FontSize', 8 );
            hold off;
            saveas( fig_WBsummer, [ modelDir runListing(i).name '/' runListing(i).name '_WBsummer_' datestr(OUT.timestamp(1), 'yyyy') '.png' ] );
            % plot summer energy balance
            fig_EBsummer = plot_EBseasonal( OUT, PARA, startDate, endDate );
            hold on;
            title( sprintf( 'Energy balance from %s to %s \n Model run: %s' , datestr(startDate), datestr(endDate), runListing(i).name ), 'FontSize', 8 );
            hold off;
            set(fig_EBsummer, 'visible', 'off');
            saveas( fig_EBsummer, [ modelDir runListing(i).name '/' runListing(i).name '_EBsummer_' datestr(OUT.timestamp(1), 'yyyy') '.png' ] );
            % plot with data for 2007 and 2008
            if year == 2007 || year == 2008
                fig_EBsummerData = plot_EB_withData( OUT, PARA, startDate, endDate );
                hold on;
                title( sprintf( 'Energy balance from %s to %s \n Model run: %s' , datestr(startDate), datestr(endDate), runListing(i).name ), 'FontSize', 8 );
                hold off;
                saveas( fig_EBsummerData, [ modelDir runListing(i).name '/' runListing(i).name '_EBsummerDATA_' datestr(OUT.timestamp(1), 'yyyy') '.png' ] );
            end
            
            if year>2001 % no data before 2002

                % plot water tables
                fig_WT_vs_time = plot_waterTable_vs_time( OUT, PARA );
                hold on;
                ax = gca;
                %ax.ColorOrderIndex = 1; % reset color order
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
                scatter( ts_values_hourly.time, ts_values_hourly.data , 'DisplayName', 'water table - data');
                legend('show', 'Location', 'NorthWest');
                %axis( [ts(1), ts(end), -0.1, 1. ] );
                title( sprintf( 'Year: %d \n Model run: %s' , year, runListing(i).name ), 'FontSize', 10 );
                hold off;
                
                saveas( fig_WT_vs_time, [ modelDir runListing(i).name '/' runListing(i).name '_WT_vs_time_' datestr(OUT.timestamp(1), 'yyyy') '.png' ] );
                
            end
                
                
                            % plot soil moistures
            if year>2001 % no data before 2002

                % load field data for this year
                dataFile = [ dataDir sprintf('SaSoil2002_%d_lv1.dat',year) ];
                DATA = readtable( dataFile, 'TreatAsEmpty', {'NA'} );
                DATA.UTC = datenum( DATA.UTC ) ;%, 'yyyy-mm-dd HH:MM');
                ts =  DATA.UTC;
                dataLabels = DATA.Properties.VariableNames;

                % loop over center / rim / slope data
                %for k=1:length(depthsMapVWC)

                    profile = 'rim';%keys_depthMapVWC{k};

                    % plot vwc
                    fig_VLWCs_vs_time = plot_VLWCs_vs_time( OUT, GRID, PARA, depthsMapVWC(profile)/100 );
                    hold on;
                    set(fig_VLWCs_vs_time, 'visible', 'off');
                    ax = gca;
                    ax.ColorOrderIndex = 1; % reset color order

                    for depth=depthsMapVWC(profile)

                        valueLabel = sprintf( 'vwc_%s_%d', profile, depth );
                        flagLabel = sprintf( 'vwc_%s_%d_fl', profile, depth );

                        values = table2array( DATA(:, valueLabel) );
                        flags = table2array( DATA(:, flagLabel) );
                        values( flags>0 ) = NaN;
                        ts_values_hourly = timeseries( values, ts );
                        %ts_values_daily = resample( ts_values_hourly, ts(1):0.5:ts(end) );
                        scatter( ts_values_hourly.time, ts_values_hourly.data , 'DisplayName', sprintf( 'z=%0.2fm', depth/100) );
                    end
                    datetick('x');
                    grid on;
                    legend('show', 'Location', 'NorthWest');
                    axis( [ts(1), ts(end), -0.1, 1. ] );
                    title( sprintf( 'Year: %d \n Model run: %s \n Dataset: %s' , year, runListing(i).name, profile ), 'FontSize', 10 );
                    hold off;

                    saveas( fig_VLWCs_vs_time, [ modelDir runListing(i).name '/' runListing(i).name '_VLWCs_vs_time_DATA' profile '_' datestr(OUT.timestamp(1), 'yyyy') '.png' ] );
                    
                    % plot T
                    fig_Ts_vs_time = plot_Ts_vs_time( OUT, GRID, PARA, depthsMapT(profile)/100 );
                    hold on;
                    set(fig_Ts_vs_time, 'visible', 'off');
                    ax = gca;
                    ax.ColorOrderIndex = 1;
                    
                    for depth=depthsMapT(profile)
                        
                        valueLabel = sprintf( 'Ts_%s_%d', profile, depth );
                        flagLabel = sprintf( 'Ts_%s_%d_fl', profile, depth );
                        
                        values = table2array( DATA(:, valueLabel) );
                        flags = table2array( DATA(:, flagLabel) );
                        values( flags>0 ) = NaN;
                        ts_values_hourly = timeseries( values, ts );
                        %ts_values_daily = resample( ts_values_hourly, ts(1):0.5:ts(end) );
                        scatter( ts_values_hourly.time, ts_values_hourly.data , 'DisplayName', sprintf( 'z=%0.2fm', depth/100) ); 
                    end
                    datetick('x');
                    grid on;
                    legend('show', 'Location', 'NorthWest');
                    axis( [ts(1), ts(end), -40, 20 ] );
                    title( sprintf( 'Year: %d \n Model run: %s \n Dataset: %s' , year, runListing(i).name, profile ), 'FontSize', 10 );
                    hold off;

                    saveas( fig_Ts_vs_time, [ modelDir runListing(i).name '/' runListing(i).name '_Ts_vs_time_DATA' profile '_' datestr(OUT.timestamp(1), 'yyyy') '.png' ] );
                    
                %end

            end
            
        end
            
    end
    
end