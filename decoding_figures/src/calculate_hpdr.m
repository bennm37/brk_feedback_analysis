function [hpdr, true_density, all_densities] = calculate_hpdr(x, posterior, alpha)
    [~, nx] = size(x);
    hpdr = zeros(size(posterior));
    true_density = zeros([nx,1]);
    all_densities = zeros(nx);
    for i=1:nx
        dist = posterior(:,i);
        levels = flip(sort(dist));
        densities = zeros([nx,1]);
        for j=1:nx
            densities(j) = thresholded_density(x, dist, levels(j));
            all_densities(i,j) = thresholded_density(x, dist, levels(j));
        end
        [diff, k] = min(abs(densities-(1-alpha)));
        level = levels(k);
        hpdr(i, dist>=level) = 1;
        true_density(i) = diff+(1-alpha);
    end

function d = thresholded_density(x, dist, thresh)
    dist(dist<thresh) = 0;
    d = trapz(x, dist);