function index = findTri(face, c1, c2)
%given first c1 then c2, return the index of the triangle which contains
%c1 and c2 in the correct order

%if there is no vertex, return -1
index = -1;
b = find(face(:, 1) == c1);
if any(b)
    for i = 1:size(b, 1)
        if face(b(i), 2) == c2
            index = b(i);
            return ;
        end
    end
end
b = find(face(:, 2) == c1);
if any(b)
    for i = 1:size(b, 1)
        if face(b(i), 3) == c2
            index = b(i);
            return ;
        end
    end
end
b = find(face(:, 3) == c1);
if any(b)
    for i = 1:size(b, 1)
        if face(b(i), 1) == c2
            index = b(i);
            return ;
        end
    end
end
end
