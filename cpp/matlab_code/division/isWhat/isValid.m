function b = isValid(obj, all_cell)
% return whether a cell can have solutions.
% some criterions that we can definite know that there is not a solution
%
% since maybe the cell is not isolated (means that not all of its adjacent
% cells have been color), then we should only consider the constraint given
% by the colored adjacent cells
b = true;

for i = 1:size(obj.edges_, 1)
    adj_index = obj.edges_(i).theOther(obj.index_);
    adj_color = all_cell(adj_index).color_;
    if all_cell(adj_index).open_ == true
        continue;% uncolored adjacent cells give no impossiblity
    end
    %if the edge mustn't connect but there is only one color, return false
    if obj.edges_(i).constraint_ == -1 && ...
            size(obj.possible_color_, 1) == 1 && ...
            obj.possible_color_ == all_cell(adj_index).color_
        b = false;
        return ;
    end
    
    %if the edge must connect but there is no corresponding colors, return false
    if obj.edges_(i).constraint_ == 1 && ...
            ~ismember(adj_color, obj.possible_color_)
        b = false;
        return ;
    end
end

%if the cell is asked to connect many groups of color, then they cannot go
%across, or it will get failure
% for example, 1, 1, 2, 2 is OK, but 1, 2, 1, 2 is not OK
allconnect = zeros(size(obj.edges_, 1), 1);
for i = 1:size(obj.edges_, 1)
    if obj.edges_(i).constraint_ == 1
        adj_index = obj.edges_(i).theOther(obj.index_);
        allconnect(i) = all_cell(adj_index).color_;
        
        
    end
    
end
failure = false;
current_color = -1;
connecting = 0;
for i = 1:size(allconnect, 1)
    if allconnect(i) ~= 0 && current_color == -1 && connecting == 0
        current_color = allconnect(i);
        continue;
    end
    if allconnect(i) ~= 0 && current_color ~= -1
        if allconnect(i) == current_color
            connecting = 1;
        else
            if connnecting == 1
                % no problem, the previous color can be connected, we just
                % start connect a new color
                current_colr = allconnect(i);
                connecting = 0;
                continue;
            else
                failure = true;
                break;
            end
        end
    end
end
if failure
    b = false;
    return ;
end

end