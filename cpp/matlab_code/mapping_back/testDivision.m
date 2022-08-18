clear
clear global
clc
close all

addpath(genpath(pwd));




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
load('human_face_6.mat');



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
