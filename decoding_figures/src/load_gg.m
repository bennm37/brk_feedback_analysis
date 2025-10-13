function [Kni, Kr, Gt, Hb] = load_gg(fname)
    load(fname);
    nx = 1000;
    n = size(data,2);
    Kni = reshape([data.Kni],[nx,n])';
    Kr = reshape([data.Kr],[nx,n])';
    Gt = reshape([data.Gt],[nx,n])';
    Hb = reshape([data.Hb],[nx,n])';
end