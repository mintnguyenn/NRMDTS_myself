function nor = calVerNormal()
global global_ori_tri;
global global_tri_normal;
global global_ori_ver;

n = size(global_ori_ver, 1);
nor = zeros(n, 3);

% find which triangles contain this vertex
for i = 1:n
    [B, ~] = find(global_ori_tri == i);
    normal = global_tri_normal(B, :);
    nor(i, :) = sum(normal, 1);
    nor(i, :) = nor(i, :)/norm(nor(i, :));
end

end