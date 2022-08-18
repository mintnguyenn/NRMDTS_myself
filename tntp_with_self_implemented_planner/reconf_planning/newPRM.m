function newPRM(ur5, env, origin_ver, max_dis)
% Currently (May 2022) there are still bugs in the manipulatorRRT function
% in the MATLAB official Robotics System Toolbox
% For details please see: 
% https://ww2.mathworks.cn/support/bugreports/2629496

% Hence, this function serves as a temporary complement of the 

% ur5: The manipulator
% env: obstacles in the environment
% num_v: number of vertices in the PRM graph
% max_dis: The maximum connectable distance between two vertices
% PRM_V: vertices of the PRM graph
% PRM_E: Edges between vertices. PRM_E(i, j) being nonzero means that the (straight) path
% segment is collision-free, and the value is the travelling distance

step = 0.05;

if nargin <= 3
    max_dis = 0.3; % 1.0 rad^5 joint distance
end

%% We firstly create some vertices
global PRM_V;
global PRM_color_V;
global PRM_E;

start_index = size(PRM_V, 1)+1;
goal_index = size(PRM_V, 1)+2;

PRM_V = [PRM_V; origin_ver];
PRM_color_V = [PRM_color_V; start_index; goal_index]; % Colour of vertices. The vertices being in the same colour means that they are connected in the PRM graph

n = size(PRM_V, 1)+1;

% redundant_sampling = 1;

while 1
    % In every loop, we create 10 new samples, and check their connectivity
    temp_V = zeros(10, 6);
    i = 1;
    while i <= 10
        temp_v = rand(1, 6)*2*pi;
        temp_v(:, 6) = 0;
        inCollision = checkCollision(ur5, temp_v, env, "Exhaustive","on");
        if any(inCollision)
            continue;
        end
        temp_V(i, :) = temp_v;
        i = i + 1;
    end
    PRM_V(n:n+9, :) = temp_V;
    PRM_color_V(n:n+9, 1) = [n:n+9]';
    
    % We find edges
    for i = n:size(PRM_V, 1)
        for j = 1:i-1
            dis = norm(wrapToPi(PRM_V(i, :)-PRM_V(j, :)));
            % We create only sparse PRM graph
            if dis > max_dis
                continue;
            end
            
            % We emulate the straight motion
            num_midpoints = ceil(dis / step);
            dtheta = wrapToPi(PRM_V(j, :)-PRM_V(i, :)) / num_midpoints;
            midpoints = zeros(num_midpoints-1, 6);
            midpoints_valid = true;
            for k = 1:num_midpoints-1
                midpoints(k, :) = PRM_V(i, :) + k*dtheta;
                % We check that all the intermediate configurations are
                % collision-free
                inCollision = checkCollision(ur5, midpoints(k, :), env, "Exhaustive","on");
                if any(inCollision)
                    midpoints_valid = false;
                    break;
                end
            end
            if ~midpoints_valid
                continue;
            end

            PRM_E(i, j) = dis;
            PRM_E(j, i) = dis;
            
            % We merge their color
            PRM_color_V(PRM_color_V == PRM_color_V(i)) = PRM_color_V(j);

        end
    end
    
    % We check whether the starting vertex and goal vertex is connected. 
    % If so, we will stop creating more samples, because we only want to
    % create a valid reconfiguration instead of an optimal reconfiguration
    if PRM_color_V(start_index) == PRM_color_V(goal_index)
%         redundant_sampling = redundant_sampling + 1;
        % After every time we (incrementally) create the PRM roadmap, we
        % insert 100 extra samples
%         if redundant_sampling >= 10
            break;
%         end
    end
    
    n = size(PRM_V, 1)+1;
    n
%     if n > 100 
%         break;
%     end
   
end


end