function mergeCells(obj, index, mergeedgelist)
% mergeCells(obj, index, mergeedgelist)
% Here mergeedgelist is n*1 array
% all cells to be merged must be first closed
% The number in the mergeedgelist is the edge_index of all waiting to be merged edges,
% not the index of these edges in the current cell.

mergecelllist = [];
for i = 1:size(mergeedgelist, 1)
    adj_index = obj.all_edge_(mergeedgelist(i)).theOther(index);
    mergecelllist = [mergecelllist; adj_index];
end

% Maybe the two cells have multi connecting edges, then we should check whether the two cells have been merged before running the second edge.
mergecelllist = unique(mergecelllist);
mergecelllist = [index; mergecelllist];

%% we merge the cell one by one
% all cell must be closed and have same color
color = obj.all_cell_(index).color_;
for i = 1:size(mergecelllist, 1)
    if obj.all_cell_(mergecelllist(i)).open_ == true
        warning('YT: error, all cells to be merged must first be closed\n');
    elseif obj.all_cell_(mergecelllist(i)).color_ ~= color
        warning('YT: error, all cells to be merged must have same color\n');
    end
end

%% In each iteration we only deal with the top 2 edges
while size(mergecelllist, 1) ~= 1
    c1 = mergecelllist(1);% always be the index of the main cell
    c2 = mergecelllist(2);% always be an adjacent cell
    v1 = obj.all_cell_(c1).vertex_;
    v2 = obj.all_cell_(c2).vertex_;
    origin_e1 = obj.all_cell_(c1).edges_;
    origin_e2 = obj.all_cell_(c2).edges_;
    
    %% If one of the cells only has one edge, we direct merge them
    if size(origin_e1, 1) == 1 || size(origin_e2, 1) == 1
        obj.mergeOneEdgeCell(c1, c2);
        mergecelllist(2) = [];
        continue;
    end
    
    %% If one of the cells only has two edges, we direct merge them
    if size(origin_e1, 1) == 2 || size(origin_e2, 1) == 2
        obj.mergeTwoEdgeCell(c1, c2);
        mergecelllist(2) = [];
        continue;
    end
    
    obj.mergeTwoOrdinCell(c1, c2);
    mergecelllist(2) = [];
    
end

