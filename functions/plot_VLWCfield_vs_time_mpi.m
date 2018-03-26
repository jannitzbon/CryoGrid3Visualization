function fig = plot_VLWCfield_vs_time_mpi(RESULTS, number_of_realizations)

    ts = RESULTS{1}.OUT.timestamp();
    LWCs = {};
    zs = {};
    
    for i=1:number_of_realizations
        LWCs{i} = RESULTS{i}.OUT.liquidWater();
        zs{i} = RESULTS{i}.PARA.location.initial_altitude-RESULTS{i}.GRID.general.cT_grid; 
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
    
    
    for i=1:number_of_realizations
        % limits
        minz = min(RESULTS{i}.OUT.location.altitude - 3);
        maxz = max(RESULTS{i}.OUT.location.altitude + 1);

        pcolor( ax{i}, ts', zs{i}', LWCs{i});
        shading( ax{i}, 'flat' );

        % colormap and colorbar
        caxis(ax{i}, [ 0, 1] );
        colormap(ax{i}, 'parula');
        colormap(ax{i}, flipud(colormap));
        cbar=colorbar(ax{i},'location','westoutside');
        % layout
        axis(ax{i}, [ ts(1) ts(end) minz maxz ] );
        datetick(ax{i},'x','mmm');%, 'keepticks'); 
        xlabel(ax{i},'time')
        ylabel(ax{i},'$z$ [m]', 'Interpreter', 'latex');
        xlabel(cbar, '$T$ [$^\circ$C]', 'Interpreter', 'latex');
        grid(ax{i},'on');
    end
    
    