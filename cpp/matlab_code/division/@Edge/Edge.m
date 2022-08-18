classdef Edge<handle
    properties(SetAccess = private, GetAccess = public)
        origin_edge_
        index_% the index of this edge in the edge list
        in_which_cell_% store the index of the cell when create this edge
        endpoints_% The index of its endpoints in global_generalized_ver. Once the edge is created, the endpoints will not change
    end
    properties
        c1_%cell 1
        c2_%cell 2, without order
        constraint_
        %constraint_ = 1: must connect
        %constraint_ = 0: no constraint
        %constraint_ = -1: mustn't connect
        no_use_
    end
    methods
        function newedge = copy(obj)
            newedge = Edge();
            newedge.c1_ = obj.c1_;
            newedge.c2_ = obj.c2_;
            newedge.constraint_ = obj.constraint_;
            newedge.index_ = obj.index_;
            newedge.origin_edge_ = obj.origin_edge_;
            newedge.no_use_ = obj.no_use_;
            newedge.in_which_cell_ = obj.in_which_cell_;
        end
        function obj = Edge(index1, index2, constraint, edgeindex)
            if nargin == 0
                return;
            end
            obj.c1_ = index1;
            obj.c2_ = index2;
            obj.origin_edge_ = [index1, index2];
            obj.constraint_ = constraint;
            obj.index_ = edgeindex;
            obj.no_use_ = 0;
            % If the edge does not connect two cells, it must be -1
            if index1 == -1 || index2 == -1
                obj.constraint_ = -1;
                obj.no_use_ = 1;
            end
            return ;
        end
        function setFather(obj, cell_index)
            obj.in_which_cell_ = cell_index;
        end
    end
    
end