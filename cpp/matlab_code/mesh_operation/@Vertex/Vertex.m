classdef Vertex<handle
    properties(SetAccess = private, GetAccess = public)
        position_
        index_
        adj_ver_% all adjacent vertices should be stored in CCW order
        no_use_
        normal_
        
    end
    properties(SetAccess = public, GetAccess = public)
        IK_
        cell_
        color_
    end
    methods
        function removeIK(obj, i)
            obj.IK_(i, :) = [];
            obj.color_(i) = [];
        end
        function newvertex = copyElement(obj)
            newvertex = Vertex(obj.position_, obj.color_, obj.cell_, ...
                obj.index_, obj.adj_ver_, obj.no_use_, obj.normal_);
        end
        function obj = Vertex(varargin)
            %position, index
            %position_, color_, cell_, index_, adj_ver_, no_use_, normal_
            global global_ver_normal;
            global global_CChandle;
            if nargin == 2
                obj.position_ = varargin{1};
                obj.cell_ = [];
                obj.index_ = varargin{2};
                obj.update_adj_ver();
                obj.no_use_ = obj.isNoUse();
                obj.calNormal();
                
                % calNormal = empty means it is not in the mesh
                % no_use_ means it is at the boundary of the mesh
                if ~obj.no_use_ && any(obj.normal_)
                    obj.IK_ = IK(obj.position_(1), obj.position_(2), obj.position_(3), ...
                        -global_ver_normal(obj.index_, 1), -global_ver_normal(obj.index_, 2), -global_ver_normal(obj.index_, 3));
                    

                    %% TODO: Consider the constraints of static force
                    for i = size(obj.IK_, 1):-1:1
                        if ~dynamicConstraint5D(obj.IK_(i, :))
                            obj.IK_(i, :) = [];
                        end
                    end
                    
                    
                    %% TODO: Consider the collision-detection

                    for i = size(obj.IK_, 1):-1:1
                        if ~global_CChandle(obj.IK_(i, :))
                            obj.IK_(i, :) = [];
                        end
                    end

                    
                    if  ~isempty(obj.IK_)
                        obj.color_ = zeros(1, size(obj.IK_, 1));
                    else
                        obj.color_ = [];
                    end
                else
                    obj.IK_ = [];
                    obj.color_ = [];
                end
                
            elseif nargin == 5
                obj.position_ = varargin{1};
                obj.color_ = varargin{2};
                obj.cell_ = varargin{3};
                obj.index_ = varargin{4};
                obj.adj_ver_ = varargin{5};
                obj.no_use_ = varargin{6};
                obj.normal_ = varargin{7};
            else
                fprintf('YT: error construction functions\n');
            end
        end
    end
    
end