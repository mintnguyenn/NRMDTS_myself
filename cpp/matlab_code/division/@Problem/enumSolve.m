function enumSolve(obj, index)
% enumSolve(obj, index)
% For the cell which has less than three edges, we enumerate all its
% possible divisions and create branches. We must be sure that it is an
% isolated cell. 
% Improvement: For a cell containing more than 3 edges, but only less than
% 3 of them are meaningful (connecting adjacent cells), then we should also
% solve these cells in this function. 

%% First create a mapping to filter the -1 edge
m = [];
for i = 1:size(obj.all_cell_(index).edges_, 1)
    edge_index = obj.all_cell_(index).edges_(i);
    adj_index = obj.all_edge_(edge_index).theOther(index);
    if adj_index ~= -1
        m = [m; i];
    end
end

if size(m, 1) == 0
    % FOR COMPLETENESS: This cell only has no adjacent cells, which means
    % that it does not have edges or all edges(should be only one) connects to the empty.
    % So we can choose any color without changing the cost
    fprintf('YT: The cell is an island. \n');
    edge_index = obj.all_cell_(index).edges_;
    obj.all_cell_(index).color_ = obj.all_cell_(index).possible_color_(1);
    obj.all_cell_(index).open_ = false;
    obj.all_edge_(edge_index).constraint_ = -1;
    obj.current_cost_ = obj.current_cost_ + 1;
    return ;
end

%% For cell with only one edge
if size(m, 1) == 1
    edge_index = obj.all_cell_(index).edges_(m(1));
    adj_index = obj.all_edge_(edge_index).theOther(index);
    adj_color = obj.all_cell_(adj_index).color_;
    B = find(obj.all_cell_(index).possible_color_ == adj_color);
    C = find(obj.all_cell_(index).possible_color_ ~= adj_color);
    if ~isempty(B) && obj.all_edge_(edge_index).constraint_ == -1
        obj.current_cost_ = inf;
    elseif ~isempty(B)
        % This cell has the same color as its adjacent cell
        obj.all_cell_(index).color_ = adj_color;
        obj.all_cell_(index).open_ = false;
        obj.all_edge_(edge_index).constraint_ = 1;
        obj.mergeCells(index, edge_index);
        %the cost does not change
    else
        % FOR COMPLETENESS: Since it cannot connect to its adjacent cell,
        % whatever color we choose, we just choose the first color.
        obj.all_cell_(index).color_ = obj.all_cell_(index).possible_color_(1);
        obj.all_cell_(index).open_ = false;
        obj.all_edge_(edge_index).constraint_ = -1;
        obj.current_cost_ = obj.current_cost_ + 1;
    end
    return ;
end

%% For the cell with two edges
if size(m, 1) == 2
    %check the validity of coloring this cell
    edge_index1 = obj.all_cell_(index).edges_(m(1));
    edge_index2 = obj.all_cell_(index).edges_(m(2));
    adj_index1 = obj.all_edge_(edge_index1).theOther(index);
    adj_index2 = obj.all_edge_(edge_index2).theOther(index);
    con1 = obj.all_edge_(edge_index1).constraint_;
    con2 = obj.all_edge_(edge_index2).constraint_;
    adj_color1 = obj.all_cell_(adj_index1).color_;
    adj_color2 = obj.all_cell_(adj_index2).color_;
    
    avail_color = obj.all_cell_(index).possible_color_;
    if con1 == 1
        avail_color(avail_color ~= adj_color1) = [];
    elseif con1 == -1
        avail_color(avail_color == adj_color1) = [];
    end
    if con2 == 1
        avail_color(avail_color ~= adj_color2) = [];
    elseif con2 == -1
        avail_color(avail_color == adj_color2) = [];
    end
    
    if isempty(avail_color)
        obj.current_cost_ = inf;
        return ;
    end
    color = avail_color(1);
    obj.all_cell_(index).color_ = color;
    obj.all_cell_(index).open_ = false;
    if color == adj_color1 && color == adj_color2
        obj.all_edge_(edge_index1).constraint_ = 1;
        obj.all_edge_(edge_index2).constraint_ = 1;
        obj.mergeCells(index, [edge_index1; edge_index2]);
        if adj_index1 ~= adj_index2
            obj.current_cost_ = obj.current_cost_ - 1;
        end
    elseif color == adj_color1 && color ~= adj_color2
        obj.all_edge_(edge_index1).constraint_ = 1;
        obj.all_edge_(edge_index2).constraint_ = -1;
        obj.mergeCells(index, [edge_index1]);
    elseif color ~= adj_color1 && color == adj_color2
        obj.all_edge_(edge_index1).constraint_ = -1;
        obj.all_edge_(edge_index2).constraint_ = 1;
        obj.mergeCells(index, [edge_index2]);
    elseif color ~= adj_color1 && color ~= adj_color2
        obj.all_edge_(edge_index1).constraint_ = -1;
        obj.all_edge_(edge_index2).constraint_ = -1;
        obj.current_cost_ = obj.current_cost_ + 1;
    else
        warning('YT: should not reach here\n');
    end
    return ;
end

%% For the cell with three edges
if size(m, 1) == 3
    %check the validity of coloring this cell
    edge_index1 = obj.all_cell_(index).edges_(m(1));
    edge_index2 = obj.all_cell_(index).edges_(m(2));
    edge_index3 = obj.all_cell_(index).edges_(m(3));
    adj_index1 = obj.all_edge_(edge_index1).theOther(index);
    adj_index2 = obj.all_edge_(edge_index2).theOther(index);
    adj_index3 = obj.all_edge_(edge_index3).theOther(index);
    con1 = obj.all_edge_(edge_index1).constraint_;
    con2 = obj.all_edge_(edge_index2).constraint_;
    con3 = obj.all_edge_(edge_index3).constraint_;
    adj_color1 = obj.all_cell_(adj_index1).color_;
    adj_color2 = obj.all_cell_(adj_index2).color_;
    adj_color3 = obj.all_cell_(adj_index3).color_;
    
    avail_color = obj.all_cell_(index).possible_color_;
    if con1 == 1
        avail_color(avail_color ~= adj_color1) = [];
    elseif con1 == -1
        avail_color(avail_color == adj_color1) = [];
    end
    if con2 == 1
        avail_color(avail_color ~= adj_color2) = [];
    elseif con2 == -1
        avail_color(avail_color == adj_color2) = [];
    end
    if con3 == 1
        avail_color(avail_color ~= adj_color3) = [];
    elseif con3 == -1
        avail_color(avail_color == adj_color3) = [];
    end
    if isempty(avail_color)
        obj.current_cost_ = inf;
        return ;
    end
    color = avail_color(1);
    obj.all_cell_(index).color_ = color;
    obj.all_cell_(index).open_ = false;
    
    %calculate cost and merge cells
    if color == adj_color1 && color == adj_color2 && color == adj_color3
        obj.all_edge_(edge_index1).constraint_ = 1;
        obj.all_edge_(edge_index2).constraint_ = 1;
        obj.all_edge_(edge_index3).constraint_ = 1;
        obj.mergeCells(index, [edge_index1; edge_index2; edge_index3]);
        if adj_index1 == adj_index2 && adj_index1 == adj_index3
            
        elseif adj_index1 == adj_index2 || adj_index1 == adj_index3 || adj_index2 == adj_index3
            obj.current_cost_ = obj.current_cost_ - 1;
        else
            obj.current_cost_ = obj.current_cost_ - 2;
        end
    elseif color == adj_color1 && color == adj_color2 && color ~= adj_color3
        obj.all_edge_(edge_index1).constraint_ = 1;
        obj.all_edge_(edge_index2).constraint_ = 1;
        obj.all_edge_(edge_index3).constraint_ = -1;
        obj.mergeCells(index, [edge_index1; edge_index2]);
        if adj_index1 ~= adj_index2
            obj.current_cost_ = obj.current_cost_ - 1;
        end
    elseif color == adj_color1 && color ~= adj_color2 && color == adj_color3
        obj.all_edge_(edge_index1).constraint_ = 1;
        obj.all_edge_(edge_index2).constraint_ = -1;
        obj.all_edge_(edge_index3).constraint_ = 1;
        obj.mergeCells(index, [edge_index1; edge_index3]);
        if adj_index1 ~= adj_index3
            obj.current_cost_ = obj.current_cost_ - 1;
        end
    elseif color ~= adj_color1 && color == adj_color2 && color == adj_color3
        obj.all_edge_(edge_index1).constraint_ = -1;
        obj.all_edge_(edge_index2).constraint_ = 1;
        obj.all_edge_(edge_index3).constraint_ = 1;
        obj.mergeCells(index, [edge_index2; edge_index3]);
        if adj_index2 ~= adj_index3
            obj.current_cost_ = obj.current_cost_ - 1;
        end
    elseif color == adj_color1 && color ~= adj_color2 && color ~= adj_color3
        obj.all_edge_(edge_index1).constraint_ = 1;
        obj.all_edge_(edge_index2).constraint_ = -1;
        obj.all_edge_(edge_index3).constraint_ = -1;
        obj.mergeCells(index, [edge_index1]);
    elseif color ~= adj_color1 && color == adj_color2 && color ~= adj_color3
        obj.all_edge_(edge_index1).constraint_ = -1;
        obj.all_edge_(edge_index2).constraint_ = 1;
        obj.all_edge_(edge_index3).constraint_ = -1;
        obj.mergeCells(index, [edge_index2]);
    elseif color ~= adj_color1 && color ~= adj_color2 && color == adj_color3
        obj.all_edge_(edge_index1).constraint_ = -1;
        obj.all_edge_(edge_index2).constraint_ = -1;
        obj.all_edge_(edge_index3).constraint_ = 1;
        obj.mergeCells(index, [edge_index3]);
    elseif color ~= adj_color1 && color ~= adj_color2 && color ~= adj_color3
        obj.all_edge_(edge_index1).constraint_ = -1;
        obj.all_edge_(edge_index2).constraint_ = -1;
        obj.all_edge_(edge_index3).constraint_ = -1;
        obj.current_cost_ = obj.current_cost_ +1;
    else
        warning('YT: error, cannot solve 3edge cell\n');
    end
    return ;
end

end

