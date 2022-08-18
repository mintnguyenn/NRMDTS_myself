function mergeTwoOrdinCell(obj, c1, c2)
% mergeTwoOrdinCell(obj, c1, c2)
% the generated cell is indexed by c1
% merge two colored (and closed) cells which both have more than two topological edges.
% So this function won't change any cost
% However, it may generate (colored) rings
% Last rewritten: 2019-12-06

v1 = obj.all_cell_(c1).vertex_;
v2 = obj.all_cell_(c2).vertex_;
origin_e1 = obj.all_cell_(c1).edges_;
origin_e2 = obj.all_cell_(c2).edges_;

%% Check whether the merged region is simply-connected
tobemerged = intersect(origin_e1, origin_e2);
if size(tobemerged, 1) == 1
    simply_connected = true;
else
    %we locate the edges
    loc1 = zeros(size(origin_e1, 1), 1);
    loc2 = zeros(size(origin_e2, 1), 1);
    for i = 1:size(origin_e1, 1)
        if any(tobemerged == origin_e1(i))
            loc1(i) = 1;
        end
    end
    for i = 1:size(origin_e2, 1)
        if any(tobemerged == origin_e2(i))
            loc2(i) = 1;
        end
    end
    % Rotate the numbers to let the first number be 1
    B = find(loc1 == 1);
    if B(1) ~= 1
        loc1 = [loc1(B(1):end); loc1(1:B(1)-1)];
    else
        while ~isempty(loc1) && loc1(end) == 1
            loc1(end) = [];
        end
    end
    
    B = find(loc2 == 1);
    if B(1) ~= 1
        loc2 = [loc2(B(1):end); loc2(1:B(1)-1)];
    else
        while ~isempty(loc1) && loc2(end) == 1
            loc2(end) = [];
        end
    end
    
    % Remove the first continuous 1s, and see whether there is 1 in the left number
    while ~isempty(loc1) && loc1(1) == 1
        loc1(1) = [];
    end
    while ~isempty(loc2) && loc2(1) == 1
        loc2(1) = [];
    end
    if any(loc1 == 1) || any(loc2 == 1)
        simply_connected = false;
    else
        simply_connected = true;
    end
end

%% If the result cell is simply-connected, then we directly solve it
if simply_connected
    % We just rotate the number and close the corresponding edges
    % locate the position of the to be merged edges
    loc1 = origin_e1;
    loc2 = origin_e2;

    [loc1, ordered_v1] = rotateArray(loc1, tobemerged, v1);
    [loc2, ordered_v2] = rotateArray(loc2, tobemerged, v2);
    n = size(tobemerged, 1);
    
    newedgeindex = [loc1(n+1:end);loc2(n+1:end)];
    newvertex = [ordered_v1(n+1:end); ordered_v2(n+1:end)];
    
    % all merged edges are of no usage
    for i = 1:size(tobemerged, 1)
        obj.all_edge_(tobemerged(i)).no_use_ = true;
    end
    
    obj.all_cell_(c2).merged_ = true;
    
    obj.all_cell_(c1).same_ = [obj.all_cell_(c1).same_; obj.all_cell_(c2).same_; c2];
    obj.all_cell_(c2).same_ = [];
    
    obj.all_cell_(c1).vertex_ = newvertex;
    obj.all_cell_(c1).edges_ = newedgeindex;
    for i = n+1:size(loc2, 1)
        edge_index = loc2(i);
        if obj.all_edge_(edge_index).c1_ == c2
            obj.all_edge_(edge_index).c1_ = c1;
        elseif obj.all_edge_(edge_index).c2_ == c2
            obj.all_edge_(edge_index).c2_ = c1;
        else
            warning('YT: cannot change the index of the edge of the c2 cell\n');
        end
    end
    
else
    %% TODO: If the graph generates a ring, we should write the code
    warning('YT: We have not prepared the merging function for generating rings\n');
end

end