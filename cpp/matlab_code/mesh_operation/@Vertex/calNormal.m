function calNormal(obj)
%calculate the normal of a vertex

if obj.no_use_
    obj.normal_ = [];
    return ;
end

global global_ori_tri;
global global_tri_normal;

B = find(global_ori_tri == obj.index_);
if isempty(B)
    % This means that there is no triangles containing this vertex,
    % possibly because the mesh is deleted
    obj.normal_ = [0, 0, 0];
    return ;
end
B = rem(B-1, size(global_ori_tri, 1))+1;% get the index of the corresponding triangle

all_normal = global_tri_normal(B, :);%get the normal of all adjacent triangle

i = 1:3;
normal(i) = sum(all_normal(i, :));
obj.normal_ = normal/norm(normal);



end