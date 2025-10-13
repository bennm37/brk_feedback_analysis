function [lmi, lmi_cis] = bootstrap_lmi(x, profiles)
    [~,~,ng] = size(profiles);
    if ng==1
        lmi = calculate_lmi(x, profiles);
        bootfun = @(p) calculate_lmi(x, p);
        lmi_cis = bootci(100, bootfun, profiles); 
    elseif ng==2
        bootfun = @(p1, p2) calculate_lmi_two(x, cat(3, p1, p2));
        lmi = bootfun(profiles(:,:,1), profiles(:,:,2));
        disp("Starting Bootstrap")
        lmi_cis = bootci(50, bootfun, profiles(:,:,1), profiles(:,:,2));
    else
        disp("ng >2 is not supported")
    end
end
