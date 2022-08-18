function findAdj(obj)
% %the boundary must be closed
% %use two adjacent boundary cell to judge
% bd = [obj.boundary_(end); obj.boundary_; obj.boundary_(1)];
% all_adj_edge = [];
% for i = 2:size(bd, 1)-1
%     v = our_ver(bd(i));
%     back = bd(i-1);
%     front = bd(i+1);
%     %% for isolated vertex
%     if back == front
%         fprintf('YT: we have not finish isolated vertex\n');
%         continue;
%     end
%     
%     %% for isolated cell
%     b1 = find(v.adj_ver_ == back);
%     b2 = find(v.adj_ver_ == front);
%     if b1 < b2
%         for j = b1:b2
%             all_adj_edge = [all_adj_edge; [bd(i), v.adj_ver_(j)]];
%         end
%     elseif b1 > b2
%         for j = b1:size(v.adj_ver_, 1)
%             all_adj_edge = [all_adj_edge; [bd(i), v.adj_ver_(j)]];
%         end
%         for j = 1:b2
%             all_adj_edge = [all_adj_edge; [bd(i), v.adj_ver_(j)]];
%         end
%     else
%         fprintf('YT: error, we cannot find correct adj_ver\n');
%     end
% end
% 
% %% temporarily show the all_adj_edge
% for i = 1:size(all_adj_edge, 1)
%     v1 = our_ver(all_adj_edge(i, 1));
%     v2 = our_ver(all_adj_edge(i, 2));
%     
%     X = [v1.position_(1), v2.position_(1)];
%     Y = [v1.position_(2), v2.position_(2)];
%     Z = [v1.position_(3), v2.position_(3)];
%     hold on
%     plot3(X, Y, Z, 'red');
% end
% obj.connect_edge_ = all_adj_edge;
