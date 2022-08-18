function merge2plusn(obj, c1, c2)

%Last rewritten: 2019-12-07
origin_e1 = obj.all_cell_(c1).edges_;
origin_e2 = obj.all_cell_(c2).edges_;

tobemerged = intersect(origin_e1, origin_e2);
theotheredge = setdiff(origin_e1, tobemerged);
theothercell = obj.all_edge_(theotheredge).theOther(c1);

%% Not a ring, ordinary merging
if theothercell ~= c2
    newedgeindex = origin_e2;
    newedgeindex(newedgeindex == tobemerged) = theotheredge;
    
    obj.all_cell_(c2).merged_ = true;
    obj.all_cell_(c1).same_ = [obj.all_cell_(c1).same_; obj.all_cell_(c2).same_; c2];
    obj.all_cell_(c2).same_ = [];
    obj.all_cell_(c1).edges_ = newedgeindex;
    
    obj.all_edge_(tobemerged).no_use_ = true;
    
    if obj.all_edge_(theotheredge).c1_ == c1
        obj.all_edge_(theotheredge).c1_ = c2;
    elseif obj.all_edge_(theotheredge).c2_ == c1
        obj.all_edge_(theotheredge).c2_ = c2;
    else
        warning('YT: cannot find correct adj cell\n');
    end
    
    for i = 1:size(newedgeindex, 1)
        if obj.all_edge_(newedgeindex(i)).c1_ == c2
            obj.all_edge_(newedgeindex(i)).c1_ = c1;
        elseif obj.all_edge_(newedgeindex(i)).c2_ == c2
            obj.all_edge_(newedgeindex(i)).c2_ = c1;
        else
            warning('YT: cannot find adj cells\n');
        end
    end
    
    obj.all_cell_(c1).vertex_ = obj.all_cell_(c2).vertex_;
    obj.all_cell_(c2).vertex_ = [];
    
    return ; 
end

%% c1 is surrounded by c2
warning('YT: We have not finish this part.\n');





end