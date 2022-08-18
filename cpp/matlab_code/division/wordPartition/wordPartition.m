function partition = wordPartition(word)
partition = zeros(size(word, 1), size(word,1));

% word is an n*1 array
% given a word consist of 0(not specify) and 1(connect)
% with the first letter and the finally letter connected)
% split the word using 1s

n = size(word, 1);

start = -1;
num_of_partition = 0;
for i = 1:n
    if word(i) == 0 && start == -1
        start = i;
    elseif word(i) == 0 && start ~= -1
        continue;
    elseif word(i) ~= 0 && start == -1
        continue;
    elseif word(i) ~= 0 && start ~= -1
        m = i - start;
        partition(num_of_partition+1, 1:m) = start:(i-1);
        num_of_partition = num_of_partition + 1;
        start = -1;
    else
        fprintf('YT: cannot partition word\n');
    end
end

if start ~= -1 
    list = start:size(word, 1);
    partition(num_of_partition+1, 1:size(list, 2)) = list;
    num_of_partition = num_of_partition + 1;
end

if n > 2 && word(1) == 0 && word(end) == 0
    list = [partition(num_of_partition, :), partition(1, :)];
    list(list == 0) = [];
    partition(1, 1:size(list, 2)) = list;
    partition(num_of_partition, :) = [];
end

%% clean the matrix
for i = size(partition, 1):-1:1
    if sum(partition(i, :)) == 0
        partition(i, :) = [];
    end
end
for i = size(partition, 2):-1:1
    if sum(partition(:, i)) == 0
        partition(:, i) = [];
    end
end

end