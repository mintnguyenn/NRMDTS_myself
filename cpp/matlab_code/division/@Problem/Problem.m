classdef Problem<handle
    properties(SetAccess = private, GetAccess = public)
        % all variables are not globally defined, because of iteration
        all_cell_ %n*1, all cells
        C_%n*1 cells, each cell is n*1 array, all avaliable color for each vertex
        all_edge_%n*1, all edges
        current_cost_
       
    end
    methods
        function newproblem = copy(obj)
            newproblem = obj.purelyCopy();
            newproblem.Stablizer();
        end
        function newproblem = purelyCopy(obj)
            newproblem = Problem();
            newproblem.all_cell_ = [];
            for i = 1:size(obj.all_cell_, 1)
                newproblem.all_cell_ = [newproblem.all_cell_; obj.all_cell_(i).copy()];
            end
%             newproblem.all_cell_ = copyElement(obj.all_cell_);
            newproblem.C_ = obj.C_;
            
            newproblem.all_edge_ = [];
            for i = 1:size(obj.all_edge_, 1)
                newproblem.all_edge_ = [newproblem.all_edge_; obj.all_edge_(i).copy()];
            end
            newproblem.current_cost_ = obj.current_cost_;
        end
        function obj = Problem(C, E, EdgeList, VertexList, input_cost)
            if nargin == 0
                return ;
            end
            obj.C_ = C;% store all available color for all points
            obj.current_cost_ = input_cost;
            obj.all_edge_ = E;
            
            obj.all_cell_ = [];
            fprintf('YT create problem\n');
            for i = 1:size(C, 1)
                obj.all_cell_ = [obj.all_cell_;
                    Node(i, C{i}, EdgeList{i}, VertexList{i})];
            end
            obj.Stablizer();
        end
        
        function showProblem(obj)
            if isempty(obj.all_edge_)
                return ;
            end
            showEdge(obj.all_edge_);
            if isempty(obj.all_cell_)
                return;
            end
            showCell(obj.all_cell_);
            fprintf('Current Cost: %d\n', obj.current_cost_);
        end
        
        function b = isSolved(obj)
            for i = 1:size(obj, 1)
                b = true;
                for i = 1:size(obj.all_cell_, 1)
                    if obj.all_cell_(i).open_ == true
                        b = false;
                        return ;
                    end
                end
            end
        end
    end
end