function solveProblem(obj, percent)
% The difference between "solveProblem" and "solveIso" is that
% solveIso will finally change the origin graph, but the solveProblem will
% create new branches instead.

if obj.isSolved()
    return ;
end


global global_depth;
global global_loop;
% global global_cost;
% global global_solution;
global global_percent;
global_depth = global_depth + 1;
global_loop = global_loop + 1;
% fprintf('Solving Problem in Level:  %d, loop time: %d\n', global_depth, global_loop);

%% Find the first unsolved cell
index = -1;
for i = 1:size(obj.all_cell_, 1)
    if obj.all_cell_(i).open_ == true
        index = i;
        break;
    end
end
if index == -1
    warning('YT: we cannot find an unsolved cell in solveProblem\n');
end

%% We create a mapping that gives correct assumptions
mapping = [];
origin_word = [];
for i = 1:size(obj.all_cell_(index).edges_, 1)
    edge_index = obj.all_cell_(index).edges_(i);
    if obj.all_edge_(edge_index).constraint_ == 0
        mapping = [mapping; i];
    end
    origin_word(1, i) = obj.all_edge_(edge_index).constraint_;
end
origin_word = origin_word';

%% make assumptions on the connectivity on one cell
n = size(mapping, 1);
branchcost = [];
branchproblem = [];
for i = 1:2^n
    j = 1:n;
    reduced_word = rem(floor((i-1)./2.^(j-1)), 2);
    word = origin_word;
%     for j = 1:n
        word(mapping(j), 1) = reduced_word(1, j);
%     end
    if ~obj.isValidAssumption(word, index)% Here the word contains -1, 0, 1
        continue;
    end
    
    %% Zero Connect Solve
    if sum(word == 1) == 0
        m = size(obj.all_cell_(index).possible_color_, 1);
        allcolorcost = [];
        allcolorproblem = [];
        for k = 1:m
            newproblem = obj.purelyCopy();
            newproblem.ZeroConnectSolve(index, k);
            if newproblem.current_cost_ ~= inf
                if newproblem.isSolved()
                    allcolorproblem = [allcolorproblem; newproblem];
                    allcolorcost = [allcolorcost; newproblem.current_cost_];
                    updateGlobalSolution(newproblem);
                elseif newproblem.current_cost_ ~= inf
                    newproblem.Stablizer();
                    newproblem.solveProblem(percent/(2^n));
                    if newproblem.current_cost_ ~= inf
                        updateGlobalSolution(newproblem);
                        allcolorproblem = [allcolorproblem; newproblem];
                        allcolorcost = [allcolorcost; newproblem.current_cost_];
                    end
                end
            end
        end
        % All element in "aljlcolorproblem" must be totally solved
        if ~isempty(allcolorcost)
            [~, loc] = min(allcolorcost);
            bestcolorproblem = allcolorproblem(loc);
            branchcost = [branchcost; bestcolorproblem.current_cost_];
            branchproblem = [branchproblem; bestcolorproblem];
        end
        continue;
    end
    
    %% One Connect Solve
    if sum(word == 1) == 1
        m = size(obj.all_cell_(index).possible_color_, 1);
        allcolorcost = [];
        allcolorproblem = [];
        for k = 1:m
            newproblem = obj.purelyCopy();
            newproblem.OneConnectSolve(index, word, k);
            if newproblem.current_cost_ ~= inf
                if newproblem.isSolved()
                    updateGlobalSolution(newproblem);
                    allcolorproblem = [allcolorproblem; newproblem];
                    allcolorcost = [allcolorcost; newproblem.current_cost_];
                else
                    newproblem.Stablizer();
                    if newproblem.current_cost_ ~= inf
                        newproblem.solveProblem(percent/(2^n));
                    end
                    updateGlobalSolution(newproblem);
                    allcolorproblem = [allcolorproblem; newproblem];
                    allcolorcost = [allcolorcost; newproblem.current_cost_];
                end
            end
        end
        if ~isempty(allcolorcost)
            [~, loc] = min(allcolorcost);
            bestcolorproblem = allcolorproblem(loc);
            branchcost = [branchcost; bestcolorproblem.current_cost_];
            branchproblem = [branchproblem; bestcolorproblem];
        end
        continue;
    end
    
    %% All Connect Solve
    if all(word == 1) == 1
        m = size(obj.all_cell_(index).possible_color_, 1);
        allcolorcost = [];
        allcolorproblem = [];
        for k = 1:m
            newproblem = obj.purelyCopy();
            newproblem.AllConnectSolve(index, k);
            if newproblem.current_cost_ ~= inf
                if newproblem.isSolved()
                    updateGlobalSolution(newproblem);
                    allcolorproblem = [allcolorproblem; newproblem];
                    allcolorcost = [allcolorcost; newproblem.current_cost_];
                else
                    newproblem.Stablizer();
                    if newproblem.current_cost_ ~= inf
                        newproblem.solveProblem(precent/(2^n));
                    end
                    updateGlobalSolution(newproblem);
                    allcolorproblem = [allcolorproblem; newproblem];
                    allcolorcost = [allcolorcost; newproblem.current_cost_];
                end
            end
        end
        if ~isempty(allcolorcost)
            [~, loc] = min(allcolorcost);
            bestcolorproblem = allcolorproblem(loc);
            branchcost = [branchcost; bestcolorproblem.current_cost_];
            branchproblem = [branchproblem; bestcolorproblem];
        end
        continue;
    end
    
    
    %% Full Partitions
    word(word == -1) = 0;
    fullPartition = wordFullPartition(word);
    
    allcolorcost = [];
    allcolorproblem = [];
    
    for j = 1:size(fullPartition, 1)
        m = size(obj.all_cell_(index).possible_color_, 1);
        for k = 1:m
            newproblem = obj.splitCell(index, word, fullPartition{j, 1}, k);
            if newproblem.current_cost_ ~= inf
                newproblem.Stablizer();
                if  newproblem.isSolved()
                    updateGlobalSolution(newproblem);
                    allcolorcost = [allcolorcost; newproblem.current_cost_];
                    allcolorproblem = [allcolorproblem; newproblem];
                else
                    newproblem.solveProblem(percent/(2^n));
                    if newproblem.current_cost_ ~= inf
                        updateGlobalSolution(newproblem);
                        allcolorcost = [allcolorcost; newproblem.current_cost_];
                        allcolorproblem = [allcolorproblem; newproblem];
                    end
                end
            end
        end
    end
    
    if ~isempty(allcolorcost)
        [~, loc] = min(allcolorcost);
        bestcolorproblem = allcolorproblem(loc);
        branchcost = [branchcost; bestcolorproblem.current_cost_];
        branchproblem = [branchproblem; bestcolorproblem];
    end
    
    global_percent = global_percent + percent/(2^n);
    fprintf('Percent: ');
    vpa(global_percent, 20)
    fprintf('\n');
end

if isempty(branchcost)
    obj.current_cost_ = inf;
    return ;
else
    [~, loc] = min(branchcost);
    bestproblem = branchproblem(loc);
    obj.all_cell_ = copyElement(bestproblem.all_cell_);
    obj.all_edge_ = copyElement(bestproblem.all_edge_);
    obj.C_ = bestproblem.C_;
    obj.current_cost_ = bestproblem.current_cost_;
end

fprintf('Finsh Problem in Level:  %d\n', global_depth);
global_depth = global_depth - 1;

end

