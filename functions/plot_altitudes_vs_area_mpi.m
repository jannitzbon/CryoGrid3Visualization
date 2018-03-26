function fig = plot_altitudes_vs_area_mpi( RESULTS, number_of_realizations, tDatenum )

    

    ts = RESULTS{1}.OUT.timestamp();
    
    [~, idx] = min( abs(ts-tDatenum) );
    
    water_table = zeros( number_of_realizations, 1);
    frost_table = zeros( number_of_realizations, 1);
    surface_level = zeros( number_of_realizations, 1);
    terrain_level = zeros( number_of_realizations, 1);
    soil_level = zeros( number_of_realizations, 1);
    area = zeros( number_of_realizations, 1);
    
    for i=1:number_of_realizations
        water_table(i) = RESULTS{i}.OUT.location.water_table_altitude(idx);
        frost_table(i) = RESULTS{i}.OUT.location.active_layer_depth_altitude(idx);
        surface_level(i) = RESULTS{i}.OUT.location.surface_altitude(idx);
        terrain_level(i) = RESULTS{i}.OUT.location.altitude(idx);   
        soil_level(i) = RESULTS{i}.OUT.location.soil_altitude(idx);
        area(i) = RESULTS{i}.OUT.location.area(idx);
    end
   
    fig=figure('visible','off');
    
    for i=1:number_of_realizations
        startArea=0;
        for j=1:number_of_realizations
            if j<i
                startArea=startArea+area(j);
            end
        end
        r_soil = rectangle( 'Position', [ startArea, 0,             area(i), soil_level(i)                      ], 'FaceColor', [210 180 140 150]./255);
        r_lake = rectangle( 'Position', [ startArea, soil_level(i), area(i), terrain_level(i)-soil_level(i)     ], 'FaceColor', [176 196 222 150]./255);
        r_snow = rectangle( 'Position', [ startArea, terrain_level(i), area(i), surface_level(i)-terrain_level(i)  ], 'FaceColor', [220 220 220 150]./255);
        
        l_wt   = line( [ startArea, startArea+area(i)], [water_table(i), water_table(i) ], 'Color', 'blue', 'LineWidth', 2, 'DisplayName','water table');
        l_ft   = line( [ startArea, startArea+area(i)], [frost_table(i), frost_table(i) ], 'Color', 'red', 'LineWidth', 2, 'DisplayName','frost table');

        axis([ 0 sum(area) 18 21 ] );
        
        

        xlabel('areal extent [m²]');
        ylabel('altitude [m asl]');
        
        grid('on');
              
    end    
    legend( 'water table', 'frost table', 'Location', 'southeast');
   
    text( 0.1*sum(area), 20.8, datestr( tDatenum, 'dd-mm-yyyy'), 'FontSize', 20 );

end
