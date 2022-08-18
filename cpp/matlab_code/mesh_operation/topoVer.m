function [topo_amd, topo_edgelist] = topoVer(ytCell, our_ver, edgeverindex, topo_edgelist)
% [topo_amd, topo_edgelist] = topoVer(ytCell, our_ver, edgeverindex, topo_edgelist)
% If the three vertices of a triangle belong to three different cell, it is
% a topological vertex (that connect different topological edges)
% There are two kinds of situations, cell-cell-cell or empty-cell-cell

global global_generalized_ver;
global global_ori_tri;
%% Find all triangles whose three vertices belong to different cells
B = [];
for i = 1:size(global_ori_tri, 1)
    v1 = global_ori_tri(i, 1);
    v2 = global_ori_tri(i, 2);
    v3 = global_ori_tri(i, 3);
    if isempty(our_ver(v1).cell_) || isempty(our_ver(v2).cell_) || isempty(our_ver(v3).cell_)
        continue;
    end
    if our_ver(v1).cell_ ~= our_ver(v2).cell_ && ...
            our_ver(v1).cell_ ~= our_ver(v3).cell_ && ...
            our_ver(v2).cell_ ~= our_ver(v3).cell_
        B = [B; i];
    end
end

%% These are all virtual vertices, label them and register in each cell
for i = 1:size(B, 1)
    v1 = global_ori_tri(B(i), 1);
    v2 = global_ori_tri(B(i), 2);
    v3 = global_ori_tri(B(i), 3);
    m1 = edgeverindex(v1, v2);
    m2 = edgeverindex(v2, v3);
    m3 = edgeverindex(v3, v1);
    b1 = size(global_generalized_ver, 1) - size(global_ori_tri, 1) + B(i);
    
    c1 = our_ver(v1).cell_;
    c2 = our_ver(v2).cell_;
    c3 = our_ver(v3).cell_;
    
    %% Deal with c1
    index = -1;
    for j = 1:size(ytCell(c1).boundary_, 1)
        if j ~= size(ytCell(c1).boundary_, 1)
            if ytCell(c1).boundary_(j) == m1 && ytCell(c1).boundary_(j+1) == b1
                index = j;
                break;
            end
        else 
            if ytCell(c1).boundary_(end) == m1 && ytCell(c1).boundary_(1) == b1
                index = j;
                break;
            end
        end
    end
    if index == -1
        warning('YT: error, we cannot locate the virtual vertex\n');
    end
    
    %an endpoint of an edge is this boundary, find it
    for k = 1:size(ytCell(c1).topo_edge_, 1)
        if ytCell(c1).topo_edge_{k}(end) == index
            ytCell(c1).topo_ver_(k, 2) = i;
            break;
        end
    end
    
    index = -1;
    for j = 1:size(ytCell(c1).boundary_, 1)
        if j ~= size(ytCell(c1).boundary_, 1)
            if ytCell(c1).boundary_(j) == b1 && ytCell(c1).boundary_(j+1) == m3
                index = j;
                break;
            end
        else 
            if ytCell(c1).boundary_(end) == b1 && ytCell(c1).boundary_(1) == m3
                index = j;
                break;
            end
        end
    end
    if index == -1
        warning('YT: error, we cannot locate the virtual vertex\n');
    end
    
    %an endpoint of an edge is this boundary, find it
    for k = 1:size(ytCell(c1).topo_edge_, 1)
        if ytCell(c1).topo_edge_{k}(1) == index
            ytCell(c1).topo_ver_(k, 1) = i;
        end
    end
   
    %% Deal with c2
    index = -1;
    for j = 1:size(ytCell(c2).boundary_, 1)
        if j ~= size(ytCell(c2).boundary_, 1)
            if ytCell(c2).boundary_(j) == m2 && ytCell(c2).boundary_(j+1) == b1
                index = j;
                break;
            end
        else 
            if ytCell(c2).boundary_(end) == m2 && ytCell(c2).boundary_(1) == b1
                index = j;
                break;
            end
        end
    end
    if index == -1
        warning('YT: error, we cannot locate the virtual vertex\n');
    end
    
    %an endpoint of an edge is this boundary, find it
    for k = 1:size(ytCell(c2).topo_edge_, 1)
        if ytCell(c2).topo_edge_{k}(end) == index
            ytCell(c2).topo_ver_(k, 2) = i;
            break;
        end
    end
    
    index = -1;
    for j = 1:size(ytCell(c2).boundary_, 1)
        if j ~= size(ytCell(c2).boundary_, 1)
            if ytCell(c2).boundary_(j) == b1 && ytCell(c2).boundary_(j+1) == m1
                index = j;
                break;
            end
        else 
            if ytCell(c2).boundary_(end) == b1 && ytCell(c2).boundary_(1) == m1
                index = j;
                break;
            end
        end
    end
    if index == -1
        warning('YT: error, we cannot locate the virtual vertex\n');
    end
    
    %an endpoint of an edge is this boundary, find it
    for k = 1:size(ytCell(c2).topo_edge_, 1)
        if ytCell(c2).topo_edge_{k}(1) == index
            ytCell(c2).topo_ver_(k, 1) = i;
        end
    end
    
    %% Deal with c3
    index = -1;
    for j = 1:size(ytCell(c3).boundary_, 1)
        if j ~= size(ytCell(c3).boundary_, 1)
            if ytCell(c3).boundary_(j) == m3 && ytCell(c3).boundary_(j+1) == b1
                index = j;
                break;
            end
        else 
            if ytCell(c3).boundary_(end) == m3 && ytCell(c3).boundary_(1) == b1
                index = j;
                break;
            end
        end
    end
    if index == -1
        warning('YT: error, we cannot locate the virtual vertex\n');
    end
    
    %an endpoint of an edge is this boundary, find it
    for k = 1:size(ytCell(c3).topo_edge_, 1)
        if ytCell(c3).topo_edge_{k}(end) == index
            ytCell(c3).topo_ver_(k, 2) = i;
            break;
        end
    end
    
    index = -1;
    for j = 1:size(ytCell(c3).boundary_, 1)
        if j ~= size(ytCell(c3).boundary_, 1)
            if ytCell(c3).boundary_(j) == b1 && ytCell(c3).boundary_(j+1) == m2
                index = j;
                break;
            end
        else 
            if ytCell(c3).boundary_(end) == b1 && ytCell(c3).boundary_(1) == m2
                index = j;
                break;
            end
        end
    end
    if index == -1
        warning('YT: error, we cannot locate the virtual vertex\n');
    end
    
    %an endpoint of an edge is this boundary, find it
    for k = 1:size(ytCell(c3).topo_edge_, 1)
        if ytCell(c3).topo_edge_{k}(1) == index
            ytCell(c3).topo_ver_(k, 1) = i;
        end
    end
end

%% Deal with two edge and boundary 
C = [];
for i = 1:size(global_ori_tri, 1)
    v1 = global_ori_tri(i, 1);
    v2 = global_ori_tri(i, 2);
    v3 = global_ori_tri(i, 3);
    if isempty(our_ver(v1).cell_) && ~isempty(our_ver(v2).cell_) && ~isempty(our_ver(v3).cell_)
        if our_ver(v2).cell_ ~= our_ver(v3).cell_
            C = [C; i];
        end
    elseif ~isempty(our_ver(v1).cell_) && isempty(our_ver(v2).cell_) && ~isempty(our_ver(v3).cell_)
        if our_ver(v1).cell_ ~= our_ver(v3).cell_
            C = [C; i];
        end
    elseif ~isempty(our_ver(v1).cell_) && ~isempty(our_ver(v2).cell_) && isempty(our_ver(v3).cell_)
        if our_ver(v1).cell_ ~= our_ver(v2).cell_
            C = [C; i];
        end       
    end
end

count = size(B, 1);
for i = 1:size(C, 1)
    %rotate the triangle so that nocell vertex is the third one
    v1 = global_ori_tri(C(i), 1);
    v2 = global_ori_tri(C(i), 2);
    v3 = global_ori_tri(C(i), 3);
    if isempty(our_ver(v1).cell_)
        tri = [v2, v3, v1];
    elseif isempty(our_ver(v2).cell_)
        tri = [v3, v1, v2];
    elseif isempty(our_ver(v3).cell_)
        tri = [v1, v2, v3];
    else
        fprintf('YT: error, no nocell vertex\n');
    end
    
    v1 = tri(1);
    v2 = tri(2);
    v3 = tri(3);
    m1 = edgeverindex(v1, v2);
    m2 = edgeverindex(v2, v3);
    m3 = edgeverindex(v3, v1);
    b1 = size(global_generalized_ver, 1) - size(global_ori_tri, 1) + C(i);
    c1 = our_ver(v1).cell_;
    c2 = our_ver(v2).cell_;
    

    %% Deal with c1
    index = -1;
    for j = 1:size(ytCell(c1).boundary_, 1)
        if j ~= size(ytCell(c1).boundary_, 1)
            if ytCell(c1).boundary_(j) == m1 && ytCell(c1).boundary_(j+1) == b1
                index = j;
                break;
            end
        else 
            if ytCell(c1).boundary_(end) == m1 && ytCell(c1).boundary_(1) == b1
                index = j;
                break;
            end
        end
    end
    if index == -1
        fprintf('YT: error, we cannot locate the virtual vertex\n');
    end
    
    %an endpoint of an edge is this boundary, find it
    for k = 1:size(ytCell(c1).topo_edge_, 1)
        if ytCell(c1).topo_edge_{k}(end) == index
                ytCell(c1).topo_ver_(k, 2) = count + 1;
            break;
        end
    end
    
    index = -1;
    for j = 1:size(ytCell(c1).boundary_, 1)
        if j ~= size(ytCell(c1).boundary_, 1)
            if ytCell(c1).boundary_(j) == b1 && ytCell(c1).boundary_(j+1) == m3
                index = j;
                break;
            end
        else 
            if ytCell(c1).boundary_(end) == b1 && ytCell(c1).boundary_(1) == m3
                index = j;
                break;
            end
        end
    end
    if index == -1
        fprintf('YT: error, we cannot locate the virtual vertex\n');
    end
    
    %an endpoint of an edge is this boundary, find it
    for k = 1:size(ytCell(c1).topo_edge_, 1)
        if ytCell(c1).topo_edge_{k}(1) == index
                ytCell(c1).topo_ver_(k, 1) = count + 1;
            break;
        end
    end
    
    %% Deal with c2
    index = -1;
    for j = 1:size(ytCell(c2).boundary_, 1)
        if j ~= size(ytCell(c2).boundary_, 1)
            if ytCell(c2).boundary_(j) == b1 && ytCell(c2).boundary_(j+1) == m1
                index = j;
                break;
            end
        else 
            if ytCell(c2).boundary_(end) == b1 && ytCell(c2).boundary_(1) == m1
                index = j;
                break;
            end
        end
    end
    if index == -1
        fprintf('YT: error, we cannot locate the virtual vertex\n');
    end
    
    %an endpoint of an edge is this boundary, find it
    for k = 1:size(ytCell(c2).topo_edge_, 1)
        if ytCell(c2).topo_edge_{k}(1) == index
            ytCell(c2).topo_ver_(k, 1) = count + 1;
            break;
        end
    end
    
    index = -1;
    for j = 1:size(ytCell(c2).boundary_, 1)
        if j ~= size(ytCell(c2).boundary_, 1)
            if ytCell(c2).boundary_(j) == m2 && ytCell(c2).boundary_(j+1) == b1
                index = j;
                break;
            end
        else 
            if ytCell(c2).boundary_(end) == m2 && ytCell(c2).boundary_(1) == b1
                index = j;
                break;
            end
        end
    end
    if index == -1
        fprintf('YT: error, we cannot locate the virtual vertex\n');
    end
    
    %an endpoint of an edge is this boundary, find it
    for k = 1:size(ytCell(c2).topo_edge_, 1)
        if ytCell(c2).topo_edge_{k}(end) == index
            ytCell(c2).topo_ver_(k, 2) = count + 1;
            break;
        end
    end
    
    
    count = count + 1;
end

%% create the adjacent matrix, and enlarge the topo_edgelist
count = size(topo_edgelist, 1);
topo_amd = [];
for i = 1:size(ytCell, 1)
    n = size(ytCell(i).topo_edge_index_, 1);
    for j = 1:size(ytCell(i).topo_ver_, 1)
%         if j <= n
            topo_amd(ytCell(i).topo_ver_(j, 1), ytCell(i).topo_ver_(j, 2)) = ytCell(i).topo_edge_index_(j);
%         else
%             topo_edgelist(count+1, :) = [i, -1];
%             topo_amd(ytCell(i).topo_ver_(j, 1), ytCell(i).topo_ver_(j, 2)) = count + 1;
%             count = count + 1;
%         end
    end
end

end

