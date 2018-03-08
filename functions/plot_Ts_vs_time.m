function fig = plot_Ts_vs_time( OUT, GRID, PARA, requestedDepths )
    ts = OUT.timestamp();
    Ts = OUT.cryoGrid3();
    
    fig=figure('visible','off');
    for requestedDepth=requestedDepths
    
        % get the altitude of the uppermost soil cell (which indeed contains
        % mineral or organic material, i.e. excluding a potential waterbody)
        try
            soil_surface_altitude = OUT.location.soil_altitude;
        catch 
        	soil_surface_altitude = nanmin( OUT.soil.topPosition, OUT.soil.lakeFloor) + PARA.location.initial_altitude;
        end
        % the static altitude grid
        altitude_grid = PARA.location.initial_altitude-GRID.general.cT_grid;        


        % compute the index of the requested cell for each timestep
        A = zeros( length(altitude_grid), length(soil_surface_altitude) );   % matrix to serach in
        for j=1:size(A,2)   %loop over all timesteps       
            A(:,j) = soil_surface_altitude(j)- altitude_grid;      % distance of each grid cell (first dim) to the surface for each timestep (second dim)
        end   
        [~, indexes] = min( abs( A - requestedDepth ) );    % determine index of closest cell to the requested depth

        % transform column-wise index to linear index of whole matrix
        linindexes = sub2ind( [length(altitude_grid),length(ts)], indexes, [1:1:length(ts)] );

        plot( ts, Ts(linindexes), 'LineWidth', 2, 'DisplayName', sprintf('z=%0.2f', [requestedDepth]) );
        hold on;
    end
    
    
    ax=gca;
    axis( [ ts(1) ts(end) -40 20 ] );
    ax.YTick = linspace( -40, 20, 7 );
    %ax.XTick = linspace(ts(1), ts(end), 13);
    datetick('x','mmm');%, 'keepticks'); 
    
    xlabel('time');
    ylabel('T [°C]');
    
    legend('show');
    grid('on');

    hold off;
    
end

