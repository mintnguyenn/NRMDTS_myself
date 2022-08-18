% This function greedily generate a spiral path for the semi-ellipsoid
% We assume that all points can be polished, so that we only need to choose
% the 

result = zeros(2401, 1);
result(101) = our_ver(101).color_(1);
for i = 101:2401
    if any(our_ver(i).color_ == result(i-1))
        result(i) = result(i-1);
    else
        result(i) = our_ver(i).color_(1);
    end
    
end
result
for i = 1:2401
    if result(i) == 0
        continue;
    elseif result(i) == 1
        colorVertex(our_ver, i, [90, 90, 165]);
    elseif result(i) == 2
        colorVertex(our_ver, i, [90, 165, 90]);
    elseif result(i) == 3
        colorVertex(our_ver, i, [165, 90, 90]);
    elseif result(i) == 4
        colorVertex(our_ver, i, [120, 199, 199]);
    else
        colorVertex(our_ver, i, [0, 0, 0]);
    end
end