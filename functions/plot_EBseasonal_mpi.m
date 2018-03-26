function fig = plot_EBseasonal_mpi(RESULTS, number_of_realizations , startDate, endDate, ymin, ymax )

    ts = RESULTS{1}.OUT.timestamp();
    
    [~, startIndex] = min( abs( ts - startDate ) );
    [~, endIndex] = min( abs( ts- endDate ) );

    dt = ts(2)-ts(1);

    fig=figure('visible','off');
    hold on;
    
    area = {};
    Q_net = {};
    Q_h = {};
    Q_e = {};
    Q_g = {};
    
    areaTot=0;
    for i=1:number_of_realizations
        area{i} = RESULTS{i}.PARA.location.area;
        areaTot = areaTot+area{i};
        Q_net{i} = cumsum( RESULTS{i}.OUT.EB.Qnet ( startIndex:endIndex ) .* dt .*24 .*3600 );
        Q_h{i} = cumsum( RESULTS{i}.OUT.EB.Qh( startIndex:endIndex ) .* dt .* 24 .*3600 );
        Q_e{i} = cumsum( RESULTS{i}.OUT.EB.Qe ( startIndex:endIndex ) .* dt .* 24 .* 3600 );
        Q_g{i} = cumsum( RESULTS{i}.OUT.EB.Qg ( startIndex:endIndex ) .* dt .* 24 .* 3600 );
    end
    
    
    Q_net{number_of_realizations+1} = Q_net{1}.*area{1}./areaTot;
    Q_h{number_of_realizations+1} = Q_h{1}.*area{1}./areaTot;
    Q_e{number_of_realizations+1} = Q_e{1}.*area{1}./areaTot;
    Q_g{number_of_realizations+1} = Q_g{1}.*area{1}./areaTot;

    for i=2:number_of_realizations
        Q_net{number_of_realizations+1} = Q_net{number_of_realizations+1} + Q_net{i}.*area{i}./areaTot;
        Q_h{number_of_realizations+1} = Q_h{number_of_realizations+1} + Q_h{i}.*area{i}./areaTot;
        Q_e{number_of_realizations+1} = Q_e{number_of_realizations+1} + Q_e{i}.*area{i}./areaTot;
        Q_g{number_of_realizations+1} = Q_g{number_of_realizations+1} + Q_g{i}.*area{i}./areaTot;

    end
        
    y = [  Q_net{1}(end);...
           Q_h{1}(end); ...
           Q_e{1}(end); ...
           Q_g{1}(end) ];
    for i=2:number_of_realizations+1
        y = [ y, [  Q_net{i}(end);...
                    Q_h{i}(end); ...
                    Q_e{i}(end); ...
                    Q_g{i}(end) ] ];
    end
    y = y ./ (endDate-startDate) ./ (3600*24);
    

    %c = { 'g'; 'b'; 'r'; 'c'; 'm'; 'b'};
    bar( y );
    legend( 'C', 'R', 'T', 'mean' );

    xlabels = { 'Qnet', 'Qh', 'Qe', 'Qg' };  
    set(gca,'xticklabel',xlabels, 'xtick',1:numel(xlabels));
    
    ylim( [ ymin, ymax] );
    
    title( [ 'Energy balance from ' datestr(startDate) ' to ' datestr(endDate) ] );
    ylabel( 'Mean fluxes [W/m^2]' );
    

    
    %ylim(max(abs(ax.YLim)).*[-1 1])
%     
%     bowenRatio = Q_h(end)./Q_e(end);
%     text( 0, -10, sprintf( 'Bowen ratio = %0.2f', bowenRatio ) );
%     
    
    grid('on');
    
    
    
    hold off;

end