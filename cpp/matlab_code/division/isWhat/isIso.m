function b = isIso(p, index)
b = true;

if p.all_cell_(index).open_ == false
    b = false;
    return ;
end

for i = 1:size(p.all_cell_(index).edges_, 1)
    edge_index = p.all_cell_(index).edges_(i);
    adj_index = p.all_edge_(edge_index).theOther(index);
    if adj_index == -1
        continue;
    end
    if p.all_cell_(adj_index).open_ == true
        b = false;
        return ;
    end
end
end