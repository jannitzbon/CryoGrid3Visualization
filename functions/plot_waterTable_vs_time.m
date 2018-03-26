function fig = plot_waterTable_vs_time( OUT , PARA )

    ts = OUT.timestamp();
    water_table = OUT.location.water_table_altitude()- PARA.location.soil_altitude();

    try
        soil_level = OUT.location.soil_altitude() - PARA.location.initial_altitude;
    catch
        soil_level = nanmin( OUT.soil.topPosition, OUT.soil.lakeFloor) ;
    end

    fig=figure('visible','off');
    hold on;
    plot( ts, water_table, 'LineWidth', 2, 'DisplayName', 'water table' );% 'Color', [176 196 222]./255,
    plot( ts, soil_level, 'LineWidth', 2, 'DisplayName', 'soil level' );% 'Color', [210 180 140]./255, 
   
    axis( [ ts(1) ts(end) -0.4 0.4 ] );
    %ax=gca;
    %ax.XTick = linspace(ts(1), ts(end), 13);
    datetick('x','mmm');     
    xlabel('time');
    ylabel('height above soil level [m]');

    legend('show', 'Location', 'southeast');
    grid('on');
    
    hold off;
    
end

