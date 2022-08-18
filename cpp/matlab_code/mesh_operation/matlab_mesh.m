function [ytCell, our_ver, topo_edgelist, topo_amd] = matlab_mesh(reduce_cspace)
%[ytCell, our_ver, topo_edgelist, topo_amd] = matlab_mesh(reduce_cspace)
% The global_ori_tri and the global_ori_ver should be given
% reduce_cspace:
%    = true: we automatically delete some unnecessary IK solutions
%    = false: do nothing before creating topological graph

global global_ori_tri;
global global_ori_ver;
global global_tri_normal;
global global_ver_normal;

%% Mesh Operation 

%% Calculate the normal vector of all vertices on the mesh
global_tri_normal = calTriNormal();
global_ver_normal = calVerNormal();

%The normal vector of each vertex is pointing "outside" the surface, we
%should change its sign when using it. 

%% using the barocenter and the midpoint of edges, split original triangles
global global_generalized_tri;
global global_generalized_ver;

[am, amd] = compute_adjacency_matrix(global_ori_tri);

% Store the boundary of the initial mesh, for visualization
whole_mesh_bd = compute_bd(global_ori_tri, []);


n = sum(sum(am~= 0))/2;
global_generalized_ver = zeros(size(global_ori_ver, 1)+n , 3);
edgeverindex = am;
global_generalized_ver(1:size(global_ori_ver, 1), 1:3) = global_ori_ver;
n = size(global_ori_ver, 1);

for p = 1:size(global_ori_tri, 1)
    i = global_ori_tri(p, 1);
    j = global_ori_tri(p, 2);
    if edgeverindex(i, j) < 3
        x = (global_ori_ver(i, 1) + global_ori_ver(j, 1))/2;
        y = (global_ori_ver(i, 2) + global_ori_ver(j, 2))/2;
        z = (global_ori_ver(i, 3) + global_ori_ver(j, 3))/2;
        global_generalized_ver(n+1, :) = [x, y, z];
        edgeverindex(i, j) = n+1;
        edgeverindex(j, i) = n+1;
        n = n+1;
    end
    i = global_ori_tri(p, 2);
    j = global_ori_tri(p, 3);
    if edgeverindex(i, j) < 3
        x = (global_ori_ver(i, 1) + global_ori_ver(j, 1))/2;
        y = (global_ori_ver(i, 2) + global_ori_ver(j, 2))/2;
        z = (global_ori_ver(i, 3) + global_ori_ver(j, 3))/2;
        global_generalized_ver(n+1, :) = [x, y, z];
        edgeverindex(i, j) = n+1;
        edgeverindex(j, i) = n+1;
        n = n+1;
    end
    i = global_ori_tri(p, 3);
    j = global_ori_tri(p, 1);
    if edgeverindex(i, j) < 3
        x = (global_ori_ver(i, 1) + global_ori_ver(j, 1))/2;
        y = (global_ori_ver(i, 2) + global_ori_ver(j, 2))/2;
        z = (global_ori_ver(i, 3) + global_ori_ver(j, 3))/2;
        global_generalized_ver(n+1, :) = [x, y, z];
        edgeverindex(i, j) = n+1;
        edgeverindex(j, i) = n+1;
        n = n+1;
    end
end



%% Create the refined triangular mesh (for divisions)
global_generalized_tri = zeros(size(global_ori_tri, 1)*6, 3);
for i = 1:size(global_ori_tri, 1)
    v1 = global_ori_tri(i, 1);
    v2 = global_ori_tri(i, 2);
    v3 = global_ori_tri(i, 3);
    m1 = edgeverindex(v1, v2);
    m2 = edgeverindex(v2, v3);
    m3 = edgeverindex(v3, v1);
    b1 = (global_ori_ver(v1, :) + global_ori_ver(v2, :) + global_ori_ver(v3, :))/3;
    n = size(global_generalized_ver, 1);
    global_generalized_ver(n+1, :) = b1;
    b1 = n+1;

    global_generalized_tri((i-1)*6+1, :) = [v1, m1, b1];
    global_generalized_tri((i-1)*6+2, :) = [v2, b1, m1];
    global_generalized_tri((i-1)*6+3, :) = [v2, m2, b1];
    global_generalized_tri((i-1)*6+4, :) = [v3, b1, m2];
    global_generalized_tri((i-1)*6+5, :) = [v3, m3, b1];
    global_generalized_tri((i-1)*6+6, :) = [v1, b1, m3];
end

%% Visualization
% plot_mesh(global_ori_tri,global_ori_ver);

% %% visualize the normal vector
% hold on
% quiver3(global_ori_ver(:, 1), global_ori_ver(:, 2), global_ori_ver(:, 3), ...
%     global_ver_normal(:, 1), global_ver_normal(:, 2), global_ver_normal(:, 3));

%% Start our creation of cells
our_ver = [];
for i = 1:size(global_ori_ver, 1)
    our_ver = [our_ver; Vertex(global_ori_ver(i, :), i)];
end

%% For each inverse kinematic solutions, specify a kind of color
createColor(our_ver);
if reduce_cspace
    fprintf('YT: Although in our paper, the algorithm can gives all possible solutions. ');
    fprintf('However, for only a figure, we just delete the colors that are not necessary for just one optimal solution.\n');
    reduceCSpace(our_ver);
end

%% For each point, specify the polishing type of the point
ytCell = createGraph(our_ver);

[topo_edgelist, ytCell, our_ver] = slightlyChangeBoundary(ytCell, our_ver);

%% create topological vertex
[topo_amd, topo_edgelist] = topoVer(ytCell, our_ver, edgeverindex, topo_edgelist);

%% adjust order in topo_edgelist
for i = 1:size(topo_edgelist, 1)
    if topo_edgelist(i, 1) > topo_edgelist(i, 2)
        topo_edgelist(i, :) = topo_edgelist(i, end:-1:1);
    end
end

%% Visualization
% X = zeros(size(whole_mesh_bd, 1)+1, 1);
% Y = zeros(size(whole_mesh_bd, 1)+1, 1);
% Z = zeros(size(whole_mesh_bd, 1)+1, 1);
% for i = 1:size(whole_mesh_bd, 1)
    X = global_ori_ver(whole_mesh_bd, 1);
    Y = global_ori_ver(whole_mesh_bd, 2);
    Z = global_ori_ver(whole_mesh_bd, 3);
    X = [X; X(1)];
    Y = [Y; Y(1)];
    Z = [Z; Z(1)];
    hold on
    patch(X, Y, Z, 'white');
% end
for i = 1:size(ytCell, 1)
    ytCell(i).showCell();
end
