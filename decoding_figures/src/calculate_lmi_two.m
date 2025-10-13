function [lmi] = calculate_lmi_two(x, profiles)
    [GEL, p_g_x] = conditional_distribution(profiles);
    GEL_1 = GEL(:,:,1); GEL_2 = GEL(:,:,2); 
    gel_1 = GEL_1(1,:); gel_2 = GEL_2(:,1)';
    L = max(x);
    p_x = ones(size(x)) * 1/L; % assumed uniform
    p_g = trapz(x, p_g_x .* p_x', 1);
    p_x_g = p_g_x .* p_x' ./ p_g; % bayes rule
    p_x_g(p_g_x==0) = 0;
    integrand = p_x_g .* log2(p_g_x./p_g);
    integrand(p_x_g==0) = 0; integrand(isinf(integrand)) = 0;
    gene_lmi = p_g_x .* trapz(x, integrand);
    lmi = trapz(gel_1, trapz(gel_2, gene_lmi, 3),2);

