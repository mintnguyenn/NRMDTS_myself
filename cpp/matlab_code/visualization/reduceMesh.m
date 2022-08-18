function [reduced_trilist, reduced_vertex] = reduceMesh(trilist, vertex)
%remove unused vertex, and change the index in the trilist at the same time

reduced_trilist = trilist;
reduced_vertex = vertex;
for i = size(reduced_vertex, 1):-1:1
    if ~any(any(reduced_trilist == i))
        reduced_vertex(i, :) = [];
        reduced_trilist(reduced_trilist> i) = reduced_trilist(reduced_trilist > i) - 1;
    end
end


end

