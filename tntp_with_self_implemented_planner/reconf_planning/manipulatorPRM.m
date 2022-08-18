function [result_path] = manipulatorPRM(start, goal, ur5, env)

global PRM_V;

start_5dof = [start(1:5), 0];
goal_5dof = [goal(1:5), 0];

% Because we will insert the start configuration and the goal configuration
% into the PRM roadmap
start_index = size(PRM_V, 1) + 1;
goal_index = size(PRM_V, 1) + 2;

newPRM(ur5, env, [start_5dof; goal_5dof], 1.5);

result_path_index = Dijkstra(start_index, goal_index);

result_path = PRM_V(result_path_index, :);

end