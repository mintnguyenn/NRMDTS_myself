function [ordered_edges, ordered_vertex] = rotateArray(edges, common, vertex)
% result_a = rotateArray(a, b)
% a and b are n*1 arrays and assume that b appears in a continously. Rotate
% a so that b appears at the beginning of a. 
% a should be longer than b, so at least a has two elements.

if size(common, 1) == 1
    loc = find(edges == common);
    if loc == 1
        ordered_edges = edges;
        ordered_vertex = vertex;
        return ;
    end
    ordered_edges = [edges(loc:end); edges(1:loc-1)];
    ordered_vertex = [vertex(loc:end); vertex(1:loc-1)];
    return ;
end

in = zeros(size(edges, 1), 1);
for i = 1:size(edges, 1)
    in(i) = any(common == edges(i));
end

if in(1)
    % cut the tail and insert at the beginning
    for i = size(edges, 1):-1:1
        if ~in(i)
            break;
        end
    end
    ordered_edges = [edges(i+1:end); edges(1:i)];
    ordered_vertex = [vertex(i+1:end); vertex(1:i)];
else
    % cut the head and insert at the end
    for i = 1:size(edges, 1)
        if in(i)
            break;
        end
    end
    ordered_edges = [edges(i:end); edges(1:i-1)];
    ordered_vertex = [vertex(i:end); vertex(1:i-1)];
end

end