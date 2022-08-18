function reducedPartition = reduceNumber(fullPartition, deleted_number)
% fullPartition: n*m array
% deleted_number: 1*n array
A = sort(deleted_number);% The biggest element is at the end
reducedPartition = fullPartition;

for i = size(A, 2):-1:1
    n = A(i);
    for j = 1:size(reducedPartition, 1)
        for k = 1:size(reducedPartition, 2)
            if reducedPartition(j, k) > n
                reducedPartition(j, k) = reducedPartition(j, k) - 1;
            end
        end
    end
end

end