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
lmi_1a = calculate_lmi(x, grad_a);
plot(x,lmi_1a,'k','LineWidth',3)
% plot_lmi(x, grad_a, 'k', stride)
ax1=gca;ax1.LineWidth=3;
set(gca,'XTickLabel',[], 'YTickLabel', [])
set(gca,'XTick',[], 'YTick', [])
ylim([0,lmi_max])
saveas(gcf, "media/figure_1/1a")
clean(ax); clean(ax1);
exportgraphics(gcf, "media/figure_1/1a_clean.tiff")

% print?
%% Opposing Exponential Sqrt Gradients: Fig 1B
pmad_b_mean = A * exp(-x/lam);
brk_b_mean = A * exp(-(1-x)/lam);
pmad_b = repmat(pmad_b_mean, nr, 1);
brk_b = repmat(brk_b_mean, nr, 1);
pmad_b = pmad_b + randn(nr,nx) .* (sqrt(pmad_b));
brk_b = brk_b + randn(nr,nx) .* (sqrt(brk_b));
bootfun = @(p1, p2) calculate_lmi_two(x, cat(3, p1, p2));
lmi = bootfun(pmad_b, brk_b);
lmi_cis = bootci(50, bootfun, pmad_b, brk_b);
L = abs(lmi-lmi_cis(1,:)'); U = abs(lmi_cis(2,:)'-lmi);
save("data/1b_bootsrap", "lmi_cis","L","U")

%%
load("data/1b_bootsrap")
figure,
hold on
plot(x, pmad_b_mean,'LineWidth',3,'Color',[0 0.5 0])
errorbar(x(5:stride:end), pmad_b_mean(5:stride:end), sqrt(pmad_b_mean(5:stride:end)),'LineWidth',3,'Color',[0 0.5 0])
plot(x, brk_b_mean,'LineWidth',3,'Color',[0.5 0 0])
errorbar(x(5:stride:end), brk_b_mean(5:stride:end), sqrt(brk_b_mean(5:stride:end)),'LineWidth',3,'Color',[0.5 0 0])

ax=gca;ax.LineWidth=3;
set(gca,'XTickLabel',[], 'YTickLabel', [])
set(gca,'XTick',[], 'YTick', [])
axes('Position',[.33 .45 .4 .4])
box on
line = plot(x, lmi, "LineWidth",3, Color="k"); hold on;
errors = errorbar(x(1:stride:end), lmi(1:stride:end), L(1:stride:end), U(1:stride:end), "o", "LineWidth",3, Color="k");
xlabel('x/L');
ylabel('PID (bits)');  
ax=gca;ax.LineWidth=3;
ylim([0,max(lmi_1a)]);
set(gca,'XTickLabel',[], 'YTickLabel', [])
set(gca,'XTick',[], 'YTick', [])
saveas(gcf, "media/figure_1/1b.pdf")
% print?
%% Poisson Readout: Fig 1C
lam_c = lam * 1.25;
pmad_c_mean = A * exp(-x/lam_c);
brk_c_mean = A * exp(-(1-x)/lam_c);
pmad_c = repmat(pmad_c_mean, nr, 1);
brk_c = repmat(brk_c_mean, nr, 1);
pmad_c = pmad_c + randn(nr,nx) .* (sqrt(pmad_c));
brk_c = brk_c + randn(nr,nx) .* (sqrt(brk_c));
figure,
hold on
plot(x, pmad_c_mean,'LineWidth',3,'Color',[0 0.5 0])
errorbar(x(5:stride:end), pmad_c_mean(5:stride:end), sqrt(pmad_c_mean(5:stride:end)),'LineWidth',3,'Color',[0 0.5 0])
plot(x, brk_c_mean,'LineWidth',3,'Color',[0.5 0 0])
errorbar(x(5:stride:end), brk_c_mean(5:stride:end), sqrt(brk_c_mean(5:stride:end)),'LineWidth',3,'Color',[0.5 0 0])

ax=gca;ax.LineWidth=3;
set(gca,'XTickLabel',[], 'YTickLabel', [])
set(gca,'XTick',[], 'YTick', [])
saveas(gcf, "media/figure_1/1c.pdf")
% print?

function clean(ax)
    lgd = findobj('type', 'legend');
    delete(lgd)
    set(ax,'XTickLabel',[], 'YTickLabel', [],"XLabel",[],"YLabel",[]) 
end

