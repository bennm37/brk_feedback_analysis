pmad = load('data/pMad.mat').pMad;
pmadv = load('data/pMadV.mat').pMadV;
pmadd = load('data/pMadD.mat').pMadD;
brk = load('data/Brk.mat').Brk;
brkv = load('data/BrkV.mat').BrkV;
brkd = load('data/BrkD.mat').BrkD;
keys = ["pmad","pmadv","pmadd","brk","brkv","brkd"];
datasets = {pmad, pmadv, pmadd, brk, brkv, brkd};
for i=1:numel(keys)
    n_x = size(datasets{i},2);
    x = linspace(0, n_x/50, n_x);
    [X, Y, maps] = construct_decoding_maps(x, datasets{i});
    plot_decoding_map(X,Y,maps,"figure_2/" + keys(i));
end
% close all;