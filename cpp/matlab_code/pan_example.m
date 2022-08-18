clear
clear global
clc
close all

addpath(genpath(pwd));

% global global_ori_tri;
% global global_ori_ver;
% global global_generalized_tri;
% global global_generalized_ver;
% global global_obstacles;
% global global_use_CC;
% global_use_CC = true;
% global global_robustness;
% global_robustness = 0.1;
% 
% %% We should load different models in different .m files
% TR = stlread('../mesh_examples/3Dmodel_wok.stl');
% global_ori_tri = TR.ConnectivityList;
% global_ori_ver = TR.Points;
% 
% % The mesh surface is so coarse at the pot handle and the bottom of the
% % pan, so we omit them
% 
% global_ori_ver(:, 1:2) = global_ori_ver(:, 1:2)*1 + 0.47;
% global_ori_ver(:, 3) = global_ori_ver(:, 3) + 0.1;
% 
% plot_mesh(global_ori_tri, global_ori_ver);
% axis equal
% 
% % we first calculate the unused vertex
% no_use_vertex = zeros(size(global_ori_ver, 1), 1);
% 
% % Through analysis the mesh, we should omit the inner part of the pan. The
% % indices of the vertices are high, so we delete some vertices and
% % triangles
% no_use_vertex(4900:end, 1) = 1;
% 
% no_use_vertex(global_ori_ver(:, 3)<0.13) = 1;
% no_use_tri = zeros(size(global_ori_tri, 1), 1);
% for i = 1:size(global_ori_tri, 1)
%     if no_use_vertex(global_ori_tri(i, 1)) == 1
%         no_use_tri(i) = 1;
%         continue;
%     end
%     if no_use_vertex(global_ori_tri(i, 2)) == 1
%         no_use_tri(i) = 1;
%         continue;
%     end
%     if no_use_vertex(global_ori_tri(i, 3)) == 1
%         no_use_tri(i) = 1;
%         continue;
%     end
% end
% 
% global_ori_tri(no_use_tri == 1, :) = [];
% B = find(no_use_vertex == 0);
% global_ori_ver(B(end)+1:end, :) = [];
% 
% %% Setup handler of obstacles
% % for the pan, there is only manipulators, the plane and the
% % object
% if global_use_CC
%     % for the simple example, there is only manipulators, the plane and the
%     % object
%     ground = collisionBox(1.0, 1.0, 0.01);
%     T = trvec2tform([0.5, 0.5, -0.02]);
%     ground.Pose = T;
%     global_obstacles{1, 1} = ground;
%     X = [0, 1, 1, 0]; 
%     Y = [0, 0, 1, 1];
%     Z = [0, 0, 0, 0];
%     patch(X, Y, Z, 'white');
%     
%     % insert the object itself for collision-checking
%     object = collisionMesh(global_ori_ver); 
%     T = eye(4);
%     object.Pose = T;
%     global_obstacles{2, 1} = object;
%     % Show obstacles
% 
% %     hold on
% %     for i = 2:size(global_obstacles, 1)
% %         global_obstacles{i}.show();
% %     end
% end
% global global_CChandle;
% global_CChandle = @CC;
% 
% reduce_cspace = true;
% [ytCell, our_ver, topo_edgelist, topo_amd] = matlab_mesh(reduce_cspace);
% % Note that the boundary of the mesh is also considered as edges, which has
% % adjacent cell -1 and the constraint can only be -1(mustn't connect)
% 
% fprintf('Show the possible colors for the initial topological graph:\n');
% for i = 1:size(ytCell, 1)
%     fprintf('Cell %d: ', i);
%     fprintf('%d, ', ytCell(i).possible_color_);
%     fprintf('\n');
% end
% 
% 
% %% we collect color, and connect situation of each cell
% %colors for each cell
% C = cell(size(ytCell, 1), 1);
% for i = 1:size(ytCell, 1)
%     C{i} = ytCell(i).possible_color_;
% end
% 
% % If any edge is the boundary of the topological graph, then the other
% % cell will be marked as -1
% E = topo_edgelist;
% 
% EdgeList = cell(size(ytCell, 1), 1);
% for i = 1:size(ytCell, 1)
%     EdgeList{i} = ytCell(i).topo_edge_index_;
% end
% 
% VertexList = cell(size(ytCell, 1), 1);
% for i = 1:size(ytCell, 1)
%     if isempty(ytCell(i).topo_ver_)
%         VertexList{i} = [];
%     else
%         VertexList{i} = ytCell(i).topo_ver_(:, 1);
%     end
% end
% 
% 
% 
% 
% %% Begin Division
% global global_cost;
% global_cost = size(ytCell, 1);
% 
% %formulate E as an array of class
% classE = [];
% for i = 1:size(E, 1)
%     classE = [classE; Edge(E(i, 1), E(i, 2), 0, i)];
% end
% 
% global global_depth;
% global_depth = 0;
% global global_loop;
% global_loop = 0;
% global global_solution;
% global_solution = cell(0);
% %show how many possiblities have been checked
% global global_percent;
% global_percent = 0;
% 
% %% Manipulator Setting
% global global_arm;
% L1 = Revolute('alpha', pi/2,  'a', 0,        'd', 0.089159, 'qlim', [-pi, pi]);
% L2 = Revolute('alpha', 0,     'a', -0.425,   'd', 0, 'qlim', [-pi, pi]);
% L3 = Revolute('alpha', 0,     'a', -0.39225, 'd', 0, 'qlim', [-pi, pi]);
% L4 = Revolute('alpha', pi/2,  'a', 0,        'd', 0.10915, 'qlim', [-pi, pi]);
% L5 = Revolute('alpha', -pi/2, 'a', 0,        'd', 0.09465, 'qlim', [-pi, pi]);
% 
% global_arm = SerialLink([L1 L2 L3 L4 L5], 'name', 'ytArm');
% view(180, 45);
% axis([-0.5, 1.5, -1, 1, -0.5, 0.5]);
% % global_arm.plot([pi, 0, 0, 0, 0]);
% 
% % for i = 5:20
% %     fprintf('YT: show the %d-th kind of polishing configurations in joint space\n', i);
% %     showRobotPathForSingleColor(i, our_ver);
% % end
% 
% save('pan.mat');
load('pan.mat');

%% Solve problem
p = Problem(C, classE, EdgeList, VertexList, 0);
if ~p.isSolved()
    p.solveProblem(1);
end

%show the problem
p.showProblem();

%% TODO: Adding back to the hidden colors

%% TODO: transform back to mesh and visualization
%Get the boundary of each result cell (vertex list)
% Temporarily we assume that all result cells are simply-connected cells

visualization(p, ytCell);
% global_arm.plot(our_ver(1972).IK_);

%366, 663, 1044, 1162
