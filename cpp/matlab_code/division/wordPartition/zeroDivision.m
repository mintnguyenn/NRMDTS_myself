function list = zeroDivision(zeroindex)
list = cell(0);
if size(zeroindex, 2) == 1
    list{1, 1} = zeroindex(1);
    return ;
end
if size(zeroindex, 2) == 2
    list{1, 1} = [zeroindex(1); zeroindex(2)];
    list{2, 1} = zeroindex(1:2);
    return ;
end
for i = 1:size(zeroindex, 2)-1
    front = zeroindex(1:i);
    back = zeroDivision(zeroindex(i+1:end));
    for j = 1:size(back, 1)
        %combine two parts
        n1 = size(front, 2);
        n2 = size(back{j}, 2);
        t = max(n1, n2);
        result = zeros(size(back{j}, 1)+1, t);
        for l = 1:size(front, 2)
            result(1, l) = front(l);
        end
        
        result(2:1+size(back{j}, 1), 1:size(back{j}, 2)) = back{j};
        
        n = size(list, 1);
        list{n+1, 1} = result;
    end
end

n = size(list, 1);
list{n+1, 1} = zeroindex;
end