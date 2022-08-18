function v3 = theOtherVertex(onetri, v1, v2)

for i = 1:size(onetri, 2)
    if onetri(i) ~= v1 && onetri(i) ~= v2
        v3 = onetri(i);
        return ;
    end
end

fprintf('YT: error, cannot find the third vertex in the triangle\n');
end