classdef Cell<handle
    properties(SetAccess = private, GetAccess = public)
        index_
        ver_
        tri_
        boundary_
        adj_

        connect_edge_% n*1 array, stores the index of the adjacent cells
        topo_edge_
    end
    properties(SetAccess = public, GetAccess = public)
        topo_edge_index_ 
        % each row stores the position of the start vertex and the end 
        % vertex of this topological edge in the whole boundary
        
        topo_ver_;
        %
        
        possible_color_% 1*n array. Improvement: Should be n*1 array
        % The number of possible color may different from its vertices, if
        % the color is sure to be of no usage
    end
    methods
        function obj = Cell(index, seed_index, our_ver)
            obj.index_ = index;
            obj.ver_ = [];
            obj.exploring(seed_index, our_ver);
            obj.findBoundary(our_ver);
        end
        
        
    end
end
