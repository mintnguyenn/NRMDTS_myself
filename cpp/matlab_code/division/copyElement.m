function [ n_ele ] = copyElement( o_ele )

n_ele =[];
for i = 1:size(o_ele, 1)
    n_ele = [n_ele; o_ele(i).copy()];
end

end

