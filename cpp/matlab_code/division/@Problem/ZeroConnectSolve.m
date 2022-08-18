function ZeroConnectSolve(obj, index, k)

color = obj.all_cell_(index).possible_color_(k);

for i = 1:size(obj.all_cell_(index).edges_, 1)
    edge_index = obj.all_cell_(index).edges_(i);
    adj_index = obj.all_edge_(edge_index).theOther(index);
    if adj_index == -1
        continue;
    end
    if obj.all_cell_(adj_index).open_ == true
        continue;
    end
    
    adj_color = obj.all_cell_(adj_index).color_;
    if adj_color == color
        %if the constraint is not connect, but the colors are the same,
        %then it is not necessary to check (because maybe still optimal, maybe lose it)
        obj.current_cost_ = inf;
        return ;
    end
    obj.all_edge_(edge_index).constraint_ = -1;
end

obj.all_cell_(index).color_ = color;
obj.all_cell_(index).open_ = false;
obj.current_cost_ = obj.current_cost_ + 1;
