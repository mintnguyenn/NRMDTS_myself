function j = theOther(obj, i)
% given an edge and one of its adjacent cell, return the other one
if i == obj.c1_
    j = obj.c2_;
elseif i == obj.c2_
    j = obj.c1_;
else
    fprintf('YT: cannot find the other cell in this edge\n');
end
    
    