function [x_clean, profiles_clean] = clean(profiles)
    [~, nx] = size(profiles);
    x = linspace(0,1,nx);
    i = 1;
    while any(isnan(profiles(:,i,:)))
        i = i+1;
    end
    j = 0;
    while any(isnan(profiles(:,end-j,:)))
        j = j+1;
    end
    x_clean = x(i:end-j);
    profiles_clean = profiles(:,i:end-j);
end
    