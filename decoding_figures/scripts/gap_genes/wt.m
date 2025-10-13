clear all;
[Kni, Kr, Gt, Hb] = load_gg("data/gregor_data/Gap/gap_data_raw_dorsal_wt.mat");
[x, profiles] = clean(Kr); name="Kr";

%% Calculate
distribution = calculate_expected_posterior(x, profiles);
[X,Y] = meshgrid(x,x);
hpdr = calculate_hpdr(x, distribution, 0.05);
%% Figures
f=figure; f.Position = [100 100 400 300];
colormap(flipud(gray)); pcolor(X,Y,distribution); shading flat;
colorbar; xlabel("x"); ylabel("x^*");
title("Posterior Distribution");
saveas(f, sprintf("media/gap_gene/%s_posterior.pdf", name))

f=figure; f.Position = [100 100 400 300];
colormap(flipud(gray)); pcolor(X,Y,hpdr); shading flat;
colorbar; clim([0,1]); xlabel("x"); ylabel("x^*");
title("High Posterior Density Region");
saveas(f, sprintf("media/gap_gene/%s_hpdr.pdf", name))

f=figure; f.Position = [100 100 400 300];
areas = get_areas(hpdr');
area(areas);
xlabel("x"); ylabel("HPDR Width");
title("HPDR Sandchart");
saveas(f, sprintf("media/gap_gene/%s_hpdr_sandchart.pdf", name))

%% plot all
[n, nx] = size(Kni);
x = linspace(0,1,nx);
shadedErrorBar(x, nanmean(Kni), nanstd(Kni),'lineprops',{'-.'}); hold on;
shadedErrorBar(x, nanmean(Kr), nanstd(Kr),'lineprops',{'-.'});
shadedErrorBar(x, nanmean(Gt), nanstd(Gt),'lineprops',{'-.'});
shadedErrorBar(x, nanmean(Hb), nanstd(Hb),'lineprops',{'-.'});
legend(["Kni","Kr","Gt","Hb"])