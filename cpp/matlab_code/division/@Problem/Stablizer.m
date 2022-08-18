function Stablizer(obj)
% We only want to get a minimum cost solution, so here we may omit the
% multiple choices of solutions under the same minimum cost

global global_cost;
global global_solution;

if obj.current_cost_ == inf
    fprintf('This problem has been deleted\n');
    return ;
end

%% Try to simplify the graph
%Here we can develop as many tricks as we want

%If two adjacent cell do not have same possible colors, then we set the
%constraints of the edges to be -1
for i = 1:size(obj.all_edge_, 1)
    c1 = obj.all_edge_(i).c1_;
    c2 = obj.all_edge_(i).c2_;
    if c1 == -1 || c2 == -1
        continue;
    end
    if obj.all_edge_(i).no_use_ == true
        continue;
    end
    if obj.all_edge_(i).constraint_ == 0 && ...
            isempty(intersect(obj.all_cell_(c1).possible_color_, ...
            obj.all_cell_(c2).possible_color_))
        obj.all_edge_(i).constraint_ = -1;
    end
end

%% Check whether the constraint on the edges can be satisfied
for i = 1:size(obj.all_edge_, 1)
    if ~isConstraintSatisfied(obj, i)
        obj.current_cost_ = inf;
        return ;
    end    
end


%% Try to solve all solvable(isolated) cells
stable = false;% keep looping the graph until no isolated cells
while stable == false
    stable = true;
    for i = 1:size(obj.all_cell_, 1)
        if obj.all_cell_(i).open_ == false
            continue;%check the next cell
        end
        
        
        %% One Color Cell
        if size(obj.all_cell_(i).possible_color_, 1) == 1
            obj.OneColorSolve(i);
            if obj.current_cost_ == inf
                return ;
            end
            stable = false;
            break;
        end
        
        %% Isolated cell
        if ~isIso(obj, i)
            continue;
        end
        
        %% enumSolver, which is for isolated cells
        if size(obj.all_cell_(i).edges_, 1) <= 3
            obj.enumSolve(i);
            %copy the data to return the value
            if obj.current_cost_ == inf
                return ;
            end
            stable = false;
            break;
        end
        
        %% divide and conquer
        obj.solveIso(i);
        if obj.current_cost_ == inf
            return ;
        end
        stable = false;
        break;
    end
end%while

%% If the problem does not have any unsolved cell, we have got some solutions
if obj.isSolved()
    if obj.current_cost_ < global_cost
        global_cost = obj.current_cost_;
        global_solution = cell(0);
        global_solution{1, 1} = obj.purelyCopy();
    elseif obj.current_cost_ == global_cost
        n = size(global_solution, 1);
        global_solution{n+1, 1} = obj.purelyCopy();
    end
end
%% Orelse we just leave those unsolved cells to the next step

end