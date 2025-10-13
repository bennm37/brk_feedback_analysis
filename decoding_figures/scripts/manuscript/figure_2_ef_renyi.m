clear all
%% Loading Data
brkv = load("data/BrkV.mat").BrkV;
brkd = load("data/BrkD.mat").BrkD;
pmadv = load("data/pMadV.mat").pMadV;
pmadd = load("data/pMadD.mat").pMadD;
x = linspace(0,size(brkv,2)/50,size(brkv,2)); % assumes all the same size
red = [202,83,44]/255;
blue = [44,104,164]/255;
%% pMadV vs pMadD: 2E
f = figure;
rd = calculate_renyi_divergence(x, pmadd);
bootfun = @(p) calculate_renyi_divergence(x, p);
rd_cis = bootci(100, bootfun, pmadd); 
plot_cis(x, log2(rd), log2(rd_cis), red);
hold on;
rd = calculate_renyi_divergence(x, pmadv);
bootfun = @(p) calculate_renyi_divergence(x, p);
rd_cis = bootci(100, bootfun, pmadv);  
plot_cis(x, log2(rd), log2(rd_cis), blue);
ax=gca;ax.LineWidth=3;
pbaspect([2 1 1])
% set(gca,'XTick',[0.2,0.4,0.6,0.8], 'YTick', [0,1,2,3])
ylabel("log2 RD"); xlabel("x");
xlim([0,0.8]);
f.Position(3:4) = [400,200];
% saveas(gcf, "media/figure_2/2e_renyi.fig")
% clean()
% exportgraphics(gcf, "media/figure_2/2e_renyi_clean.tiff")
%% BrkV vs BrkD: 2F
f = figure;
rd = calculate_renyi_divergence(x, brkd);
bootfun = @(p) calculate_renyi_divergence(x, p);
rd_cis = bootci(100, bootfun, brkd); 
plot_cis(x, log2(rd), log2(rd_cis), red);

rd = calculate_renyi_divergence(x, brkv);
bootfun = @(p) calculate_renyi_divergence(x, p);
rd_cis = bootci(100, bootfun, brkv); 
plot_cis(x, log2(rd), log2(rd_cis), blue);
ax=gca;ax.LineWidth=3;
pbaspect([2 1 1])
set(gca,'XTick',[0.2,0.4,0.6,0.8], 'YTick', [0,1,2,3])
ylabel("log2 RD (bits)"); xlabel("x");
xlim([0,0.8]);
f.Position(3:4) = [400,200];
% saveas(gcf, "media/figure_2/2f_renyi.fig")
% clean()
% exportgraphics(gcf, "media/figure_2/2f_renyi_clean.tiff")

%% Control Combo: 2K
step = 1;
f = figure;
% [~,~,lmi_v, lmi_cis_v] = plot_lmi(x, cat(3,pmadv,brkv), blue);
% save("data/lmi_v.mat","lmi_cis_v", "lmi_v")
load("data/lmi_v.mat")
L = abs(lmi_v-lmi_cis_v(1,:)'); U = abs(lmi_cis_v(2,:)'-lmi_v);
line = plot(x, lmi_v, "LineWidth",3, Color=blue); hold on;
errors = errorbar(x(1:step:end), lmi_v(1:step:end), L(1:step:end), U(1:step:end), "o", "LineWidth",3, Color=blue);
xlabel('x/L');
ylabel('PID (bits)');
ax=gca;ax.LineWidth=3;
pbaspect([2 1 1])
set(gca,'XTick',[0.2,0.4,0.6,0.8], 'YTick', [0,1,2,3])
ylabel("LMI (bits)"); xlabel("x");
xlim([0,0.8]);
f.Position(3:4) = [400,200];
saveas(gcf, "media/figure_2/2k.fig")
clean()
exportgraphics(gcf, "media/figure_2/2k_clean.tiff")

%% Mut Combo: 2L
% [lmi_d, lmi_cis_d] = bootstrap_lmi(x, cat(3,pmadd,brkd));
% save("data/lmi_d.mat","lmi_cis_d", "lmi_d")
load("data/lmi_d.mat")
f = figure;
[line, errors] = plot_cis(x, lmi_d, lmi_cis_d, red);
ylim([0, max(max(lmi_cis_v))])
pbaspect([2 1 1])
set(gca,'XTick',[0.2,0.4,0.6,0.8], 'YTick', [0,1,2,3])
ylabel("LMI (bits)"); xlabel("x");
xlim([0,0.8]);
f.Position(3:4) = [400,200];
saveas(gcf, "media/figure_2/2l.fig")
clean()
exportgraphics(gcf, "media/figure_2/2l_clean.tiff")


function clean()
    lgd = findobj('type', 'legend');
    delete(lgd)
    set(gca,'XTickLabel',[], 'YTickLabel', [],"XLabel",[],"YLabel",[]) 
end


