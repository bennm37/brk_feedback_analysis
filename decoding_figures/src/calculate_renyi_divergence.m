function [rd] = calculate_renyi_divergence(x, profiles)
    [gel, p_g_x] = conditional_distribution(profiles);
    L = x(end);
    p_x = 1/L; % assumed uniform
    p_g = trapz(x, p_g_x * p_x, 1);
    p_x_g = p_g_x .* p_x ./ p_g; % bayes rule
    rd = trapz(gel, p_g_x .*trapz(x, p_x_g .* p_x_g ./ p_x), 2);