function fig = plot_altitudes_fluxes_vs_time_mpi( RESULTS, number_of_realizations )

    

    ts = RESULTS{1}.OUT.timestamp();
    
    water_table = {};
    frost_table = {};
    surface_level = {};
    terrain_level = {};
    soil_level = {};
    
    for i=1:number_of_realizations
        water_table{i} = RESULTS{i}.OUT.location.water_table_altitude();
        frost_table{i} = RESULTS{i}.OUT.location.active_layer_depth_altitude();
        surface_level{i} = RESULTS{i}.OUT.location.surface_altitude;
        terrain_level{i} = RESULTS{i}.OUT.location.altitude();   
        soil_level{i} = RESULTS{i}.OUT.location.soil_altitude();
    end

    fig=figure('visible','off','PaperPosition',[0 0 15 25],'PaperUnits', 'centimeters');
    ax={};
    for i=1:number_of_realizations
        ax{i}=subplot(2*number_of_realizations-1, 1, 2*i-1);
        hold on;
    end
    for i=1:number_of_realizations-1
        ax{number_of_realizations+i}=subplot(2*number_of_realizations-1, 1, 2*i);
        hold on;
    end

    % altitude plots
    for i=1:number_of_realizations
        p_area = area(ax{i}, ts, [ soil_level{i}, terrain_level{i}-soil_level{i}, surface_level{i}-terrain_level{i}] );
        p_area(1).FaceColor = [210 180 140]./255;
        p_area(1).FaceAlpha = 0.5;
        p_area(1).DisplayName = 'soil domain';
        p_area(2).FaceColor = [176 196 222]./255;
        p_area(2).FaceAlpha = 0.5;
        p_area(2).DisplayName = 'lake domain';
        p_area(3).FaceColor = [220 220 220]./255;
        p_area(3).FaceAlpha = 0.5;
        p_area(3).DisplayName = 'snow domain';


        plot(ax{i}, ts, water_table{i}, 'blue', 'LineWidth', 2, 'DisplayName','water table');
        plot(ax{i}, ts, frost_table{i}, 'red', 'LineWidth', 2, 'DisplayName','frost table');

        axis(ax{i}, [ ts(1) ts(end) 19 21 ] );

        datetick(ax{i},'x','mmm');     
        xlabel(ax{i},'time');
        ylabel(ax{i},'altitude [m asl]');
        
        grid(ax{i},'on');
              
    end    
    legend(ax{1},'show', 'Location', 'southwest');
    title(ax{1}, 'CENTER');
    title(ax{2}, 'RIM');
    title(ax{3}, 'TROUGH');
    
    % lateral flux plots
    for i=1:number_of_realizations-1
        %plot( ax{number_of_realizations+i}, ts, RESULTS{i}.OUT.lateral.water_fluxes(:,i+1), 'DisplayName', 'water flux - lower to upper' );
        plot( ax{number_of_realizations+i}, ts, RESULTS{i+1}.OUT.lateral.water_fluxes(:,i).*1000.*24.*3600, 'DisplayName', 'water flux - upper to lower' , 'LineWidth', 2);
        %plot( ax{number_of_realizations+i}, ts, RESULTS{i}.OUT.lateral.snow_fluxes(:,i+1), 'DisplayName', 'snow flux - lower to upper' );
        %plot( ax{number_of_realizations+i}, ts, RESULTS{i}.OUT.lateral.heat_fluxes(:,i+1), 'DisplayName', 'heat flux - lower to upper' );

        limit = max( abs( RESULTS{i+1}.OUT.lateral.water_fluxes(:,i).*1000.*24.*3600 ) );
        if limit==0
            limit=1;
        end
        axis( ax{number_of_realizations+i}, [ ts(1), ts(end), -limit, limit ] );
        
        grid(ax{number_of_realizations+i},'on');

        datetick(ax{number_of_realizations+i},'x','mmm');     
        xlabel(ax{number_of_realizations+i}, 'time');
        ylabel(ax{number_of_realizations+i}, 'lateral flux [mm / day]' );
    end
    
    legend( ax{number_of_realizations+1}, 'show', 'Location', 'southeast' );
    legend( ax{number_of_realizations+2}, 'show', 'Location', 'southeast' );

    
end
