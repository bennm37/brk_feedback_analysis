function [distribution] = calculate_expected_posterior(x, profiles)
    nx = size(x,2);
    n_gel = 1000;
    [gel, p_g_x] = conditional_distribution(profiles, n_gel);
    L = x(end)-x(1);
    p_x = 1/L; % assumed uniform
    p_g = trapz(x, p_g_x * p_x, 1);
    p_x_g = p_g_x .* p_x ./ p_g; % bayes rule
    distribution = zeros([nx,nx]);
    for i=1:nx
        distribution(:,i) = trapz(gel, p_g_x .* p_x_g(i,:), 2);
    end