function [topo_edgelist, ytCell, our_ver] = slightlyChangeBoundary(ytCell, our_ver)

for i = 1:size(ytCell, 1)
    ytCell(i).updateAdj(our_ver);
end

%% Decide the index of the adjacent cells of each cell
topo_edgelist = labelEdge(ytCell);


repour = false;
for i = 1:size(ytCell, 1)
    if ytCell(i).isAllBoundary(our_ver)
        % We directly delete the small cells which are near the boundary of
        % the reachability. 
        
        % For an island cell
        if ytCell(i).connect_edge_ == -1
            for j = 1:size(ytCell(i).ver_, 1)
                our_ver(ytCell(i).ver_(j)).IK_ = [];
                our_ver(ytCell(i).ver_(j)).color_ = [];
            end
            repour = true;
            continue;
        end
        
        color = ytCell(i).possible_color_;

%         % For a boundary cell
%         if sum(ytCell(i).connect_edge_ ~= -1) == 1
%             adj_cell = setdiff(ytCell(i).connect_edge_, -1);
%             adj_color = ytCell(adj_cell).possible_color_;
%             if isempty(setdiff(adj_color, color))
%                 % We can merge this cell to the adj_cell through removing
%                 % some configurations
%                 
%                 % find the color to be removed
%                 no_use_color = setdiff(color, adj_color);
%                 for j = 1:size(ytCell(i).ver_, 1)
%                     for k = 1:size(no_use_color, 1)
%                         b = find(our_ver(ytCell(i).ver_(j)).color_ == no_use_color(k));
%                         our_ver(ytCell(i).ver_(j)).color_(b) = [];
%                         our_ver(ytCell(i).ver_(j)).IK_(b, :) = [];
%                     end
%                 end
%                 repour = true;
%                 continue;
%             else
%                 % We should directly remove all IKs
%                 for j = 1:size(ytCell(i).ver_, 1)
%                     our_ver(ytCell(i).ver_(j)).IK_ = [];
%                     our_ver(ytCell(i).ver_(j)).color_ = [];
%                 end
%                 repour = true;
%                 continue;
%             end
%             continue;
%         end
        
        if size(ytCell(i).ver_, 1) == 1
        % The cell has multiple non-trivial adjacent cells
        ADJ = ytCell(i).connect_edge_(ytCell(i).connect_edge_ ~= -1);
        theircolor = cell(size(ADJ, 1), 1);

        for j = 1:size(ADJ, 1)
            theircolor{j}= ytCell(ADJ(j)).possible_color_;
        end
        

        less = cell(size(ADJ, 1), 1);
        replacible = zeros(size(ADJ, 1), 1);
        for j = 1:size(ADJ, 1)
            less{j} = setdiff(ytCell(ADJ(j)).possible_color_, color);
            replacible(j) = isempty(less{j});
        end
           
        ok_ADJ = ADJ(replacible == 1);
        if isempty(ok_ADJ)
            % we have no choice but directly remove all IKs
            for j = 1:size(ytCell(i).ver_, 1)
                our_ver(ytCell(i).ver_(j)).IK_ = [];
                our_ver(ytCell(i).ver_(j)).color_ = [];
            end
            repour = true;
            continue;
        end
        
        
        more = cell(size(ok_ADJ, 1), 1);
        for j = 1:size(ok_ADJ, 1)
            more{j} = setdiff(color, ytCell(ok_ADJ(j)).possible_color_);
        end
        
        % We only consider changing the cost to which changes the least
        minchange = 10000;
        for j = 1:size(ok_ADJ, 1)
            if minchange > size(more{j}, 2)
                minchange = size(more{j}, 2);
            end
        end
        
        for j = size(ok_ADJ, 1):-1:1
            if size(more{j}, 2) > minchange
                ok_ADJ(j) = [];
                more(j, :) = [];
            end
        end
        
        % we should find an adjacent cell to merge
        num = tabulate(ok_ADJ);
        [~, loc] = max(num(:, 2));
        
        final_adj = loc(1);
        final_color = ytCell(final_adj).possible_color_;
        % change the color of all vertices
        for j = 1:size(ytCell(i).ver_, 1)
            for k = size(our_ver(ytCell(i).ver_(j)).color_, 2):-1:1
                if ~any(final_color == our_ver(ytCell(i).ver_(j)).color_(k))
                    our_ver(ytCell(i).ver_(j)).IK_(k, :) = [];
                    our_ver(ytCell(i).ver_(j)).color_(k) = [];
                end
            end
        end
        repour = true;
        fprintf('YT: Some cells are deleted.\n');
        continue;
        end

    end
end

if repour == true
    for i = 1:size(our_ver, 1)
        our_ver(i).cell_ = [];
    end
    ytCell = createGraph(our_ver);
    for i = 1:size(ytCell, 1)
        ytCell(i).updateAdj(our_ver);
    end
    topo_edgelist = labelEdge(ytCell);
    
    % go for another cycle of slightly changing, until the algorithm
    % returns
    [topo_edgelist, ytCell, our_ver] = slightlyChangeBoundary(ytCell, our_ver);
end



end