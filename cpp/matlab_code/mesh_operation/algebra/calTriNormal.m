function nor = calTriNormal()
% calculate the outer normal vector of the triangle
global global_ori_tri;
global global_ori_ver;
nor = zeros(size(global_ori_tri, 1), 3);

for i = 1:size(global_ori_tri, 1)
    ver1 = global_ori_ver(global_ori_tri(i, 1), :);
    ver2 = global_ori_ver(global_ori_tri(i, 2), :);
    ver3 = global_ori_ver(global_ori_tri(i, 3), :);
    
    length = 0;
    
    temp1(1) = ver1(1) - ver2(1);
    temp1(2) = ver1(2) - ver2(2);
    temp1(3) = ver1(3) - ver2(3);
    
    temp2(1) = ver2(1) - ver3(1);
    temp2(2) = ver2(2) - ver3(2);
    temp2(3) = ver2(3) - ver3(3);

    
    normal(1) = temp1(2) * temp2(3) - temp1(3) * temp2(2) ;
    normal(2) = -( temp1(1) * temp2(3) - temp1(3) * temp2(1) ) ;
    normal(3) = temp1(1) * temp2(2) - temp1(2) * temp2(1) ;
    
    
    
    normal = normal / norm(normal);%sqrt(normal[0] * normal[0] + normal[1]* normal[1]+ normal[2] * normal[2]);
    nor(i, :) = normal;
end
end