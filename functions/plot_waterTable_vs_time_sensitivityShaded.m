function fig = plot_waterTable_vs_time_sensitivityShaded( OUT1 , OUT2, PARA1, PARA2 )

ts1 = OUT1.timestamp();
water_table1 = OUT1.location.water_table_altitude()- PARA1.location.soil_altitude();
water_table2 = OUT2.location.water_table_altitude()- PARA2.location.soil_altitude();
available_data = ~isnan(water_table1) & ~isnan(water_table2);
water_table1 = water_table1( available_data );
water_table2 = water_table2( available_data );
ts1red = ts1( available_data );
try
    soil_level1 = OUT1.location.soil_altitude() - PARA1.location.initial_altitude;
    soil_level2 = OUT2.location.soil_altitude() - PARA2.location.initial_altitude;
    
catch
    soil_level1 = nanmin( OUT1.soil.topPosition, OUT1.soil.lakeFloor) ;
    soil_level2 = nanmin( OUT2.soil.topPosition, OUT2.soil.lakeFloor) ;
end

fig=figure('visible','on');
hold on;
%area( ts1, [ water_table1, water_table2-water_table1 ], 'LineWidth', 2, 'DisplayName', 'water table range' );% 'Color', [176 196 222]./255,
%area( ts1, water_table2, 'LineWidth', 2, 'DisplayName', 'water table 2' );% 'Color', [176 196 222]./255,
f=fill( [ts1red; flip(ts1red)],  [min(water_table1, water_table2); flip( max(water_table1, water_table2) )], 'b', 'DisplayName', 'Model spread' );
if ~isempty(f)
    f.FaceColor = [176 196 222]./255;
    f.FaceAlpha = 1.0;
    f.EdgeColor = 'none';
end
hold on;

ax = gca;
ax.ColorOrderIndex = 2; % reset color order

plot( ts1, soil_level1, 'LineWidth', 2, 'DisplayName', 'soil level' );% 'Color', [210 180 140]./255,
%plot( ts1, soil_level2, 'LineWidth', 2, 'DisplayName', 'soil level 2' );% 'Color', [210 180 140]./255,


axis( [ ts1(1) ts1(end) -0.2 0.2 ] );
%ax=gca;
%ax.XTick = linspace(ts(1), ts(end), 13);
datetick('x','mmm');
xlabel('time');
ylabel('height above soil level [m]');

%egend('show', 'Location', 'southeast');
grid('on');

hold off;

end

