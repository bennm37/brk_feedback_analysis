%% Loading Data
clear all;
red = [202,83,44]/255;
blue = [44,104,164]/255;
nx = 201;
ns = 10000;
x = linspace(0,1,nx);
k = 4;   
% f = @(x) tanh(k*atanh(x));
% g = @(x) 1/2 * (f(1-2*x)+1);
% g = @(x) exp(-x/k);
% g = @(x) exp(-(x).^2/(2*(2*k)^2));
% g = @(x) exp(-(x-0.5).^2/(2*k^2)); name="normal_dist";
% g = @(x) 1-2*x;
g = @(x) cos(k*pi*x)+1; name="cos";
% g = @(x) x;
g_bar = g(x);
sig_scale = 0.1;
sigmas = sig_scale;
% sigmas = sig_scale * sqrt(g_bar)+0.01;
fname = sprintf("media/%s_k=%d_s=%d", name, k, sig_scale);
mkdir(fname);
data = repmat(g_bar,[ns,1]) + sigmas .* normrnd(0,1,[ns, nx]);
hold off;
err_bar_plot = shadedErrorBar(x, mean(data), std(data),'lineProps',{'r--','markerfacecolor','r'});
xlabel("x")
ylabel("g")
savefig(gcf,sprintf("%s/%s",fname,"schematic"))
[X,Y] = meshgrid(x,x);
distribution = calculate_expected_posterior(x,data);

f2=figure;
colormap(flipud(gray)); pcolor(X,Y,distribution); shading flat;
colorbar; clim([0,40]); xlabel("x"); ylabel("x^*");
savefig(f2,sprintf("%s/%s",fname,"epd"))
%%
lmi = calculate_lmi(x, data);
slmi = 1./2.^lmi;
[hpdr, densities, all_densities] = calculate_hpdr(x, distribution, 0.05);
adjusted=all_densities-0.95;
% figure;
% colormap(flipud(gray)); pcolor(X,Y,all_densities); shading flat;
% hold on;
% xlabel("sorted level"); ylabel("x^*");
f3 = figure;
f3.Position = [100 100 300 450];
ax1=subplot(3,1,[1,2]);
colormap(flipud(gray)); pcolor(X,Y,hpdr); shading flat;
hold on;
xlabel("x"); ylabel("x^*");
axis("equal")
xlim([0,1]);
ax2=subplot(3,1,3);
area(x, get_areas(hpdr));
xlabel("x");
ylabel("intervals");
linkaxes([ax1,ax2],'x')
savefig(f3,sprintf("%s/%s",fname,"sand_chart"))

%% Animation
figure;
l = plot(x, distribution(:, 1), 'LineWidth', 2); hold on;
l2 = plot(x, hpdr(:, 1), 'LineWidth', 2);
for i = 1:nx
    title("i, x = ", [i, i/nx])
    set(l, 'YData', distribution(:, i));
    m = max(distribution(:,i));
    ylim([0,m]);
    set(l2, 'YData', hpdr(:, i)*m/2);
    drawnow;
    pause(0.03);
end
%%
figure;
subplot(2,2,1);
colormap(flipud(gray)); pcolor(X,Y,distribution); shading flat; colorbar;
clim([0,prctile(reshape(distribution,1, []),99.95)]); hold on;
xlabel("x"); ylabel("x^*");
subplot(2,2,2);
colormap(flipud(gray)); pcolor(X,Y,hpdr); shading flat; colorbar;
clim([0,1]); hold on;
plot(x,x, "LineStyle","--","Color","red","LineWidth", 2);
xlabel("x"); ylabel("x^*");

subplot(2,2,[3,4]);
plot(x, sum(hpdr')/nx)
[X, Y, maps] = construct_decoding_maps(x, data);
[mus_ml, sigmas_ml] = calculate_maximum_likelihood(X, maps); hold on;
plot(x,mean(sigmas_ml)*3.92);
plot(x, slmi);
xlabel("x"); ylabel("CI Width");
legend("HPDR", "\sigma^{petk}", "\sigma^{PID}")

%% CI 
outs = [];
for i=150:200
    plot(x,distribution(i,:)); hold on;
    [~,out_first,~] = unique(hpdr(i,:));
    outs = [outs; out_first(2)];
    scatter(out_first/nx,0);
end
%% Sigmas
[nr, nx] = size(data);
[mus_ml, sigmas_ml] = calculate_maximum_likelihood(X, maps);
plot_decoding_map(X,Y,maps, "PI Investigation")
[mus_mse_MAP, sigmas_mse_MAP] = calculate_mse(x, data, "MAP");
sigmas_e_MAP = abs(mus_mse_MAP-x);
sigmas_x_MAP = sqrt(sigmas_mse_MAP.^2 - sigmas_e_MAP.^2);
[mus_mse_MMSE, sigmas_mse_MMSE] = calculate_mse(x, data, "MMSE");
sigmas_e_MMSE = abs(mus_mse_MMSE-x);
sigmas_x_MMSE = sqrt(sigmas_mse_MMSE.^2 - sigmas_e_MMSE.^2);

diff = zeros(nr,nx);
for i=1:nr
    [m,inds] = max(maps{i});
    diff(i,:) = x(inds)-x;
end
sigma_p_empirical = sqrt(mean(diff.^2));

% plot(X(1,:),nanmean(sigmas_mse)); hold on;
f = figure;
subplot(1,2,1)
f.Position(3:4) = [800 210];
n_cells = 1;
ylabel("Positional Error (c.d.)"); xlabel("x");
plot(X(1,:), n_cells*nanmean(sigmas_ml), "DisplayName","\sigma_p^{petk}", "LineWidth",2);  
legend(Location="north west")
subplot(1,2,2)
ylabel("Positional Error (c.d.)"); xlabel("x");
plot(X(1,:),n_cells*nanmean(sigmas_ml), "DisplayName","\sigma_p^{petk}", "LineWidth",2);  
legend(Location="north west")
exportgraphics(gcf, "media/positional_errors.tiff");

% hold off;
% plot(X(1,:), mus_ml); hold on;
% plot(X(1,:), X(1,:), "linestyle","--");

