function plot_decoding_map(X, Y, maps, name)
    figure;
    mean_map = nanmean(cat(3, maps{:}), 3);
    colormap(flipud(gray));
    pcolor(X, Y, mean_map); shading flat; colorbar;
    title('Decoding Map');
    xlabel('Actual $x$', 'Interpreter', 'latex');
    ylabel('Implied $x$', 'Interpreter', 'latex');
    set(gca(), ...
    'XGrid','on', ...
    'YGrid','on', ...
    "GridColor", 'none', ...
    'Layer','top', ...
    'TickDir','in', ...
    'TickLength',[0.05 0.05])
    clim([0,18])
    % saveas(gcf, "media/" + name +  "_decoding_map.fig"); % save with numbers
    % % clean up
    % set(gca,'LineWidth',3)
    % set(gca,'XTickLabel',[], 'YTickLabel', [])
    % set(gca,'XLabel',[], 'YLabel', [])
    % set(gca,'Title',[])
    % c = colorbar;
    % % Erase the colorbar tick labels
    % c.TickLabels = [];
    % c.LineWidth = 3;
    % c.Ticks = [0 4 8 12];
    % set(gca,'XGrid','on')
    % set(gca,'YGrid','on')
    % set(gca,'GridColor','none')
    % set(gca,'Layer','top')
    % set(gca,'TickDir','in','TickLength',[0.01 0.05])
    % axis equal;
    % xlim([0,0.8])
    % clim([0,16])
    % saveas(gcf, "media/" + name +  "_decoding_map_clean.tiff"); % print here actually tries to print for me
end
