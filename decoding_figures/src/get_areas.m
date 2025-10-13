function areas = get_areas(hpdr)
    [nx, ~] = size(hpdr);
    areas = zeros([1,nx]);
    for i=1:nx
        data = hpdr(i,:);
        % data = bwareaopen(data,1);
        data = bwmorph(data,"clean"); %label of size 1
        labels = bwlabeln(data);
        nl = max(labels);
        [dim,~]=size(areas);
        if nl>dim
            areas = [areas; zeros([nl-dim, nx])];
        end
        [dim,~]=size(areas);
        areas(:,i) = arrayfun(@(j) sum(labels==j), 1:dim);
        % for j=1:nl
        %     areas(j,i)=sum(labels==j);
        % end
    end
    areas = areas';



