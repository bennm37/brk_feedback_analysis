clear all
%% Background Subtraction: need data to run
Path = '/Users/huanga/Desktop/Manuscript_2024_Mar/Figures/Update_2024Jun/Figure2/brkKO-BrkV5np-Flp_apG_4dAEL_Hoechst_pMad488_WgPtc647/';
FileList = dir(strcat(Path,'*.mat'));
Num = length(FileList);
for n = 1:Num
    load(strcat(Path,FileList(n).name));
    Sum1 = Normalize_axis(Data);
    bdr1=0.1; bdr2=0.3; %[0.1 0.3]for pMad and I-O relation average; [0.2 0.5]for brk and I-O relation individual [0.1 0.5]for testing relation
    Pos1 = find(Sum1(:,2)>-bdr2 & Sum1(:,2)<-bdr1);
    Pos2 = find(Sum1(:,2)>bdr1 & Sum1(:,2)<bdr2);
    Sum_V = Sum1(Pos1,:);
    Sum_D = Sum1(Pos2,:);
    for i = 1:100
        PosiV = find(Sum_V(:,1)>-0.99+(i-1)*0.02&Sum_V(:,1)<-0.99+i*0.02);
        Mean1V(n,i) = nanmean(Sum_V(PosiV,3));
        Std1V(n,i) = nanstd(Sum_V(PosiV,3));
        Mean2V(n,i) = nanmean(Sum_V(PosiV,4));
        Std2V(n,i) = nanstd(Sum_V(PosiV,4));
        PosiD = find(Sum_D(:,1)>-0.99+(i-1)*0.02&Sum_D(:,1)<-0.99+i*0.02);
        Mean1D(n,i) = nanmean(Sum_D(PosiD,3));
        Std1D(n,i) = nanstd(Sum_D(PosiD,3));
        Mean2D(n,i) = nanmean(Sum_D(PosiD,4));
        Std2D(n,i) = nanstd(Sum_D(PosiD,4));
    end
    Bkg1 = mean(mink(Mean1V(n,:),5));
    Bkg2 = mean(mink(Mean2D(n,:),5));
    Pk1 = mean(Mean1D(n,76:85));
    Pk2 = mean(maxk(Mean2V(n,:),3));
    Mean1V(n,:) = Mean1V(n,:)-Bkg1;
    Mean1V(n,:) = Mean1V(n,:)./Pk1;
    Mean1D(n,:) = Mean1D(n,:)-Bkg1;
    Mean1D(n,:) = Mean1D(n,:)./Pk1;
    Mean2V(n,:) = Mean2V(n,:)-Bkg2;
    Mean2V(n,:) = Mean2V(n,:)./Pk2;
    Mean2D(n,:) = Mean2D(n,:)-Bkg2;
    Mean2D(n,:) = Mean2D(n,:)./Pk2;    
end
data1 = Mean1V(:,51:90);
data2 = Mean1D(:,51:90);
data3 = Mean2V(:,51:90);
data4 = Mean2D(:,51:90);
% this is then saved to produce the profiles in data?

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
[lmi, lmi_cis] = bootstrap_lmi(x, pmadd);
plot_cis(x, lmi, lmi_cis, red);
[lmi, lmi_cis] = bootstrap_lmi(x, pmadv);
plot_cis(x,lmi, lmi_cis, blue);
ax=gca;ax.LineWidth=3;
pbaspect([2 1 1])
set(gca,'XTick',[0.2,0.4,0.6,0.8], 'YTick', [0,1,2,3])
ylabel("LMI (bits)"); xlabel("x");
xlim([0,0.8]);
legend()
f.Position(3:4) = [400,200];
% saveas(gcf, "media/figure_2/2e.fig")
% clean()
% exportgraphics(gcf, "media/figure_2/2e_clean.tiff")
%% BrkV vs BrkD: 2F
f = figure;
[lmi, lmi_cis] = bootstrap_lmi(x, brkd);
plot_cis(x,lmi, lmi_cis, red);
[lmi, lmi_cis] = bootstrap_lmi(x, brkv);
plot_cis(x,lmi, lmi_cis, blue);
ax=gca;ax.LineWidth=3;
pbaspect([2 1 1])
set(gca,'XTick',[0.2,0.4,0.6,0.8], 'YTick', [0,1,2,3])
ylabel("LMI (bits)"); xlabel("x");
xlim([0,0.8]);
legend()
f.Position(3:4) = [400,200];
saveas(gcf, "media/figure_2/2f.fig")
clean()
exportgraphics(gcf, "media/figure_2/2f_clean.tiff")

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


