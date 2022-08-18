function findBoundary(obj, our_ver)
global global_ori_tri;
global global_ori_ver;
global global_generalized_tri;
face = [];

for i = 1:size(our_ver, 1)
    if our_ver(i).cell_ == obj.index_
        B = find(global_generalized_tri == our_ver(i).index_);
        for j = 1:size(B, 1)
            face = [face; global_generalized_tri(B(j), :)];
        end
    end
end

obj.boundary_ = compute_bd(face, []);
