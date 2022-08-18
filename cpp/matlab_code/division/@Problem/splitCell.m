function newproblem = splitCell(obj, index, word, fullPartition, k)
% newproblem = splitCell(obj, index, word, fullPartition, k)
% The fullPartition can be cell(0), but it cannot
% Whatever word(\neq 0), we will split the problem
% here word is n*1 array
% Once we find that the split is not valid, we return a newproblem with
% cost inf

color = obj.all_cell_(index).possible_color_(k);
newproblem = obj.purelyCopy();

% fullPartition

%% Check whether current assumptions are valid
for i = 1:size(word, 1)
    if word(i) == 0
        continue;
    elseif word(i) == 1
        edge_index = newproblem.all_cell_(index).edges_(i);
        adj_index = newproblem.all_edge_(edge_index).theOther(index);
        if adj_index == -1
            newproblem.current_cost_ = inf;
            return ;
        end
        if ~any(newproblem.all_cell_(adj_index).possible_color_ == color)
            newproblem.current_cost_ = inf;
            return ;
        end
        if newproblem.all_cell_(adj_index).open_ == false && ...
                newproblem.all_cell_(adj_index).color_ ~= color
            newproblem.current_cost_ = inf;
            return ;
        end
        newproblem.all_edge_(edge_index).constraint_ = 1;
    elseif word(i) == -1
        edge_index = newproblem.all_cell_(index).edges_(i);
        adj_index = newproblem.all_edge_(edge_index).theOther(index);
        if adj_index == -1
            continue;
        end
        if newproblem.all_cell_(adj_index).open_ == false && ...
                newproblem.all_cell_(adj_index).open_ == color
            newproblem.current_cost_ = inf;
            return ;
        end
        newproblem.all_edge_(edge_index).constraint_ = -1;
    else
        warning('YT: error, invalid word\n');
    end
end

%% TODO: When the word is 111...11 and the assumption is still reasonable, how to deal with

%% Check the validity of all isolated adjacent cells
for i = size(fullPartition, 1):-1:1
    %calculate the num of nonzero element
    if sum(fullPartition(i, :) ~= 0) == 1
        edge_index = newproblem.all_cell_(index).edges_(fullPartition(i, 1));
        adj_index = newproblem.all_edge_(edge_index).theOther(index);
        if adj_index ~= -1
            if newproblem.all_cell_(adj_index).open_ == false
                if newproblem.all_cell_(adj_index).color_ == color
                    newproblem.current_cost_ = inf;
                    return ;
                else
                    newproblem.all_edge_(edge_index).constraint_ = -1;
                end
            else
                newproblem.all_edge_(edge_index).constraint_ = -1;
            end
        end
%         fullPartition(i, :) = [];
    end
end

%% Check the validity of all dual adjacent cells
for i = size(fullPartition, 1):-1:1
    if sum(fullPartition(i, :) ~= 0) ~= 2
        continue;
    end
    
    edge_index1 = newproblem.all_cell_(index).edges_(fullPartition(i, 1));
    edge_index2 = newproblem.all_cell_(index).edges_(fullPartition(i, 2));
    adj_index1 = newproblem.all_edge_(edge_index1).theOther(index);
    adj_index2 = newproblem.all_edge_(edge_index2).theOther(index);
    if adj_index1 == -1 || adj_index2 == -1
        newproblem.current_cost_ = inf;
        return ;
    end
    pcolor1 = newproblem.all_cell_(index).possible_color_;
    pcolor2 = newproblem.all_cell_(adj_index1).possible_color_;
    pcolor3 = newproblem.all_cell_(adj_index2).possible_color_;
    avail_color = intersect(pcolor1, pcolor2);
    avail_color = intersect(avail_color, pcolor3);
    avail_color(avail_color == color) = [];
    if isempty(avail_color)
        newproblem.current_cost_ = inf;
        return ;
    end
    
    
    
    %% It is really possible to create such a subcell
    %First we create new edge
    m = size(newproblem.all_edge_, 1);
    n = size(newproblem.all_cell_, 1);
    newproblem.all_edge_(m+1, 1) = Edge(index, n+1, -1, m+1);
    newproblem.all_edge_(m+1).setFather(index);
    
    %Then we create new cell
    newEdgeList = [edge_index1; edge_index2; m+1];
    %Get the corresponding topological vertex
    if edge_index1 == newproblem.all_cell_(index).edges_(end)
        v1 = [newproblem.all_cell_(index).vertex_(end), newproblem.all_cell_(index).vertex_(1)];
    else
        edgeindex = find(newproblem.all_cell_(index).edges_ == edge_index1);
        v1 = [newproblem.all_cell_(index).vertex_(edgeindex), newproblem.all_cell_(index).vertex_(edgeindex+1)];
    end
    if edge_index2 == newproblem.all_cell_(index).edges_(end)
        v2 = [newproblem.all_cell_(index).vertex_(end), newproblem.all_cell_(index).vertex_(1)];
    else
        edgeindex = find(newproblem.all_cell_(index).edges_ == edge_index2);
        v2 = [newproblem.all_cell_(index).vertex_(edgeindex), newproblem.all_cell_(index).vertex_(edgeindex+1)];
    end
    %These two vertex list should be able to connect
    if v1(2) ~= v2(1)
        warning('YT: error, cannot find two adjacent cells\n');
    end
    newVertex = [v1(1); v1(2); v2(2)];
    
%     avail_color
    newproblem.all_cell_(n+1, 1) = Node(n+1, avail_color', newEdgeList, newVertex);
    % we should delete the vertex in the original cell
    newproblem.all_cell_(index).vertex_(newproblem.all_cell_(index).vertex_ == v1(2)) = [];
    
    %Third, we change the edges of the old cell
    newproblem.all_edge_(edge_index1).constraint_ = 1;
    newproblem.all_edge_(edge_index2).constraint_ = 1;
    b = find(newproblem.all_cell_(index).edges_ == edge_index1);
    newproblem.all_cell_(index).edges_(b) = m+1;
    b = find(newproblem.all_cell_(index).edges_ == edge_index2);
    newproblem.all_cell_(index).edges_(b) = [];
    
    newproblem.all_cell_(index).divided_ = true;
    
    deleted_number = fullPartition(i, 2:end);
    deleted_number = deleted_number(deleted_number ~= 0);
%     fullPartition(i, :) = [];
    if ~isempty(fullPartition)
        fullPartition = reduceNumber(fullPartition, deleted_number);
    end
    
    %Fourth, we change the data in the edges
    if newproblem.all_edge_(edge_index1).c1_ == index
        newproblem.all_edge_(edge_index1).c1_ = n+1;
    elseif newproblem.all_edge_(edge_index1).c2_ == index
        newproblem.all_edge_(edge_index1).c2_ = n+1;
    else
        warning('YT: cannot change the data in edges\n');
    end
    
    if newproblem.all_edge_(edge_index2).c1_ == index
        newproblem.all_edge_(edge_index2).c1_ = n+1;
    elseif newproblem.all_edge_(edge_index2).c2_ == index
        newproblem.all_edge_(edge_index2).c2_ = n+1;
    else
        warning('YT: cannot change the data in edges\n');
    end
end


%% Check the validity of all multi-adjacent cells
for i = size(fullPartition, 1):-1:1
    if sum(fullPartition(i, :) ~= 0) < 3
        continue;
    end
    %% Check the validity of connecting the multi-adjacent cell
    p = -1;
    for j = size(fullPartition(i, :), 2):-1:1
        if fullPartition(i, j) ~= 0
            p = j;
            break;
        end
    end
    
    % the first edge
    edge_index1 = newproblem.all_cell_(index).edges_(fullPartition(i, 1));
    % the last edge
    edge_index2 = newproblem.all_cell_(index).edges_(fullPartition(i, p));
    adj_index1 = newproblem.all_edge_(edge_index1).theOther(index);
    adj_index2 = newproblem.all_edge_(edge_index2).theOther(index);
    if adj_index1 == -1 || adj_index2 == -1
        newproblem.current_cost_ = inf;
        return ;
    end
    pcolor1 = newproblem.all_cell_(index).possible_color_;
    pcolor2 = newproblem.all_cell_(adj_index1).possible_color_;
    pcolor3 = newproblem.all_cell_(adj_index2).possible_color_;
    avail_color = intersect(pcolor1, pcolor2);
    avail_color = intersect(avail_color, pcolor3);
    avail_color(avail_color == color) = [];
    if isempty(avail_color)
        newproblem.current_cost_ = inf;
        return ;
    end
    
    %% It is really possible to create such a subcell
    %First we create new edge
    m = size(newproblem.all_edge_, 1);
    n = size(newproblem.all_cell_, 1);
    newproblem.all_edge_(m+1, 1) = Edge(index, n+1, -1, m+1);
    newproblem.all_edge_(m+1).setFather(index);
    
    %Then we create new cell
    startindex = find(newproblem.all_cell_(index).edges_ == edge_index1);
    endindex = find(newproblem.all_cell_(index).edges_ == edge_index2);
    
    if startindex < endindex
        newEdgeList = [newproblem.all_cell_(index).edges_(startindex:endindex);
            m+1];
    else
        newEdgeList = [newproblem.all_cell_(index).edges_(startindex:end);
            newproblem.all_cell_(index).edges_(1:endindex);
            m+1];
    end
    
%     warning('YT: 不能随意改Index，因为添加删除了边之后会导致partition的大小出错\n');
%     
    
    replaced_Edgelist = newEdgeList(1:end-1);
    
    %Get the corresponding topological vertex
    newVertex = [];
    for j = 1:size(replaced_Edgelist, 1)
        b = find(newproblem.all_cell_(index).edges_ == replaced_Edgelist(j));
        newVertex = [newVertex; newproblem.all_cell_(index).vertex_(b)];
    end
    b = find(newproblem.all_cell_(index).edges_ == replaced_Edgelist(end));
    b = b+1;
    b = mod(b-1, size(newproblem.all_cell_(index).vertex_, 1))+1;
    newVertex = [newVertex; newproblem.all_cell_(index).vertex_(b)];
    
    newproblem.all_cell_(n+1, 1) = Node(n+1, avail_color', newEdgeList, newVertex);
    
    %Third, we change the edges of the old cell
    newproblem.all_edge_(edge_index1).constraint_ = 1;
    newproblem.all_edge_(edge_index2).constraint_ = 1;
    b = find(newproblem.all_cell_(index).edges_ == replaced_Edgelist(1));
    newproblem.all_cell_(index).edges_(b) = m+1;
    for j = 2:size(replaced_Edgelist, 1)
        b = find(newproblem.all_cell_(index).edges_ == replaced_Edgelist(j));
        newproblem.all_cell_(index).edges_(b) = [];
    end
    
    newproblem.all_cell_(index).divided_ = true;
    
    deleted_number = fullPartition(i, 2:end);
    deleted_number = deleted_number(deleted_number ~= 0);
%     fullPartition(i, :) = [];
    if ~isempty(fullPartition)
        fullPartition = reduceNumber(fullPartition, deleted_number);
    end
    
    %Fourth, we change the data in the edges
    for j = 1:size(replaced_Edgelist, 1)
        edge_index = replaced_Edgelist(j);
        if newproblem.all_edge_(edge_index).c1_ == index
            newproblem.all_edge_(edge_index).c1_ = n+1;
        elseif newproblem.all_edge_(edge_index).c2_ == index
            newproblem.all_edge_(edge_index).c2_ = n+1;
        else
            warning('YT: cannot change the data in edges\n');
        end
    end
end

%% Now it is time to color the cell and calculate the cost
newproblem.all_cell_(index).color_ = color;
newproblem.all_cell_(index).open_ = false;
% judge which edges are going to be merged
count = zeros(size(newproblem.all_cell_, 1), 1);
mergeedgelist = [];
for i = 1:size(newproblem.all_cell_(index).edges_, 1)
    edge_index = newproblem.all_cell_(index).edges_(i);
    adj_index = newproblem.all_edge_(edge_index).theOther(index);
    if newproblem.all_edge_(edge_index).constraint_ ~= 1
        continue;
    end
    if adj_index == -1
        continue;
    end
    if newproblem.all_cell_(adj_index).open_ == true
        continue;
    end
    if newproblem.all_cell_(adj_index).color_ == newproblem.all_cell_(index).color_
        mergeedgelist = [mergeedgelist; edge_index];
        count(adj_index) = 1;
    else
        warning('YT: the adjacent cell has wrong color\n');
    end
end

%% TODO: check whether we should delete the count(index) itself. 
% It may cause error in calculating cost
if count(index) == 1
    warning('YT: we have not finish merging a ring. But why it occurs? Should it be merged before we enter the iteration? \n');
end

newproblem.mergeCells(index, mergeedgelist);
newproblem.current_cost_ = newproblem.current_cost_ + 1 - sum(count);

