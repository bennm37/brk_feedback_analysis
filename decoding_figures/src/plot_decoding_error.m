function plot_decoding_error(X, Y, maps, name)
    % Full three panel plot of decoding error
    x = X(1, :);

    [mus, sigmas] = calculate_maximum_likelihood(X, maps);
    % fname = "data/" + lower(name) + "_positional_error.mat";
    % save(fname, "mus", "sigmas", "X", "Y", "maps")
    mus_mean = nanmean(mus, 1);
    sigmas_mean = nanmean(sigmas, 1);
    sigmas_std = nanstd(sigmas, 1);
    
    fig = figure;
    t = tiledlayout(2, 2, 'TileSpacing', 'compact');
    
    % First subplot
    nexttile(t, 1);
    mean_map = mean(cat(3, maps{:}), 3);
    pcolor(X, Y, mean_map);
    shading interp;
    colormap(flipud(gray));
    colorbar;
    xlabel('Actual x/L');
    ylabel('Implied x/L');
    
    % Second subplot
    nexttile(t, 2);
    errorbar(x, mus_mean, sigmas_mean, 'o');
    xlabel('Actual x/L');
    ylabel('Implied x/L');
    

    % Third subplot - this will probably be the one you and inset?
    nexttile(t, [1 2]);
    correction = 40 * size(X, 1) / 50;
    plot(x,sigmas_mean*correction, Color="red")
    hold on;
    errorbar(x, sigmas_mean * correction, sigmas_std * correction, '.-', Color="red");
    yline(1, '--k', 'Single cell precision');
    legend('std of \sigma_x');
    title('Standard Deviation Implied x');
    xlabel('Actual x/L');
    ylabel('\sigma(x/L) (cd)');
    ylim([0, 10]);
    
    sgtitle(['Decoding Error ', name]);
    
    saveas(fig, "media/" + lower(name)+"_decoding_error.pdf");
    % close(fig);
end
