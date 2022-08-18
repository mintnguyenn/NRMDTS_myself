function b = isAllBoundary(obj, our_ver)
% b = isAllBoundary(our_ver)
% A cell should contain at least one inner vertex, orelse it will be
% deleted 
index = obj.index_;
all_ver = obj.ver_;
isBoundary = zeros(size(all_ver, 1), 1);

for i = 1:size(isBoundary, 1)
    for j = 1:size(our_ver(all_ver(i)).adj_ver_, 1)
        if our_ver(our_ver(all_ver(i)).adj_ver_(j)).cell_ ~= index
            isBoundary(i) = 1;
            break;
        end
    end
    if ~isBoundary(i) == 1
        b = false;
        return ;
    end
end

    b = true;

end