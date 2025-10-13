%% Loading Data
clear all;
brk = load("data/Brk.mat").Brk;
brkv = load("data/BrkV.mat").BrkV;
brkd = load("data/BrkD.mat").BrkD;
pmad = load("data/pMad.mat").pMad;
pmadv = load("data/pMadV.mat").pMadV;
pmadd = load("data/pMadD.mat").pMadD;
x = linspace(0,size(brkv,2)/50,size(brkv,2)); % assumes all the same size
red = [202,83,44]/255;
blue = [44,104,164]/255;


data = pmadd;
[X, Y, maps] = construct_decoding_maps(x, data);
[mus_ml, sigmas_ml] = calculate_maximum_likelihood(X, maps);

[nr, nx] = size(data);


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
n_cells = 40;
plot(X(1,:),n_cells*sigmas_mse_MAP, "DisplayName","\sigma_p^{MAP}", "LineWidth",2); hold on;
plot(X(1,:),n_cells*sigmas_e_MAP, "DisplayName","\sigma_e^{MAP}", "LineWidth",2);
plot(X(1,:),n_cells*sigmas_x_MAP, "DisplayName","\sigma_x^{MAP}", "LineWidth",2);
ylabel("Positional Error (c.d.)"); xlabel("x");
plot(X(1,:), n_cells*nanmean(sigmas_ml), "DisplayName","\sigma_p^{petk}", "LineWidth",2);  
legend(Location="north west")
subplot(1,2,2)
plot(X(1,:),n_cells*sigmas_mse_MMSE, "DisplayName","\sigma_p^{MMSE}", "LineWidth",2); hold on;
plot(X(1,:),n_cells*sigmas_e_MMSE, "DisplayName","\sigma_e^{MMSE}", "LineWidth",2);
plot(X(1,:),n_cells*sigmas_x_MMSE, "DisplayName","\sigma_x^{MMSE}", "LineWidth",2);
ylabel("Positional Error (c.d.)"); xlabel("x");
plot(X(1,:),n_cells*nanmean(sigmas_ml), "DisplayName","\sigma_p^{petk}", "LineWidth",2);  
legend(Location="north west")
exportgraphics(gcf, "media/positional_errors.tiff");

% hold off;
% plot(X(1,:), mus_ml); hold on;
% plot(X(1,:), X(1,:), "linestyle","--");

