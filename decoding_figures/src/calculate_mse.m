function [mus, sigmas] = calculate_mse(x, profiles, estimator)
    [nr,nx,ng] = size(profiles);
    assert (ng==1, "Only supports single expression");
    means = nanmean(profiles, 1);
    covs = cell(nx,1);
    for i=1:nx
        covs{i} = nancov(reshape(profiles(:,i,:), [nr,ng]),1);
        if covs{i}==0
            covs{i} = eps
        end
    end
    max_gene = max(max(max(profiles)));
    ng_levels = 10000;
    gene_expression_levels = linspace(0, max_gene, ng_levels);
    distribution = zeros(nx, ng_levels);
    for i=1:nx
        distribution(i, :) = mvnpdf(gene_expression_levels', reshape(means(:,i,:),[1,ng]), covs{i})';
    end
    distribution  = distribution ./ trapz(gene_expression_levels, distribution, 2);
    if estimator=="MAP"
        [~, ind] = max(distribution);
        estimates = x(ind);
    elseif estimator=="MMSE"
        estimates = trapz(x, distribution.*x', 1)./trapz(x, distribution, 1);
    end
    tiled_estimates = repmat(estimates, nx, 1);
    tiled_x = repmat(x', 1, ng_levels);
    mus = trapz(gene_expression_levels, tiled_estimates .* distribution,2)';
    sigmas = sqrt(trapz(gene_expression_levels, (tiled_estimates-tiled_x).^2 .* distribution, 2))';
end

