function createColor(our_ver)
% createColor(our_ver)
% Based on the inverse kinematic functions, we divide all IKs into
% different colors


color = 0;
while(1)
    %% Choose the first joint-angle
    ver_index = -1;
    ik_index = -1;
    for i = 1:size(our_ver, 1)        
        if our_ver(i).no_use_ == 1
            continue;
        end
        if isempty(our_ver(i).color_)
            continue;
        end
        for j = 1:size(our_ver(i).color_, 2)
            if our_ver(i).color_(j) == 0
                ver_index = i;
                ik_index = j;
                break;
            end
        end
        if ver_index ~= -1 && ik_index ~= -1
            break;
        end
    end
    
    if ver_index == -1 && ik_index == -1
        fprintf('YT: C Space has been fully colored\n');
        return ;
    end

    %% Exploring all polishable vertices
    color = color + 1;
    our_ver(ver_index).color_(ik_index) = color;
    openlist = [ver_index, ik_index];
    while ~isempty(openlist)
        temp_ver_index = openlist(1, 1);
        temp_ik_index = openlist(1, 2);
        ref_joint_angle = our_ver(temp_ver_index).IK_(temp_ik_index, :);
        openlist(1, :) = [];
        
        ADJ = our_ver(temp_ver_index).adj_ver_;
        for i = 1:size(ADJ, 1)
            adj = ADJ(i);
            if isempty(our_ver(adj).IK_)
                continue;
            end
            if any(our_ver(adj).color_ == color)
                continue;
            end
            
            dis = zeros(1, 1);
            %calculate the distance between all joint-angles and the ref
            for j = 1:size(our_ver(adj).IK_, 1)
                if our_ver(adj).color_(j) ~= 0
                    dis(j, 1) = inf;
                    continue;
                end
                dis(j, 1) = norm(wrapToPi(our_ver(adj).IK_(j, :) - ref_joint_angle));
            end
            B = find(dis < pi/8);
            
            %% Improvement: If there are many similar inverse solutions, we only choose the nearest one
            % TODO: This should not happen when we use the dynamic
            % constraints
            if ~isempty(B)
                if size(B, 1) == 1
                    our_ver(adj).color_(B) = color;
                    openlist = [openlist; adj, B];
                else
                    % we chooose the nearest one
                    minindexandvalue = [1, norm(our_ver(adj).IK_(B(1), :) - ref_joint_angle)];
                    for j = 2:size(B, 1)
                        newdis = norm(our_ver(adj).IK_(B(j), :) - ref_joint_angle);
                        if newdis < minindexandvalue(2)
                            minindexandvalue(1) = j;
                            minindexandvalue(2) = newdis;
                        end
                    end
                    our_ver(adj).color_(B(j)) = color;
                    openlist = [openlist; adj, B(j)];
                    
                end
            end
            
        end
    end
end

end


