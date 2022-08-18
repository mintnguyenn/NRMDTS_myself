function colorVertex(our_ver, index, color)
global global_generalized_tri;
global global_generalized_ver;
if our_ver(index).no_use_ == true
    return ;
end

hold on
[X, ~] = find(global_generalized_tri == index);
face = global_generalized_tri(X, :);

patch('Faces', face, 'Vertices', global_generalized_ver, 'EdgeColor', 'none', 'FaceColor', color/255);
    

% 
% for i = 1:size(our_ver(index).adj_ver_, 1)
%         p1 = global_ori_ver(index, 1:3);
%     if i == size(our_ver(index).adj_ver_, 1)
%         p2index = our_ver(index).adj_ver_(i);
%         p3index = our_ver(index).adj_ver_(1);
%     else
%         p2index = our_ver(index).adj_ver_(i);
%         p3index = our_ver(index).adj_ver_(i+1);
%     end
%     p2 = global_ori_ver(p2index, 1:3);
%     p3 = global_ori_ver(p3index, 1:3);
%     p4 = (p1+p2+p3)/3;
%     X = [p1(1); (p1(1)+p2(1))/2; (p1(1)+p3(1))/2];
%     Y = [p1(2); (p1(2)+p2(2))/2; (p1(2)+p3(2))/2];
%     Z = [p1(3); (p1(3)+p2(3))/2; (p1(3)+p3(3))/2];
%     hold on
%     patch(X, Y, Z, 'EdgeColor', 'none', 'FaceColor', color/255);
% end
