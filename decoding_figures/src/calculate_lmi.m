function [lmi] = calculate_lmi(x, profiles)
    [gel, p_g_x] = conditional_distribution(profiles);
    L = x(end);
    p_x = 1/L; % assumed uniform
    p_g = trapz(x, p_g_x * p_x, 1);
    p_x_g = p_g_x .* p_x ./ p_g; % bayes rule
    integrand = p_x_g .* log2(p_g_x./p_g);
    integrand(p_x_g==0) = 0;
    gene_lmi = p_g_x .* trapz(x, integrand);
    lmi = trapz(gel, gene_lmi,2);