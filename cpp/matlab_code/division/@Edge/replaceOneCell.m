function replaceOneCell(obj, oldindex, newindex)
if obj.c1_ == oldindex
    obj.c1_ = newindex;
    return ;
elseif obj.c2_ == oldindex
    obj.c2_ = newindex;
    return ;
else
    fprintf('YT: Cannot change the adjacent cell for the edge\n');
end

end