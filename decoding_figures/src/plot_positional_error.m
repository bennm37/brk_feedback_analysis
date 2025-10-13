function [line] = plot_positional_error(X, Y, maps,varargin)
    if nargin==4
        color = varargin{1};
    else
        color="red";
    end
    x = X(1, :);
    [mus, sigmas] = calculate_maximum_likelihood(X, maps);
    sigmas_mean = nanmean(sigmas, 1);
    sigmas_std = nanstd(sigmas, 1);
    correction = 40 * size(X, 1) / 50; % approx 40 cells along AP axis
    hold on;
    line = errorbar(x, sigmas_mean * correction, sigmas_std * correction, '.-', 'LineWidth',3, Color=color);
    yline(1, '--k');
    xlabel('x/L');
    ylabel('\sigma_p (cd)');
    % ylim([0, 10]);    
end
