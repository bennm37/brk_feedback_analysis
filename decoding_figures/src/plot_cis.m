function [line, errors] = plot_cis(x, q, q_cis, varargin)
    if nargin==4
        color = varargin{1};
        step = 1;
    elseif nargin==5
        color = varargin{1};
        step = varargin{2};
    else
        color="red";
        step = 1;
    end
    L = abs(q-q_cis(1,:)'); U = abs(q_cis(2,:)'-q);
    line = plot(x, q, "LineWidth",3, Color=color); hold on;
    errors = errorbar(x(1:step:end), q(1:step:end), L(1:step:end), U(1:step:end), "o", "LineWidth",3, Color=color);
    xlabel('x/L');