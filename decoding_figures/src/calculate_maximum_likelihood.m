function [mus, sigmas] = calculate_maximum_likelihood(X, maps)
    n_x = size(X, 2);
    n_maps = size(maps, 1);
    x = X(1, :);
    mus = NaN(n_maps, n_x);
    sigmas = NaN(n_maps, n_x);
    for i = 1:n_maps
        map = maps{i};
        for j = 1:n_x
            col = map(:,j).';
            [~, max_ind] = max(col);
            m = x(max_ind);
            if isnan(m)
                s=NaN;
            else
                s = sqrt(trapz(x,(x - m).^2 .* col) / sum(col));
            end
            mus(i, j) = m;
            sigmas(i, j) = sqrt(s);
        end
    end
end
