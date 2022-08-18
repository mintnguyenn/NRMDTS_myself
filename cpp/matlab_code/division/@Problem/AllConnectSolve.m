function AllConnectSolve(obj, index, k)
% AllConnectSolve(obj, cell_index, k-th color)
% We enforce the connection of the index-th cell with all of its adjacent
% cells. Merge them and calculate the cost

% the color we choose
color = obj.all_cell_(index).possible_color_(k);

%% If any of the adjacent cell does not have the color, we return false
for i = 1:size(obj.all_cell_(index).edges_, 1)
    edge_index = obj.all_cell_(index).edges_(i);
    adj_index = obj.all_edge_(edge_index).theOther(index);
    if obj.all_cell_(adj_index).open_ == false
        if obj.all_cell_(adj_index).color_ ~= color
            obj.current_cost_ = inf;
            return ;
        end
    else
        if ~any(obj.all_cell_(adj_index).possible_color_ == color)
            obj.current_cost_ = inf;
            return ;
        end
    end
end

%% We are sure that all adjacent cells has been (or can be) polished in the same type of configuration
obj.all_cell_(index).color_ = color;
obj.all_cell_(index).open_ = false;

mergeedgelist = [];
costcount = zeros(size(obj.all_cell_, 1), 1);
for i = 1:size(obj.all_cell_(index).edges_, 1)
    edge_index = obj.all_cell_(index).edges_(i);
    adj_index = obj.all_edge_(edge_index).theOther(index);
    obj.all_edge_(edge_index).constraint_ = 1;
    
    if obj.all_cell_(adj_index).open_ == false
        mergeedgelist = [mergeedgelist; edge_index];
        costcount(adj_index) = 1;
    end
end

if isempty(mergeedgelist)
    obj.current_cost_ = obj.current_cost_ + 1;
else
    obj.mergeCells(index, mergeedgelist);
    obj.current_cost_ = obj.current_cost_ + (1 - sum(costcount));
end