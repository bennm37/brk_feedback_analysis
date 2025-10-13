function [gel, p_g_x] = conditional_distribution(profiles, varargin)
    if nargin==2
        n_gel = varargin{1};
    else
        n_gel = 1000;
    end
    [nr,nx,ng] = size(profiles);
    means = nanmean(profiles, 1);
    covs = cell(nx,1);
    for i=1:nx
        covs{i} = nancov(reshape(profiles(:,i,:), [nr,ng]),1);
    end
    if ng==1
        covs_arr = sort(cell2mat(covs));
        min_gene = min(min(min(profiles)))-5*max(sqrt(covs_arr));
        max_gene = max(max(max(profiles)))+5*max(sqrt(covs_arr));
        % gel = linspace(min_gene, max_gene, n_gel);
        gel = squish(min_gene, max_gene, n_gel, 1e-6);
        p_g_x = zeros(nx, n_gel);
        for i=1:nx
            if covs{i}==0
                delta = zeros([1, n_gel]);
                [~, pos] = min(abs(gel-means(:,i,:)));
                delta(pos) = 1;
                p_g_x(i,:) = delta/trapz(gel,delta');
            else
                p_g_x(i, :) = mvnpdf(gel', reshape(means(:,i,:),[1,ng]), covs{i})';
            end
        end
    elseif ng==2
        covs_arr = cat(3,covs{:});
        covs_arr_1 = sort(reshape(covs_arr(1,1,:),[1,nx]));
        covs_arr_2 = sort(reshape(covs_arr(2,2,:),[1,nx]));
        min_gene_1 = min(min(min(profiles(:,:,1))))-5*max(sqrt(covs_arr_1(1:10)));
        max_gene_1 = max(max(max(profiles(:,:,1))))+5*max(sqrt(covs_arr_1));
        min_gene_2 = min(min(min(profiles(:,:,2))))-5*max(sqrt(covs_arr_2(1:10)));
        max_gene_2 = max(max(max(profiles(:,:,2))))+5*max(sqrt(covs_arr_2));
        gel_1 = linspace(min_gene_1, max_gene_1, n_gel);
        gel_2 = linspace(min_gene_2, max_gene_2, n_gel);
        [GEL_1, GEL_2] = meshgrid(gel_1, gel_2);
        gel = GEL_1;
        gel(:,:,2) = GEL_2;
        p_g_x = zeros(nx, n_gel, n_gel);
        for i=1:nx
            for j=1:n_gel
                g = cat(1,GEL_1(j,:), GEL_2(j,:))';
                p_g_x(i, j, :) = mvnpdf(g, reshape(means(:,i,:),[1,ng]), covs{i})';
            end
        end
    else
        disp("ng greater than 2 is not supported!")
    end

function y=squish(a,b,n,delta)
    if a>0
        y=logspace(a,b,n);
    else
        na = floor(-a/b*n);
        nb = n-na;
        y=flip(-logspace(log10(delta),log10(-a), na));
        y=[y, logspace(log10(delta),log10(b), nb)];
    end

   
    