clear
clear global
clc
close all

addpath(genpath(pwd));

global global_ori_tri;
global global_ori_ver;
global global_obstacles;
global global_use_CC;
global_use_CC = true;
global global_robustness;
global_robustness = 0.1;

%% Setup handler of obstacles
if global_use_CC
    % for the simple example, there is only manipulators, the plane and the
    % object
    ground = collisionBox(4.0, 4.0, 0.01);
    T = trvec2tform([0, 0, -0.1]);
    ground.Pose = T;
    global_obstacles{1, 1} = ground;
    
    board = collisionBox(1.0, 1.0, 0.05);
    T = trvec2tform([0.9, 0, 0.025]);
    board.Pose = T;
    global_obstacles{2, 1} = board;
    
    % Show obstacles
%     hold on
%     for i = 1:size(global_obstacles, 1)
%         global_obstacles{i}.show();
%     end
end

global global_CChandle;
global_CChandle = @CC;


%% We should load different models in different .m files
% In simple example, we use the (planar) mesh
global_ori_ver = zeros(1500, 3);
for j = 0:49
    for i = 1:30
        global_ori_ver(i+j*30, 1) = i/50+0.4;
        global_ori_ver(i+j*30, 2) = (j+1)/50 - 0.5;
        global_ori_ver(i+j*30, 3) = 0.05;
    end
end

global_ori_tri = zeros(2842, 3);
for j = 1:49
    for i = 1:29
        global_ori_tri(i+(j-1)*29, :) = [i+(j-1)*30, i+1+(j-1)*30, i+j*30];
        global_ori_tri(i+(j-1)*29+29*49, :) = [i+j*30, i+1+(j-1)*30, i+1+j*30];
    end
end

reduce_cspace = false;
[ytCell, our_ver, topo_edgelist, topo_amd] = matlab_mesh(reduce_cspace);
% % Note that the boundary of the mesh is also considered as edges, which has
% % adjacent cell -1 and the constraint can only be -1(mustn't connect)
% 
% 
% 
% 
% fprintf('Show the possible colors for the initial topological graph:\n');
% for i = 1:size(ytCell, 1)
%     fprintf('Cell %d: ', i);
%     fprintf('%d, ', ytCell(i).possible_color_);
%     fprintf('\n');
% end
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
% 
% %% Manipulator Setting
% global global_arm;
% L1 = Revolute('alpha', pi/2,  'a', 0,        'd', 0.089159, 'qlim', [-pi, pi]);
% L2 = Revolute('alpha', 0,     'a', -0.425,   'd', 0, 'qlim', [-pi, pi]);
% L3 = Revolute('alpha', 0,     'a', -0.39225, 'd', 0, 'qlim', [-pi, pi]);
% L4 = Revolute('alpha', pi/2,  'a', 0,        'd', 0.10915, 'qlim', [-pi, pi]);
% L5 = Revolute('alpha', -pi/2, 'a', 0,        'd', 0.09465, 'qlim', [-pi, pi]);
% 
% global_arm = SerialLink([L1 L2 L3 L4 L5], 'name', 'arm');
% axis equal
% view([1.0, 1.0, 1.0]);
% axis([-0.5, 1.0, -1, 0.5, -0.5, 0.5]);
% % global_arm.plot(our_ver(911).IK_(1, :));
% 
% % for i = 5:20
% %     fprintf('YT: show the %d-th kind of polishing configurations in joint space\n', i);
% %     showRobotPathForSingleColor(i, our_ver);
% % end
% %
% save('human_face_6.mat');
% load('human_face_6.mat');

% %% Draw some figures for the paper
% % 545, 551, 565
% global_arm.plot(our_ver(545).IK_(1, :));
% saveas(gcf, 'simple_example_545_2', 'png');
% global_arm.plot(our_ver(545).IK_(2, :));
% saveas(gcf, 'simple_example_545_4', 'png');
% 
% global_arm.plot(our_ver(551).IK_(1, :));
% saveas(gcf, 'simple_example_551_1', 'png');
% global_arm.plot(our_ver(551).IK_(2, :));
% saveas(gcf, 'simple_example_551_2', 'png');
% global_arm.plot(our_ver(551).IK_(3, :));
% saveas(gcf, 'simple_example_551_3', 'png');
% global_arm.plot(our_ver(551).IK_(4, :));
% saveas(gcf, 'simple_example_551_4', 'png');
% 
% global_arm.plot(our_ver(565).IK_(1, :));
% saveas(gcf, 'simple_example_565_2', 'png');
% global_arm.plot(our_ver(565).IK_(2, :));
% saveas(gcf, 'simple_example_565_4', 'png');
% 
% f1 = imread('simple_example_545_2.png');
% f2 = imread('simple_example_545_4.png');
% 
% f3 = imread('simple_example_551_1.png');
% f4 = imread('simple_example_551_2.png');
% f5 = imread('simple_example_551_3.png');
% f6 = imread('simple_example_551_4.png');
% 
% f7 = imread('simple_example_565_2.png');
% f8 = imread('simple_example_565_4.png');
% 
% result = imadd(0.33*f1, 0.67*f2);
% imwrite(result, 'simple_example_merged_545.png');
% result1 = imadd(0.5*f3, 0.5*f4);
% result2 = imadd(0.3*f5, 0.7*f6);
% result = imadd(0.375*result1, 0.625*result2);
% imwrite(result, 'simple_example_merged_551.png');
% result = imadd(0.33*f7, 0.67*f8);
% imwrite(result, 'simple_example_merged_565.png');


%% Solve problem
p = Problem(C, classE, EdgeList, VertexList, 0);



if ~p.isSolved()
    p.solveProblem(1);
end

%show the problem
p.showProblem();

%% TODO: transform back to mesh and visualization
%Get the boundary of each result cell (vertex list)
% Temporarily we assume that all result cells are simply-connected cells

% visualization(p, ytCell);


