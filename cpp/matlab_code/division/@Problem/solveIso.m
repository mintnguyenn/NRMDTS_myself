function solveIso(obj, index)

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

n = size(mapping, 1);
branchcost = [];
branchproblem = [];
for i = 1:2^n
    j = 1:n;
    reduced_word = rem(floor((i-1)./2.^(j-1)), 2);
    word = origin_word;
    for j = 1:n
        word(mapping(j), 1) = reduced_word(1, j);
    end
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
                allcolorproblem = [allcolorproblem; newproblem];
                allcolorcost = [allcolorcost; newproblem.current_cost_];
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
    
    %% One Connect Solve
    if sum(word == 1) == 1
        m = size(obj.all_cell_(index).possible_color_, 1);
        allcolorcost = [];
        allcolorproblem = [];
        for k = 1:m
            newproblem = obj.purelyCopy();
            newproblem.OneConnectSolve(index, word, k);
            if newproblem.current_cost_ ~= inf
                allcolorproblem = [allcolorproblem; newproblem];
                allcolorcost = [allcolorcost; newproblem.current_cost_];
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
                allcolorproblem = [allcolorproblem; newproblem];
                allcolorcost = [allcolorcost; newproblem.current_cost_];
            end
%             if newproblem.current_cost_ ~= inf
%                 if newproblem.isSolved()
%                     updateGlobalSolution(newproblem);
%                     allcolorproblem = [allcolorproblem; newproblem];
%                     allcolorcost = [allcolorcost; newproblem.current_cost_];
%                 else
%                     newproblem.Stablizer();
%                     if newproblem.current_cost_ ~= inf
%                         newproblem.solveProblem(precent/(2^n));
%                     end
%                     updateGlobalSolution(newproblem);
%                     allcolorproblem = [allcolorproblem; newproblem];
%                     allcolorcost = [allcolorcost; newproblem.current_cost_];
%                 end
%             end
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
    %Still some problems, we should also regard -1 as 0
    for i = 1:size(word, 1)
        if word(i) == -1
            word(i) = 0;
        end
    end
    fullPartition = wordFullPartition(word);
    
    allcolorcost = [];
    allcolorproblem = [];
    for j = 1:size(fullPartition, 1)
        m = size(obj.all_cell_(index).possible_color_, 1);
        for k = 1:m
            newproblem = obj.splitCell(index, word, fullPartition{j, 1}, k);
            % The "newproblem" will run its Stablizer in its construction
            % function
            if newproblem.current_cost_ ~= inf && newproblem.isSolved() == false
                newproblem.Stablizer();
            end            
            if newproblem.current_cost_ ~= inf
                allcolorcost = [allcolorcost; newproblem.current_cost_];
                allcolorproblem = [allcolorproblem; newproblem];
            end
        end
    end
    if ~isempty(allcolorcost)
        [~, loc] = min(allcolorcost);
        bestcolorproblem = allcolorproblem(loc);
        branchcost = [branchcost; bestcolorproblem.current_cost_];
        branchproblem = [branchproblem; bestcolorproblem];
    end
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

end