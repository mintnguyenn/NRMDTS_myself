function OneColorSolve(obj, index)

% directly change the data in the input parameters
% we will merge before leave this function

color = obj.all_cell_(index).possible_color_;

%% Find the connectable and inconnectable cells
m = size(obj.all_cell_(index).edges_, 1);
B = [];
C = [];
for i = 1:m
    edge_index = obj.all_cell_(index).edges_(i);
    adj_index = obj.all_edge_(edge_index).theOther(index);
    if adj_index == -1
        continue;
    end
    if obj.all_cell_(adj_index).open_ == true
        continue;
    end
    if obj.all_cell_(adj_index).color_ == color
        B = [B; edge_index];
    end
    if ~any(obj.all_cell_(adj_index).possible_color_ == color)
        C = [C; edge_index];
    end
end
    
%% Change Constraint
for i = 1:size(B, 1)
    obj.all_edge_(B(i)).constraint_ = 1;
end
for i = 1:size(C, 1)
    obj.all_edge_(C(i)).constraint_ = -1;
end

%% Color and close this cell
obj.all_cell_(index).color_ = color;
obj.all_cell_(index).open_ = false;
%maybe different edge connects same cell, we should check
count = zeros(size(obj.all_cell_, 1), 1);
for i = 1:size(B, 1)
    adj_index = obj.all_edge_(B(i)).theOther(index);
    count(adj_index) = 1;
end
obj.current_cost_ = obj.current_cost_ + 1 - sum(count);

%% Merge Cells
obj.mergeCells(index, B);
end