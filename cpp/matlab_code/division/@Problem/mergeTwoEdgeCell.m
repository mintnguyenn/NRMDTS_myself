function mergeTwoEdgeCell(obj, c1, c2)
% mergeTwoEdgeCell(obj, c1, c2)
% The first cell is kept
% 2+2: create an island
% 2+n: create a new cell with no topological vertex changing
% Last rewritten: 2019-12-07

%% For the type of 2+2
if size(obj.all_cell_(c1).edges_, 1) == 2 && size(obj.all_cell_(c2).edges_, 1) == 2
    warning('YT: we have not write this part\n');
    obj.merge2plus2(c1, c2);
    return ;
end

%% For the type of 2+n
if size(obj.all_cell_(c1).edges_, 1) == 2 && size(obj.all_cell_(c2).edges_, 1) > 2
    obj.merge2plusn(c1, c2);
    return ;
end

%% For the type of n+2
if size(obj.all_cell_(c1).edges_, 1) > 2 && size(obj.all_cell_(c2).edges_, 1) == 2
    obj.mergenplus2(c1, c2);
    return ;
end

warning('YT: we should not reach here.\n ');

% if size(obj.all_cell_(maincell_index).edges_, 1) == 2
%     if size(intersect(obj.all_cell_(maincell_index).edges_, obj.all_cell_(adjcell_index).edges_), 1) == 2
%         warning('YT: There is a cell covering another cell\n');
%         return ;
%     end
%     edge_index = intersect(obj.all_cell_(maincell_index).edges_, obj.all_cell_(adjcell_index).edges_);
%     theother_edge = setdiff(obj.all_cell_(maincell_index).edges_, edge_index);
%     new_edge = obj.all_cell_(adjcell_index).edges_;
%     new_edge(new_edge == edge_index) = theother_edge;
%     for i = 1:size(new_edge, 1)
%         if new_edge(i) == theother_edge
%             continue;
%         end
%         if obj.all_edge_(new_edge(i)).c1_ == adjcell_index
%             obj.all_edge_(new_edge(i)).c1_ = maincell_index;
%         elseif obj.all_edge_(new_edge(i)).c2_ == adjcell_index
%             obj.all_edge_(new_edge(i)).c2_ = maincell_index;
%         else
%             warning('YT: cannot change the cell of the edge in mergeTwoEdgeCell\n');
%         end
%     end
%     
%     obj.all_cell_(adjcell_index).open_ = false;
%     obj.all_cell_(adjcell_index).merged_ = true;
%     obj.all_cell_(maincell_index).same_ = [obj.all_cell_(maincell_index).same_; obj.all_cell_(adjcell_index).same_; adjcell_index];
%     obj.all_cell_(adjcell_index).same_ = [];
%     obj.all_cell_(maincell_index).vertex_ = obj.all_cell_(adjcell_index).vertex_;
%     obj.all_cell_(maincell_index).edges_ = new_edge;
%     
% else
    
    
end