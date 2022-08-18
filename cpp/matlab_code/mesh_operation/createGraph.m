function cell_list = createGraph(our_ver)

cell_list = [];
while(1)
    index = -1;
    for i = 1:size(our_ver, 1)
        if ~our_ver(i).no_use_ && ~isempty(our_ver(i).color_) && isempty(our_ver(i).cell_)
            index = i;
            break;
        end
    end

    if index == -1
        return ;
    end
    
    cell_list = [cell_list; Cell(size(cell_list, 1)+1, index, our_ver)];
end