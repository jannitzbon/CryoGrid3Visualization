function fig = plot_altitudes_vs_time_mpi( RESULTS, number_of_realizations )

    

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

    fig=figure('visible','off','PaperPosition',[0 0 15 15],'PaperUnits', 'centimeters');
    ax={};
    for i=1:number_of_realizations
        ax{i}=subplot(number_of_realizations, 1, i);
        hold on;
    end
    
    title(ax{1}, 'CENTER');
    title(ax{2}, 'RIM');
    title(ax{3}, 'TROUGH');
    
    
    p_area = {};
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

    
end
