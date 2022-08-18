function update_adj_ver(obj)
global global_ori_tri;
index = obj.index_;
adj = [];
trilist = [];
for i = 1:size(global_ori_tri, 1)
    if ~any(global_ori_tri(i, :) == index)
        continue;
    end
    trilist = [trilist; i];
end

nouse = [];
bd = compute_bd(global_ori_tri(trilist, :), nouse);

if any(bd == index)
    b = find(bd == index);
    if b ~= 1
        bd = [bd(b:end);bd(1:b-1)];
    end
end
obj.adj_ver_ = bd;

end