clear all
%% Background Subtraction: need data to run
Path = '/Users/huanga/Desktop/Manuscript_2023_June/20230415LSM880-2019/BrkGFP-y_5d-9h_Hoechst_pMad555_WgPtc647/';
FileList = dir(strcat(Path,'*.mat'));
Num = length(FileList);

for n = 1:Num
    load(strcat(Path,FileList(n).name));
    Sum1 = Normalize_axis(Data);
    bdr1=0.2; bdr2=0.5; %[0.1 0.3]for pMad and I-O relation average; [0.2 0.5]for brk and I-O relation individual [0.1 0.5]for testing relation
    Pos1 = find(Sum1(:,2)>-bdr2 & Sum1(:,2)<-bdr1);
    Pos2 = find(Sum1(:,2)>bdr1 & Sum1(:,2)<bdr2);
    Sum_V = Sum1(Pos1,:);
    Sum_D = Sum1(Pos2,:);
    for i = 1:100
        PosiV = find(Sum_V(:,1)>-1+(i-1)*0.02&Sum_V(:,1)<-1+i*0.02);
        Mean1V(n,i) = nanmean(Sum_V(PosiV,3));
        Std1V(n,i) = nanstd(Sum_V(PosiV,3));
        Mean2V(n,i) = nanmean(Sum_V(PosiV,4));
        Std2V(n,i) = nanstd(Sum_V(PosiV,4));
        PosiD = find(Sum_D(:,1)>-1+(i-1)*0.02&Sum_D(:,1)<-1+i*0.02);
        Mean1D(n,i) = nanmean(Sum_D(PosiD,3));
        Std1D(n,i) = nanstd(Sum_D(PosiD,3));
        Mean2D(n,i) = nanmean(Sum_D(PosiD,4));
        Std2D(n,i) = nanstd(Sum_D(PosiD,4));
    end
    Bkg1 = mean(mink(Mean1V(n,:),5));
    Bkg2 = mean(mink(Mean2V(n,:),20));
    %Pk1 = mean(Mean1D(n,76:85));
    %Pk2 = mean(maxk(Mean2V(n,:),3));
    Mean1V(n,:) = Mean1V(n,:)-Bkg1;
    Mean1V(n,:) = Mean1V(n,:);%./Pk1;
    Mean1D(n,:) = Mean1D(n,:)-Bkg1;
    Mean1D(n,:) = Mean1D(n,:);%./Pk1;
    Mean2V(n,:) = Mean2V(n,:)-Bkg2;
    Mean2V(n,:) = Mean2V(n,:);%./Pk2;
    Mean2D(n,:) = Mean2D(n,:)-Bkg2;
    Mean2D(n,:) = Mean2D(n,:);%./Pk2;    
end
pmadWT = Mean1V(:,51:90);
brkWT = Mean2V(:,51:90); % these are the saved datasets you sent?
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
[line, errors] = plot_lmi(x, pmad, "k");
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

