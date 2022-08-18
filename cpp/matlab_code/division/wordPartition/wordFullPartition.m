function partitions = wordFullPartition(word)

%% partition is a list of partitions, where 0 is divided into many more divisions
partition = wordPartition(word);

if size(partition, 1) == 0
    warning('YT: It seems no partition\n');
end

alldivisions = cell(size(partition, 1), 1);
for i = 1:size(partition, 1)
    % get the i-th partition
    zeroindex = partition(i, :);
    % remove the 0s at the end of the list
    for j = size(zeroindex, 2):-1:1
        if zeroindex(j) == 0
            zeroindex(j) = [];
        else
            break;
        end
    end
    alldivisions{i} = zeroDivision(zeroindex);
end


% For each cell, we choose one possible divisions, combine them
partitions = goThrough(alldivisions);

end