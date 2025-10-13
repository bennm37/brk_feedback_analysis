clear all;
[Kni, Kr, Gt, Hb] = load_gg("data/gregor_data/Gap/gap_data_raw_dorsal_wt.mat");
[x, profiles] = clean(Kr); name="Kr";

%%
[gel, p_g_x] = conditional_distribution(profiles, 1000);
[G,X] = meshgrid(gel,x);
L = x(end)-x(1);
p_x = 1/L; % assumed uniform
p_g = trapz(x, p_g_x .* p_x, 1);
p_x_g = p_g_x .* p_x ./ p_g; % bayes rule
pos_mu = trapz(x, p_x_g.*x');
pos_sig_2 = trapz(x, p_x_g.*(x'-pos_mu).^2);
exp_pos_sig_2 = trapz(gel, (p_g_x .* pos_sig_2)')';
pid = calculate_lmi(x, profiles);
gauss_pid_sig = 1./(sqrt(2*pi*exp(1))*2.^pid);


%%
f=figure; f.Position = [100 100 400 300];
colormap(flipud(gray)); pcolor(X,G,p_g_x); shading flat;
colorbar; clim([0,0.04]); xlabel("x"); ylabel("g");
% saveas(f, sprintf("media/gap_gene/%s_poserior.pdf", name))

f=figure; f.Position = [500 100 400 300];
subplot(2,1,1);
plot(x, sqrt(exp_pos_sig_2)); hold on;
plot(x, gauss_pid_sig);
xlabel("x"); legend(["\sigma^{EPV}","\sigma^{PID}"])
subplot(2,1,2);
plot(x, gauss_pid_sig./sqrt(exp_pos_sig_2));
xlabel("x"); ylabel("\sigma^{PID}/\sigma^{EPV}");
saveas(gcf, sprintf("media/gap_gene/%s_posterior_variance.pdf", name))
%% 
f=figure; f.Position = [100 100 400 300];
shadedErrorBar(x, nanmean(profiles), nanstd(profiles));
xlabel("x"); ylabel("g");
saveas(gcf, sprintf("media/gap_gene/%s_profile.pdf", name))