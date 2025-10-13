clear all
%% Load Data
pmad = load("data/pMad.mat").pMad;
brk = load("data/Brk.mat").Brk;
x = linspace(0,size(pmad,2)/50,size(pmad,2));
%% pMad profile with inset showing local mutual information
figure(1), 
hold on,
s=shadedErrorBar(x, nanmean(pmad), nanstd(pmad),'lineprops', '-w','patchSaturation',0.5);
s.patch.FaceColor = [0.76 .87 .78];
plot(x, nanmean(pmad),'-','LineWidth',3,'Color',[0.23 0.44 0.34])
set(gca,'FontSize', 20);
ax=gca;ax.LineWidth=3;
xlim([0,.8])
%set(gca,'XTickLabel',[], 'YTickLabel', [])

axes('Position',[.44 .42 .38 .45])
box on
hold on
rd = calculate_renyi_divergence(x, pmad);
bootfun = @(p) calculate_renyi_divergence(x, p);
rd_cis = bootci(100, bootfun, pmad); 
[line, ~] = plot_cis(x, log2(rd), log2(rd_cis), "k");
line.LineWidth = 2;
xticks(0:0.4:0.8)
yticks(0:2:4)
set(gca,'FontSize', 20);
ax1=gca;ax1.LineWidth=2;
xlim([0,.8])
ylim([0,4])
saveas(gcf, "media/figure_1/1f.fig")
clean(ax); clean(ax1);
exportgraphics(gcf, "media/figure_1/1f_clean.tiff")
%% Brk profile with inset local mutual information
figure(2), 
hold on,
s=shadedErrorBar(x,nanmean(brk),nanstd(brk),'lineprops', '-w','patchSaturation',0.5);
s.patch.FaceColor = [0.95 .87 .73];
plot(x,nanmean(brk),'-','LineWidth',3,'Color',[0.75 0 0.75])
set(gca,'FontSize', 20);
ax=gca;ax.LineWidth=3;
xlim([0,.8])
ylim([0 800])
yticks(0:200:800)
%set(gca,'XTickLabel',[], 'YTickLabel', [])

axes('Position',[.25 .42 .38 .45])
box on
hold on
[line, errors] = plot_lmi(x, brk, "k");
line.LineWidth = 2;
xticks(0:0.4:0.8)
yticks(0:2:4)
set(gca,'FontSize', 20);
ax1=gca;ax1.LineWidth=2;
xlim([0,.8])
ylim([0,4])
saveas(gcf, "media/figure_1/1g.fig")
clean(ax); clean(ax1);
exportgraphics(gcf, "media/figure_1/1g_clean.tiff")

function clean(ax)
    lgd = findobj('type', 'legend');
    delete(lgd)
    set(ax,'XTickLabel',[], 'YTickLabel', [],"XLabel",[],"YLabel",[]) 
end

