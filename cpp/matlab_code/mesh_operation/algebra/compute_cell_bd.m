function bd = compute_cell_bd(vertexlist)
% bd = compute_cell_bd(vertexlist)
% vertexlist is an 2*1 cell whose element is an n*1 array
% Notice: This function cannot deal with the cell that only have two edges,
% because we cannot use the virtual vertex to clearify these two edges
v1 = vertexlist{1};
v2 = vertexlist{2};
if size(v1, 1) <= 2 || size(v2, 1) <= 2
    warning('YT: The compute_cell_bd function cannot deal with two-edge cell\n');
end

m = max(max(v1), max(v2));

%% Register the two boundaries in the adjacent matrix
amd = zeros(m, m);
for i = 1:size(v1, 1)-1
    amd(v1(i), v1(i+1)) = 1;
end
amd(v1(end), v1(1)) = 1;

for i = 1:size(v2, 1) - 1
    if amd(v2(i+1), v2(i)) == 1
        amd(v2(i+1), v2(i)) = 0;
    else
        amd(v2(i), v2(i+1)) = 2;
    end
end
if amd(v2(1), v2(end)) == 1
    amd(v2(1), v2(end)) = 0;
else
    amd(v2(end), v2(1)) = 2;
end

result = cell(0);


index = -1;
while any(any(amd))
    %find the first vertex in the boundary
    if index == -1
%         [B, ~] = find(any(amd ~= 0));
        [B, ~] = find(amd ~= 0);
        if isempty(B)
            warning('YT: cannot find start edge\n');
        else
            index = B(1);
            edgelist = [index];
        end 
    end
    
    B = find(amd(index, :) ~= 0);
    if isempty(B)
        warning('YT: error, the boundary is not closed\n');
    else
        if B(1) == edgelist(1)
            amd(index, B(1)) = 0;
            n = size(result, 1);
            result{n+1, 1} = edgelist;
            edgelist = [];
            index = -1;
        else
            edgelist = [edgelist; B(1)];
            amd(index, B(1)) = 0;
            index = B(1);
        end
    end
end

bd = result;
