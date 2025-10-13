function [lmi] = calculate_lmi_diff(x, profiles)
    [gel, p_g_x] = conditional_distribution(profiles);
    L = x(end);
    p_x = 1/L * ones(size(x))'; % assumed uniform
    p_g = trapz(x, p_g_x .* p_x, 1);
    p_x_g = p_g_x .* p_x ./ p_g; % bayes rule
    s_x = -trapz(x, p_x .* log2(p_x));
    int_s_x_g = p_x_g .* log2(p_x_g);
    int_s_x_g(p_x_g==0) = 0;
    s_x_g = -trapz(x, int_s_x_g);
    gene_lmi = p_g_x .* (s_x - s_x_g);
    lmi = trapz(gel, gene_lmi, 2);

