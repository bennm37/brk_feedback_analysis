function [X,Y,maps] = construct_decoding_maps(x, profiles)
    [nr,nx,ng] = size(profiles);
    means = nanmean(profiles, 1);
    covs = cell(nx,1);
    for i=1:nx
        covs{i} = nancov(reshape(profiles(:,i,:), [nr,ng]),1);
    end
    maps = cell(nr, 1);
    for r=1:nr
        map = zeros(nx,nx);
        for i=1:nx %iterating over x*
            if covs{i}==0
                delta = zeros([nx,ng]);
                [~, pos] = min(x-means);
                delta(pos) = 1; 
                map(i,:) = delta/trapz(x,delta);
            else
                map(i,:) = mvnpdf(reshape(profiles(r,:,:),[nx,ng]), reshape(means(:,i,:),[1,ng]), covs{i});
            end
        end
        for j=1:nx %iterating over x to normalize
            map(:,j) = map(:,j)/trapz(x,map(:,j));
        end
        maps{r} = map;
    end
    [X, Y] = meshgrid(x, x);
end

function [X,Y,map] = construct_decoding_map(x, profiles)
    [gel, p_g_x] = conditional_distribution(profiles);
    L = x(end);
    p_x = 1/L; % assumed uniform
    p_g = trapz(x, p_g_x * p_x, 1);
    p_x_g = p_g_x .* p_x ./ p_g; % bayes rule
    map = reshape(trapz(gel, p_g_x .* permute(p_x_g, [3,2,1]), 2), nx, nx);
    [X, Y] = meshgrid(x, x);
end