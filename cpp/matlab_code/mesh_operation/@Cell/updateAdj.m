function updateAdj(obj, our_ver)
% updateAdj(obj, our_ver)
% After create all topological cells, we collect all 

global global_generalized_tri;

% YT: 11.29 Why there is no problem when cannot find the opposite triangle?
% 
%% Collect the opposite triangles for all edges of this cell
theother = [];
bd = [obj.boundary_; obj.boundary_(1)];% this boundary is actually vertex list
for i = 1:size(bd, 1) - 1
    v1 = bd(i);
    v2 = bd(i+1);
    b = findTri(global_generalized_tri, v2, v1);
    if b == -1
        theother = [theother; -1];
        continue;
    end
    %find the other vertex, which should be an original vertex in the mesh
    v3 = theOtherVertex(global_generalized_tri(b, :), v1, v2);
    if ~isempty(our_ver(v3).cell_)
        theother = [theother; our_ver(v3).cell_];
    else
        theother = [theother; -1];
    end
end

%% unique the edgelist
% combine the edges if they have the same opposite cell, which generates the
% topological edges
topo_edge = cell(0);
obj.connect_edge_ = [];
startnum = -1;
current_adj_cell = -1;
for i = 1:size(theother, 1)
    if startnum == -1
        
        startnum = i;
        current_adj_cell = theother(i);
    else% startnum ~= -1
        if theother(i) == current_adj_cell
            continue;
        else
            n = size(topo_edge, 2);
            topo_edge{n+1} = [startnum, i-1];
            obj.connect_edge_ = [obj.connect_edge_; current_adj_cell];
            
            startnum = i;
            current_adj_cell = theother(i);
            
        end
    end
end

% we add the final edge
n = size(topo_edge, 2);
topo_edge{n+1} = [startnum, size(theother, 1)];
obj.connect_edge_ = [obj.connect_edge_; current_adj_cell];

% we check whether the first edge and the final edge are the same
if size(obj.connect_edge_, 1) ~= 1 && theother(1) == theother(end)
    topo_edge{1} = [topo_edge{end}, topo_edge{1}];
    topo_edge(:, end) = [];
    obj.connect_edge_(end) = [];
end

obj.topo_edge_ = topo_edge';

obj.topo_edge_index_ = zeros(size(obj.topo_edge_, 1), 1);
end
