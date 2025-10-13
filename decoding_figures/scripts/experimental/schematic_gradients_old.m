figure,
hold on
x = 1:100;
y = exp(-x/18);
plot(x,y,'LineWidth',3,'Color',[0 0.5 0])
ex = 1:5:100;
ey = exp(-ex/18);
er = 0.1*sqrt(ey);
errorbar(ex,ey,er,'LineWidth',3,'Color',[0 0.5 0])
ylim([0,1.05])
ax=gca;ax.LineWidth=3;
set(gca,'XTickLabel',[], 'YTickLabel', [])
set(gca,'XTick',[], 'YTick', [])


%%
clear
x = 1:100;%
y = exp(-x/18);%
figure
% plot(x,y,'LineWidth',3,'Color',[0 0.5 0])
hold on
x_m = 21:50;
y_m = zeros(1,100);
y_m(1:20) = 1;
k = (0.1-1)/(50-21);
b = 1-k*21;
y_m(21:50) = k*x_m+b;
y_m(51:100) = 0.08;
y2 = y;
y2 = y.*y_m;
plot(x,y2,'LineWidth',3,'Color',[0 0.6 0])

ex = 1:5:100;
ey = y2(ex);
er = 0.1*ey./sqrt(ey);
errorbar(ex,ey,er,'LineWidth',3,'Color',[0 0.5 0])
ylim([0,1.05])
ax=gca;ax.LineWidth=3;
set(gca,'XTickLabel',[], 'YTickLabel', [])
set(gca,'XTick',[], 'YTick', [])

axes('Position',[.45 .45 .4 .4])
box on
plot(x,0.1./sqrt(y),'k','LineWidth',3)
ax=gca;ax.LineWidth=3;
set(gca,'XTickLabel',[], 'YTickLabel', [])
set(gca,'XTick',[], 'YTick', [])

%%

clear
x = 1:100;%
y = exp(-x/18);%
figure
%plot(x,y,'LineWidth',3,'Color',[0 0.5 0])
hold on
x_m = 21:50;
y_m = zeros(1,100);
y_m(1:20) = 1;
k = (0.1-1)/(50-21);
b = 1-k*21;
y_m(21:50) = k*x_m+b;
y_m(51:100) = 0.08;
y2 = y;
y2 = y.*y_m;
plot(x,y2,'LineWidth',3,'Color',[0 0.5 0])

ex = 1:5:100;
ey = y2(ex);
er = 0.1*ey./sqrt(ey);
errorbar(ex,ey,er,'LineWidth',3,'Color',[0 0.5 0])
ylim([0,1.05])


z = flip(y);
z2 = flip(y2);
exz = 5:5:100;
ez = flip(ey);
erz = flip(er);
plot(x,z2,'LineWidth',3,'Color',[0.5 0 0])
errorbar(exz,ez,erz,'LineWidth',3,'Color',[0.5 0 0])

ax=gca;ax.LineWidth=3;
set(gca,'XTickLabel',[], 'YTickLabel', [])
set(gca,'XTick',[], 'YTick', [])

CV1 = 0.1./sqrt(y);
CV2 = flip(CV1);
CV_joint = CV1;
CV_joint(51:100) = CV2(51:100);

axes('Position',[.33 .45 .4 .4])
box on
plot(x,CV_joint,'k','LineWidth',3)
ax=gca;ax.LineWidth=3;
set(gca,'XTickLabel',[], 'YTickLabel', [])
set(gca,'XTick',[], 'YTick', [])

%%
figure,
hold on
x = 1:100;
y = exp(-x/18);
% plot([21,21],[0,1.05],'k--','LineWidth',3)
plot(x,y,'LineWidth',3,'Color',[0 0.5 0])
ex = 1:5:100;
ey = exp(-ex/18);
er = 0.1*ey./sqrt(ey);
errorbar(ex,ey,er,'LineWidth',3,'Color',[0 0.5 0])
ylim([0,1.05])
ax=gca;ax.LineWidth=3;
set(gca,'XTickLabel',[], 'YTickLabel', [])
set(gca,'XTick',[], 'YTick', [])

brk_y = flip(y);
brk_ex = 5:5:100;
brk_ey = flip(ey);
brk_er = flip(er);
plot(x,brk_y,'LineWidth',3,'Color',[0.85 0.33 0.1])
errorbar(brk_ex,brk_ey,brk_er,'LineWidth',3,'Color',[0.85 0.33 0.1])



