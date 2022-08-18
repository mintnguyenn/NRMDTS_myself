function mergenplus2(obj, c1, c2)

% Last rewritten: 2019-12-07
origin_e1 = obj.all_cell_(c1).edges_;
origin_e2 = obj.all_cell_(c2).edges_;

tobemerged = intersect(origin_e1, origin_e2);
theotheredge = setdiff(origin_e2, tobemerged);
theothercell = obj.all_edge_(theotheredge).theOther(c2);

%% Not a ring, ordinary merging
if theothercell ~= c1
    newedgeindex = origin_e1;
    newedgeindex(newedgeindex == tobemerged) = theotheredge;
    
    obj.all_cell_(c2).merged_ = true;
    obj.all_cell_(c1).same_ = [obj.all_cell_(c1).same_; obj.all_cell_(c2).same_; c2];
    obj.all_cell_(c2).same_ = [];
    obj.all_cell_(c1).edges_ = newedgeindex;
    
    obj.all_edge_(tobemerged).no_use_ = true;
    
    if obj.all_edge_(theotheredge).c1_ == c2
        obj.all_edge_(theotheredge).c1_ = c1;
    elseif obj.all_edge_(theotheredge).c2_ == c2
        obj.all_edge_(theotheredge).c2_ = c1;
    else
        warning('YT: cannot find correct adj cell\n');
    end
    
    
    
    return ; 
end

%% c2 is surrounded by c1
warning('YT: We have not finish this part.\n');

end