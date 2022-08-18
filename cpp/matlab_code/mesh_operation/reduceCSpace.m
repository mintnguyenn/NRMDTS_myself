function reduceCSpace(our_ver)
% reduceCSpace(our_ver)
% First collect the indices of the vertices for different color
% Then remove some of the colors if they are unnecessary in finding one
% optimal solution

%% We collect the cells that one type of colors can polish
cell_for_color = cell(0);
for i = 1:size(our_ver, 1)
    if isempty(our_ver(i).color_)
        continue;
    end
    for j = 1:size(our_ver(i).color_, 2)
        if size(cell_for_color, 1) < our_ver(i).color_(j)
            cell_for_color{our_ver(i).color_(j), 1} = i;
        else
            cell_for_color{our_ver(i).color_(j), 1} = [cell_for_color{our_ver(i).color_(j), 1}; i];
        end
    end
end
% for i = 1:size(ytCell, 1)
%     for j = 1:size(ytCell(i).possible_color_, 2)
%         n = size(cell_for_color, 1);
%         if n < ytCell(i).possible_color_(j)
%            cell_for_color{ytCell(i).possible_color_(j), 1} = [i];
%         else
%             cell_for_color{ytCell(i).possible_color_(j), 1} = [cell_for_color{ytCell(i).possible_color_(j), 1}; i];
%         end
%     end
% end

%% If some types are totally replacable, then we remove it
% we can use a stronger strategy to directly remove the 
for i = size(cell_for_color, 1):-1:1
    for j = 1:size(cell_for_color, 1)
        if j == i
            continue;
        end
        if isempty(setdiff(cell_for_color{i}, cell_for_color{j})) %&& ...
%                 ~isempty(setdiff(cell_for_color{j}, cell_for_color{i}))
            % remove all information about the i-th color
            for k = 1:size(cell_for_color{i}, 1)
                B = find(our_ver(cell_for_color{i}(k)).color_ == i);% There should be only one type
                our_ver(cell_for_color{i}(k)).removeIK(B);
%                 our_ver(cell_for_color{i}(k)).IK_(B, :) = [];
%                 our_ver(cell_for_color{i}(k)).color_(B) = [];
            end
            cell_for_color(i, :) = [];
            break;
        end
    end
end


end