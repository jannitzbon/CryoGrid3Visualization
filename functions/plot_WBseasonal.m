function fig = plot_WBseasonal( OUT, startDate, endDate )

    ts = OUT.timestamp();
    [~, startIndex] = min( abs( ts - startDate ) );
    [~, endIndex] = min( abs( ts- endDate ) );
    

    % water balance
    fig=figure('visible','off');
    hold on;
    
    DW_soil = cumsum( OUT.WB.dW_soil( startIndex:endIndex ) );
    DW_snow = cumsum( OUT.WB.dW_snow( startIndex:endIndex ) );
    Dp_rain = cumsum( OUT.WB.dp_rain( startIndex:endIndex ) );
    Dp_snow = cumsum( OUT.WB.dp_snow( startIndex:endIndex ) );
    De = cumsum( OUT.WB.de( startIndex:endIndex ) );
    Ds = cumsum( OUT.WB.ds( startIndex:endIndex ) );
    Dr_surface = cumsum( OUT.WB.dr_surface( startIndex:endIndex ) );
    Dr_external = cumsum( OUT.WB.dr_external( startIndex:endIndex ) );
    Dr_snowmelt = cumsum( OUT.WB.dr_snowmelt( startIndex:endIndex ) );
    Dr_excessSnow = cumsum( OUT.WB.dr_excessSnow( startIndex:endIndex ) );
    Dr_lateralSnow = cumsum( OUT.WB.dr_lateralSnow( startIndex:endIndex ) );
    Dr_rain = cumsum( OUT.WB.dr_rain( startIndex:endIndex ) );
    Dr_lateral = cumsum( OUT.WB.dr_lateral( startIndex:endIndex ) );
    Dm_lacking = cumsum( OUT.WB.dm_lacking( startIndex:endIndex ) );
    
    C = (DW_soil + DW_snow) - ( Dp_rain + Dp_snow + De + Ds + Dr_surface + Dr_external + Dr_excessSnow + Dr_lateralSnow + Dr_lateral + Dm_lacking );
 
    y = [  DW_soil(end),...
           DW_snow(end), ...
           Dp_rain(end), ...
           Dp_snow(end), ...
           De(end), ...
           Ds(end), ...
           Dr_surface(end), ...
           Dr_external(end), ... 
           Dr_excessSnow(end), ...
           Dr_lateralSnow(end), ...
           Dr_lateral(end), ...
           Dm_lacking(end), ...
           C(end)];
    %y = y ./ (endDate - startDate); % now in mm / day
    
    x = { 'Wsoil', 'Wsnow', 'prain', 'psnow', 'e', 's', 'rsurface', 'rexternal', 'rexcessSnow', 'rlateralSnow', 'rlateral', 'mlacking', 'C'};
    
    %c = { 'g'; 'b'; 'r'; 'c'; 'm'; 'b'};
    
    title( [ 'Water balance from ' datestr(startDate) ' to ' datestr(endDate) ] );
    ylabel( 'Accumulated fluxes [mm]' );
    

    bar( y );
    ax=gca;
    set(ax,'xticklabel',x, 'xtick',1:numel(x));
    ylim(max(abs(ax.YLim)).*[-1 1])
   % ylim( [ -200150 ]);
    grid('on');
    hold off;

end