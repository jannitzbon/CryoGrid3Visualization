function fig = plot_EB_withData( OUT, PARA, startDate, endDate )

    year = str2double(datestr(startDate, 'yyyy'));
    
    ts = OUT.timestamp();
    [~, startIndex] = min( abs( ts - startDate ) );
    [~, endIndex] = min( abs( ts- endDate ) );

    dt = OUT.timestamp(2)-OUT.timestamp(1);

    % water balance
    fig=figure('visible','on');
    hold on;
        
    Q_net = cumsum( OUT.EB.Qnet ( startIndex:endIndex ) .* dt .*24 .*3600 );
    Q_h = cumsum( OUT.EB.Qh( startIndex:endIndex ) .* dt .* 24 .*3600 );
    Q_e = cumsum( OUT.EB.Qe ( startIndex:endIndex ) .* dt .* 24 .* 3600 );
    Q_g = cumsum( OUT.EB.Qg ( startIndex:endIndex ) .* dt .* 24 .* 3600 );
    Q_geo = cumsum( OUT.EB.Qgeo ( startIndex:endIndex ) .* dt .* 24 .* 3600 );
    Q_lateral = cumsum( OUT.EB.Q_lateral ( startIndex:endIndex ) .* dt .* 24 .* 3600 )';
    DE_soilsens = cumsum( OUT.EB.dE_soil_sens ( startIndex:endIndex ) );
    DE_soillat = cumsum( OUT.EB.dE_soil_lat ( startIndex:endIndex ) );
    DE_snowsens = cumsum( OUT.EB.dE_snow_sens ( startIndex:endIndex ) );
    DE_snowlat = cumsum( OUT.EB.dE_snow_lat ( startIndex:endIndex ) );

    dp_rain = OUT.WB.dp_rain(  startIndex:endIndex );
    de = OUT.WB.de( startIndex:endIndex );
    ds = OUT.WB.ds( startIndex:endIndex );
    dr_surface = OUT.WB.dr_surface( startIndex:endIndex );
    dr_external = OUT.WB.dr_external( startIndex:endIndex );
    dr_lateral = OUT.WB.dr_lateral( startIndex:endIndex );
    DE_Qevaporation = cumsum( de ./ 1000 .* PARA.constants.L_sl .* PARA.constants.rho_w );
    %DE_Qsublimation = cumsum( ds ./ 1000. * PARA.constants.L_sl .* PARA.constants.rho_w );
    DE_liquidRunoff = cumsum ( (dr_surface + dr_external + dr_lateral) ./ 1000 .* PARA.constants.L_sl .* PARA.constants.rho_w );
    DE_rain = cumsum( dp_rain ./ 1000 .* PARA.constants.L_sl .* PARA.constants.rho_w );
    DE_Q_WB = DE_rain+DE_liquidRunoff+DE_Qevaporation;
    
    
    C = (DE_soilsens+DE_soillat+DE_snowsens+DE_snowlat) - (Q_g+Q_geo+Q_lateral+DE_Q_WB);
    
    y = [  Q_net(end),...
           Q_h(end), ...
           Q_e(end), ...
           Q_g(end), ...
           Q_geo(end), ...
           Q_lateral(end), ...
           DE_soilsens(end), ...
           DE_soillat(end), ...
           DE_snowsens(end), ...
           DE_snowlat(end), ...
           DE_Q_WB(end), ...
           C(end)];

    y = y ./ (endDate-startDate) ./ (3600*24); % now in W/m^2
    
    if year == 2007
        y = [ y ; [ 81.0, 14.0, 40.0, 15.0, 0. , 0. , 0., 0., 0., 0., 0., 12.0 ] ];
    elseif year == 2008
        y = [ y ; [ 104.0, 22.0, 44.0, 20.0, 0. , 0., 0., 0., 0., 0., 0., 18.0 ] ];
    end
    y = y';
    
    title( [ 'Energy balance from ' datestr(startDate) ' to ' datestr(endDate) ] );
    ylabel( 'Mean fluxes [W/m^2]' );
    xlabels = { 'Qnet', 'Qh', 'Qe', 'Qg', 'Qgeo', 'Qlateral', 'dEsoilsens', 'dEsoillat', 'dEsnowsens', 'dEsnowlat', 'dEWBlat', 'C'};  
    %c = { 'g'; 'b'; 'r'; 'c'; 'm'; 'b'};
    bar( y );
    ax=gca;
    set(ax,'xticklabel',xlabels, 'xtick',1:numel(xlabels));
    ylim(max(abs(ax.YLim)).*[-1 1])
    
    bowenRatio = Q_h(end)./Q_e(end);
    text( 0, -10, sprintf( 'Bowen ratio model = %0.2f', bowenRatio ) );
    text( 0, -20, sprintf( 'Bowen ratio data = %0.2f', y(2,2)./y(3,2) ) );
    
    grid('on');
    
    
    
    hold off;

end