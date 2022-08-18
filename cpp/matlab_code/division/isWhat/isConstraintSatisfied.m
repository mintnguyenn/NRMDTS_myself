function b = isConstraintSatisfied(obj, edge_index)
% Given an edge and its two adjacent cells, if they are about to connect,
% then they must have same possible color, orelse they must have different
% possible colors
b = 1;
c1 = obj.all_edge_(edge_index).c1_;
c2 = obj.all_edge_(edge_index).c2_;
con = obj.all_edge_(edge_index).constraint_;
if c1 == -1 || c2 == -1
    return ;
end

if obj.all_cell_(c1).open_ == false
    pcolor1 = obj.all_cell_(c1).color_;
else
    pcolor1 = obj.all_cell_(c1).possible_color_;
end

if obj.all_cell_(c2).open_ == false
    pcolor2 = obj.all_cell_(c2).color_;
else
    pcolor2 = obj.all_cell_(c2).possible_color_;
end

if con == 1
    pcolor = intersect(pcolor1, pcolor2);
    if isempty(pcolor)
        b = 0;
        return ;
    end
elseif con == -1
    pcolor = [setdiff(pcolor1, pcolor2); setdiff(pcolor2, pcolor1)];
    if isempty(pcolor)
        b = 0;
        return ;
    end
end
end