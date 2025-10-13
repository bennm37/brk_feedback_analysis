clear all; close all;
nx = 100;
nr = 5000;
x = linspace(0,1,nx);
stride = nx/20;
%% Exponential Sqrt Gradient: Fig 1A
A = 100;
lam = 0.1;
lmi_max = 7;
grad_a_mean = A * exp(-x/lam);
grad_a = repmat(grad_a_mean, nr, 1);
grad_a =  grad_a + randn(nr,nx) .* (sqrt(grad_a));
abs_d_grad_a = abs(A/lam * exp(-x/lam));
% [X,Y,maps] = construct_decoding_maps(x, grad_a);
figure,
hold on
plot(x, grad_a_mean,'LineWidth',3,'Color',[0 0.5 0])
errorbar(x(5:stride:end), grad_a_mean(5:stride:end), sqrt(grad_a_mean(5:stride:end)), "o", "MarkerSize", 1, 'LineWidth',3,'Color',[0 0.5 0])
ax=gca;ax.LineWidth=3;
set(gca,'XTickLabel',[], 'YTickLabel', [])
set(gca,'XTick',[], 'YTick', [])
axes('Position',[.45 .45 .4 .4])
box on
% plot(x,lmi_1a,'k','LineWidth',3)
lmi_1a = calculate_lmi(x, grad_a);
plot_lmi(x, grad_a, 'k', stride)
ax1=gca;ax1.LineWidth=3;
set(gca,'XTickLabel',[], 'YTickLabel', [])
set(gca,'XTick',[], 'YTick', [])
ylim([0,lmi_max])
saveas(gcf, "media/figure_1/1a")
clean(ax); clean(ax1);
exportgraphics(gcf, "media/figure_1/1a_clean.tiff")


