classdef Node<handle
    properties(GetAccess = public, SetAccess = private)
        index_
        origin_edges_% store the index of the edges when first create this node
    end
    properties
        edges_% n*1 array, Edge index stored in CCW order
        vertex_% n*1 aray, Topological vertices in CCW order
        
        %n*1 array
        possible_color_%n*1 array
        open_
        
        merged_ 
        divided_ % If this cell is divided, the here is true. For the recovery of the physical division path.

        color_
        father_
        son_
        same_
    end
    methods
        function newnode = copy(obj)
            %because the handle class doesnot have deep copy function
            
            newnode = Node();
            newnode.index_ = obj.index_;
            newnode.color_ = obj.color_;
            
            newnode.merged_ = obj.merged_;
            newnode.divided_ = obj.divided_;
            newnode.open_ = obj.open_;
            newnode.possible_color_ = obj.possible_color_;
            
            newnode.edges_ = obj.edges_;
            newnode.vertex_ = obj.vertex_;
            
            newnode.origin_edges_ = obj.origin_edges_;
            newnode.father_ = obj.father_;
            newnode.same_ = obj.same_;
            newnode.son_ = obj.son_;
        end
        
        function obj = Node(index, C, Edgelist, VertexList)
            %now C is 1*n array, but the possible_color_ is n*1 array
            %myedge is n*1 array
            if nargin == 0
                return ;
            end
            obj.open_ = true;
            obj.merged_ = 0;
            obj.divided_ = false;
            obj.index_ = index;
            obj.color_ = -1;
            obj.possible_color_ = sort(C');
            obj.edges_ = Edgelist;
            obj.vertex_ = VertexList;
            obj.origin_edges_ = Edgelist;
            return
        end
        function showNode(obj)
            fprintf('Node: index = %d, ', obj.index_);
            fprintf('Color = %d, ', obj.color_);
            fprintf('Open = %d, ', obj.open_);
            
            fprintf('PColor: ');
            if ~isempty(obj.possible_color_)
                for i = 1:size(obj.possible_color_, 1)
                    fprintf('%d, ', obj.possible_color_(i));
                end
            end
            
            fprintf('merged: %d, ', obj.merged_);
            fprintf('divided: %d, ', obj.divided_);
            if ~isempty(obj.same_)
                fprintf('same: ');
                for i = 1:size(obj.same_, 1)
                    fprintf('%d, ', obj.same_(i));
                end
            end
            
            fprintf('Edge: ');
            if isempty(obj.edges_)
                fprintf('\n');
                return ;
            end
            for i = 1:size(obj.edges_, 1)
                edge_index = obj.edges_(i);
                fprintf('%d, ', edge_index);
            end
            
            fprintf('origin_edges_: ');
            for i = 1:size(obj.origin_edges_, 1)
                fprintf('%d, ', obj.origin_edges_(i));
            end
            fprintf('\n');
        end
    end
end