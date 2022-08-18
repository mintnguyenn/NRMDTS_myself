function b = isNoUse(obj)
global global_ori_tri;
b = false;%not a boundary point
B = find(global_ori_tri == obj.index_);

CCW = [];
CW = [];
for i = 1:size(B, 1)
    x = rem(B(i)-1, size(global_ori_tri, 1))+1;
    y = (B(i) - x)/size(global_ori_tri, 1) + 1;
    CCW = [CCW; global_ori_tri(x, mod(y-2, 3)+1)];
    CW = [CW; global_ori_tri(x, mod(y, 3)+1)];
    
end
for i = size(CCW, 1):-1:1
    if ~any(CW == CCW(i))
        b = true;
        return ;
    end
end

end