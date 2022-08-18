function exploring(obj, seed_index, our_ver)
% exploring(obj, seed_index, our_ver)
% From a seed vertex in the original mesh, through a floodfill based on the
% connectivity given by the structure of the mesh, we collect all vertices
% that have connection with the seed vertex and have the same kind of
% configurations 

openlist = seed_index;

our_ver(seed_index).cell_ = obj.index_;
obj.ver_ = [obj.ver_; seed_index];
obj.possible_color_ = our_ver(seed_index).color_;

while ~isempty(openlist)
    temp = openlist(1);
    openlist(1) = [];
    
    ADJ = our_ver(temp).adj_ver_;
    
    for j = 1:size(ADJ, 1)
        adj = ADJ(j);
        if our_ver(adj).no_use_ || ~isempty(our_ver(adj).cell_) || isempty(our_ver(adj).color_)
            continue;
        end
        if ~all(size(our_ver(adj).color_) == size(our_ver(temp).color_))
            continue;
        end
        
        onecolor = sort(our_ver(adj).color_);
        anothercolor = sort(our_ver(temp).color_);
        
        if all(onecolor == anothercolor)
            our_ver(adj).cell_ = obj.index_;
            obj.ver_ = [obj.ver_; adj];
            openlist = [openlist; adj];
        end
    end
end

%% Store the index of the triangles

global global_generalized_tri;
obj.tri_ = [];
for i = 1:size(obj.ver_, 1)
    B = find(global_generalized_tri == obj.ver_(i));
    obj.tri_ = [obj.tri_; B];
end

end