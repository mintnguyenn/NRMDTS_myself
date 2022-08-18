function updateGlobalSolution(solved_problem)
newcost = solved_problem.current_cost_;
if newcost == inf
    return ;
end

global global_cost;
if global_cost < newcost
    return ;
end

global global_solution;
if global_cost == newcost
    n = size(global_solution, 1);
    global_solution{n+1, 1} = solved_problem.purelyCopy();
else
    global_solution = cell(0);
    global_solution{1, 1} = solved_problem.purelyCopy();
    global_cost = newcost;
end




