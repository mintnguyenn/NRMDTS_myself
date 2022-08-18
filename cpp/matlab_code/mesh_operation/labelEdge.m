function topo_edgelist = labelEdge(ytCell)
% topo_edgelist = labelEdge(ytCell)
% We give each topological edge an index


topo_edgelist = [];
for i = 1:size(ytCell, 1)
    for j = 1:size(ytCell(i).topo_edge_index_, 1)
        if ytCell(i).topo_edge_index_(j) == 0
            %this edge has not been registered into the topo_edge_list;
            
            %find a representitive of the topo_edge
            index = ytCell(i).topo_edge_{j}(1);
            
            %find which adjacent cell is
            adj_cell = ytCell(i).connect_edge_(j);
            
            if adj_cell ~= -1
                %locate this topo_edge in the adjacent cell
                v1 = ytCell(i).boundary_(index);
                v2 = ytCell(i).boundary_(index+1);
                
                %find the other vertex, which should be a original vertex in the mesh
                adj_index = -1;
                for k = 1:size(ytCell(adj_cell).boundary_, 1)
                    if ytCell(adj_cell).boundary_(k) == v2
                        if k ~= size(ytCell(adj_cell).boundary_, 1)
                            if ytCell(adj_cell).boundary_(k+1) == v1
                                adj_index = k;
                                break;
                            end
                        else
                            if ytCell(adj_cell).boundary_(1) == v1
                                adj_index = k;
                                break;
                            end
                        end
                    end
                end
                
                if adj_index == -1
                    warning('YT: error, cannot find corresponding edge in the boundary of adj_cell\n');
                end
                for k = size(ytCell(adj_cell).topo_edge_, 1):-1:1
                    if ytCell(adj_cell).topo_edge_{k}(1) <= adj_index && ...
                            ytCell(adj_cell).topo_edge_{k}(2) >= adj_index
                        break;
                    end
                end
                adj_j = k;
            end
            
            
            %register it in all place
            n = size(topo_edgelist, 1);
            ytCell(i).topo_edge_index_(j) = n+1;
            if adj_cell ~= -1
                ytCell(adj_cell).topo_edge_index_(adj_j) = n+1;
            end
            topo_edgelist = [topo_edgelist; [i, adj_cell]];
        end
    end
end
end
