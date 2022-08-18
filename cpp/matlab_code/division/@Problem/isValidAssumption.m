function b = isValidAssumption(obj, word, index)
%here word is n*1 array,

%% Very Important: we cannot use strict constraint, because we cannot judge the partition

b = 1;
n = size(obj.all_cell_(index).edges_, 1);
%% the word should not violate all already assumed constraints
for j = 1:n
    edge_index = obj.all_cell_(index).edges_(j);
    if obj.all_edge_(edge_index).constraint_ == 1 && word(j) ~= 1
        b = 0;
        return ;
    end
    if obj.all_edge_(edge_index).constraint_ == -1 && word(j) ~= -1
        b = 0;
        return ;
    end
end

%% If only one color, then it must connect all its connectable neighbour
if size(obj.all_cell_(index).possible_color_, 1) == 1
    for i = 1:size(obj.all_cell_(index).edges_, 1)
        edge_index = obj.all_cell_(index).edges_(i);
        adj_index = obj.all_edge_(edge_index).theOther(index);
        if adj_index == -1
            continue;
        end
        if obj.all_cell_(adj_index).open_ == true
            continue;
        end
        if obj.all_cell_(adj_index).color_ == obj.all_cell_(index).possible_color_
            if word(i) ~= 1
                b = 0;
                return ;
            end
        else
            if word(i) == 1
                b = 0;
                return ;
            end
        end
    end
end

%% If zero connect
% It should have a color which is different from all colored adjacent cells
if sum(word) == 0
    pcolor = obj.all_cell_(index).possible_color_;
    for i = 1:size(obj.all_cell_(index).edges_, 1)
        edge_index = obj.all_cell_(index).edges_(i);
        adj_index = obj.all_edge_(edge_index).theOther(index);
        if adj_index == -1
            continue;
        end
        if obj.all_cell_(adj_index).open_ == true
            continue;
        end
        color = obj.all_cell_(adj_index).color_;
        B = find(pcolor == color);
        if ~isempty(B)
            pcolor(B) = [];
        end
    end
    if isempty(pcolor)
        b = 0;
        return ;
    else
        b = 1;
        return ;
    end
end

%% If one connect, we should check whether there exist some other connectable edges
if sum(word) == 1
    B = find(word == 1);
    edge_index = obj.all_cell_(index).edges_(B(1));
    adj_index = obj.all_edge_(edge_index).theOther(index);
    if adj_index == -1
        b = 0;
        return ;
    end
    if obj.all_cell_(adj_index).open_ == true
        b = 1;
        return ;
    end
    
    color = obj.all_cell_(adj_index).color_;
    
    %if there is any other colored adjacent cell with same color, it fails
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
        if adj_color == color && word(i) ~= 1
            b = 0;
            return ;
        end
    end
end

%% For uniqueness
partition = wordPartition(word);
if size(partition, 1) == 1 && any(partition == 1)
    b = 0;
    return ;
end

