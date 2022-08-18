function partitions = goThrough(alldivisions)
% partitions is a cell of matrices. Each matrice extract one line for each
% cell

if size(alldivisions, 1) == 1
    partitions = alldivisions{1};
    return ;
end

partitions = cell(0);
for i = 1:size(alldivisions{1, 1}, 1)
    front = alldivisions{1}{i};
    back = goThrough(alldivisions(2:end));
    for j = 1:size(back, 1)
        n1 = size(front, 1);
        m1 = size(front, 2);
        m2 = size(back{j}, 2);
        t = max(m1, m2);

        n = size(partitions, 1);
        partitions{n+1, 1} = front;
        partitions{n+1, 1}(size(front, 1)+1:size(back{j}, 1)+size(front, 1), 1:size(back{j}, 2)) = back{j};
    end
end

end