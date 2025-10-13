clear all;
profile = load('data/pMadV.mat').pMadV  ;
nx = size(profile,2);
x = linspace(0,nx/50,nx);
L = x(end);
d_map = calculate_expected_posterior(x, profile);
rd = calculate_renyi_divergence(x, profile);
lmi = calculate_lmi(x, profile);
w_lmi = L./(2.^lmi) /2;

figure;
[X,Y] = meshgrid(x,x);
pcolor(X,Y,d_map); shading flat; hold on;     colormap(flipud(gray));;
d_map_mean = trapz(x,d_map.*x,2);
plot(x, d_map_mean-L./rd/2, color="k",linewidth=2);
plot(x, d_map_mean+L./rd/2, color="k",linewidth=2);
plot(x, d_map_mean-w_lmi, color="r",linewidth=2);
plot(x, d_map_mean+w_lmi, color="r",linewidth=2);