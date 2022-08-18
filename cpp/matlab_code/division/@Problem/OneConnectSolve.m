function OneConnectSolve(obj, index, word, k)

%here word is n*1 array
color = obj.all_cell_(index).possible_color_(k);
b = find(word == 1);

%% Change the graph
for i = 1:size(obj.all_cell_(index).edges_, 1)
    edge_index = obj.all_cell_(index).edges_(i);
    adj_index = obj.all_edge_(edge_index).theOther(index);
    if adj_index == -1
        continue;
    end
    if word(i) == 0 || word(i) == -1
        if obj.all_cell_(adj_index).open_ == false && ...
                obj.all_cell_(adj_index).color_ == color
            obj.current_cost_ = inf;
            return ;
        end
        obj.all_edge_(edge_index).constraint_ = -1;
    elseif word(i) == 1
        if obj.all_cell_(adj_index).open_ == false && ...
                obj.all_cell_(adj_index).color_ ~= color
            obj.current_cost_ = inf;
            return ;
        end
        obj.all_edge_(edge_index).constraint_ = 1;
    else
        warning('YT: error, we cannot solve One Connect Solve\n');
    end
end
obj.all_cell_(index).color_ = color;
obj.all_cell_(index).open_ = false;

edge_index = obj.all_cell_(index).edges_(b);
adj_index = obj.all_edge_(edge_index).theOther(index);
if obj.all_cell_(adj_index).open_ == false
    obj.mergeCells(index, edge_index);
else
    obj.current_cost_ = obj.current_cost_ + 1;
end

