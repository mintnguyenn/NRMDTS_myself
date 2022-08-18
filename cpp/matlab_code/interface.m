clear
clc
close all

addpath(genpath(pwd));

meshname = 'mesh_operation/face.off';

global global_generalized_tri;
global global_generalized_ver;
[ytCell, our_ver, topo_edgelist, topo_amd] = matlab_mesh(meshname);

%% we collect color, and connect situation of each cell
%colors for each cell
C = cell(size(ytCell, 1), 1);
for i = 1:size(ytCell, 1)
    C{i} = ytCell(i).possible_color_;
end

E = topo_edgelist;

EdgeList = cell(size(ytCell, 1), 1);
for i = 1:size(ytCell, 1)
    EdgeList{i} = ytCell(i).topo_edge_index_;
end

VertexList = cell(size(ytCell, 1), 1);
for i = 1:size(ytCell, 1)
    VertexList{i} = ytCell(i).topo_ver_(:, 1);
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

%show that how many possiblities have been checked
global global_percent;
global_percent = 0;

save('human_face_6.mat');
% load('human_face_6.mat');

p = Problem(C, classE, EdgeList, VertexList, 0);
if ~p.isSolved()
    p.solveProblem(1);
end

%show the problem
p.showProblem();

%% TODO: transform back to mesh and visualization
%Get the boundary of each result cell (vertex list)
% Temporarily we assume that all result cells are simply-connected cells

visualization(p, ytCell);


