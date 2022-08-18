clear
clear global
clc
close all

addpath(genpath(pwd));

global global_ori_tri;
global global_ori_ver;
global global_generalized_tri;
global global_generalized_ver;
global global_obstacles;
global global_use_CC;
global_use_CC = true;
global global_robustness;
global_robustness = 0.05;

%% Generate a pipe with radius 0.1, length 0.5
R = 0.18;
global_ori_ver = zeros(2500, 3);

for i = 1:50
    for j = 1:25
        phi = (i-1 + 50)/100*2*pi;
        l = (j-1)*0.02 - 0.25;
        global_ori_ver(i+(j-1)*50, 3) = l;
        global_ori_ver(i+(j-1)*50, 1) = R*cos(phi);
        global_ori_ver(i+(j-1)*50, 2) = R*sin(phi);
    end
end

global_ori_tri = zeros(49*24*2, 3);
for j = 1:24
    for i = 1:49
        global_ori_tri((i + (j-1)*49-1)*2+1, :) = [i+(j-1)*50, i+1+(j-1)*50, i+1+j*50];
        global_ori_tri((i + (j-1)*49-1)*2+2, :) = [i+(j-1)*50, i+1+j*50, i+j*50];
    end
end


%% Move the object to a desire place
% rotation:none

Y = global_ori_ver(:, 2);
Z = global_ori_ver(:, 3);
global_ori_ver(:, 2) = Y*cos(45/180*pi) - Z*sin(45/180*pi);
global_ori_ver(:, 3) = Y*sin(45/180*pi) + Z*cos(45/180*pi);


X = global_ori_ver(:, 1);
Y = global_ori_ver(:, 2);
global_ori_ver(:, 1) = X*cos(-45/180*pi) - Y*sin(-45/180*pi);
global_ori_ver(:, 2) = X*sin(-45/180*pi) + Y*cos(-45/180*pi);



global_ori_ver(:, 1) = global_ori_ver(:, 1)+0.45;
global_ori_ver(:, 2) = global_ori_ver(:, 2)+0.45;
global_ori_ver(:, 3) = global_ori_ver(:, 3)+0.45;

plot_mesh(global_ori_tri, global_ori_ver);


%% Setup handler of obstacles
% for the pan, there is only manipulators, the plane and the
% object
if global_use_CC
    % for the simple example, there is only manipulators, the plane and the
    % object
    ground = collisionBox(1.0, 1.0, 0.001);
    T = trvec2tform([0.5, -0.5, -0.01]);
    ground.Pose = T;
    global_obstacles{1, 1} = ground;
    
    % insert the object itself for collision-checking
    object = collisionMesh(global_ori_ver); 
    T = eye(4);
    object.Pose = T;
    global_obstacles{2, 1} = object;
    % Show obstacles
%     X = [0, 1, 1, 0];
%     Y = [-0.5, -0.5, 0.5, 0.5];
%     Z = [-0.01, -0.01, -0.01, -0.01];
%     patch(X, Y, Z, 'white');
    
end
global global_CChandle;
global_CChandle = @CC;

reduce_cspace = true;
[ytCell, our_ver, topo_edgelist, topo_amd] = matlab_mesh(reduce_cspace);
% Note that the boundary of the mesh is also considered as edges, which has
% adjacent cell -1 and the constraint can only be -1(mustn't connect)

fprintf('Show the possible colors for the initial topological graph:\n');
for i = 1:size(ytCell, 1)
    fprintf('Cell %d: ', i);
    fprintf('%d, ', ytCell(i).possible_color_);
    fprintf('\n');
end


%% we collect color, and connect situation of each cell
%colors for each cell
C = cell(size(ytCell, 1), 1);
for i = 1:size(ytCell, 1)
    C{i} = ytCell(i).possible_color_;
end

% If any edge is the boundary of the topological graph, then the other
% cell will be marked as -1
E = topo_edgelist;

EdgeList = cell(size(ytCell, 1), 1);
for i = 1:size(ytCell, 1)
    EdgeList{i} = ytCell(i).topo_edge_index_;
end

VertexList = cell(size(ytCell, 1), 1);
for i = 1:size(ytCell, 1)
    if isempty(ytCell(i).topo_ver_)
        VertexList{i} = [];
    else
        VertexList{i} = ytCell(i).topo_ver_(:, 1);
    end
end

%% Begin Division
global global_cost;
global_cost = size(ytCell, 1);

%formulate E as an array of class
classE = [];
for i = 1:size(E, 1)
    classE = [classE; Edge(E(i, 1), E(i, 2), 0, i)];
end

global global_depth;
global_depth = 0;
global global_loop;
global_loop = 0;
global global_solution;
global_solution = cell(0);
%show how many possiblities have been checked
global global_percent;
global_percent = 0;

%% Manipulator Setting
global global_arm;
L1 = Revolute('alpha', pi/2,  'a', 0,        'd', 0.089159, 'qlim', [-pi, pi]);
L2 = Revolute('alpha', 0,     'a', -0.425,   'd', 0, 'qlim', [-pi, pi]);
L3 = Revolute('alpha', 0,     'a', -0.39225, 'd', 0, 'qlim', [-pi, pi]);
L4 = Revolute('alpha', pi/2,  'a', 0,        'd', 0.10915, 'qlim', [-pi, pi]);
L5 = Revolute('alpha', -pi/2, 'a', 0,        'd', 0.09465, 'qlim', [-pi, pi]);

global_arm = SerialLink([L1 L2 L3 L4 L5], 'name', 'Arm');
global_arm.plot(our_ver(125).IK_(1, :));
% view(0, 0);
view(-90, 0);
% view(-45, -45);
% axis([0.15, 1, 0.15, 1, 0.15, 1]);
axis([-0.2, 1, -0.2, 1, -0.2, 0.8]);

save('pipe.mat');
% load('pipe.mat');

%% Solve problem
p = Problem(C, classE, EdgeList, VertexList, 0);
if ~p.isSolved()
    p.solveProblem(1);
end

%show the problem
p.showProblem();
% 
% %% TODO: transform back to mesh and visualization
% %Get the boundary of each result cell (vertex list)
% % Temporarily we assume that all result cells are simply-connected cells
% 
% visualization(p, ytCell);
% % global_arm.plot(our_ver(1972).IK_);

