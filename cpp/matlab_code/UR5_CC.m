function result = UR5_CC(joint)

% CC(joint)
% The collision checking function for the simple example, registering the
% planar object without obstacles
global global_use_CC;

%% If we cannot use the collision checking, directly return true(no collision)
if global_use_CC == false
    result = true;
    return ;
end

global global_obstacles;


d1 = 0.089159;
d4 = 0.10915;
d5 = 0.09465;
% dee = 0.0823;
dee = 0.15;
a2 = -0.425;
a3 = -0.39225;

c1 = cos(joint(1));
s1 = sin(joint(1));
c2 = cos(joint(2));
s2 = sin(joint(2));
c3 = cos(joint(3));
s3 = sin(joint(3));
c4 = cos(joint(4));
s4 = sin(joint(4));
c5 = cos(joint(5));
s5 = sin(joint(5));


T01 = [c1, 0, s1, 0;
    s1, 0, -c1, 0;
    0, 1, 0, d1;
    0, 0, 0, 1];
T12 = [c2, -s2, 0, a2*c2;
    s2, c2, 0, a2*s2;
    0, 0, 1, 0;
    0, 0, 0, 1];
T23 = [c3, -s3, 0, a3*c3;
    s3, c3, 0, a3*s3;
    0, 0, 1, 0;
    0, 0, 0, 1];
T34 = [c4, 0, s4, 0;
    s4, 0, -c4, 0;
    0, 1, 0, d4;
    0, 0, 0, 1];
T45 = [c5, 0, -s5, 0;
    s5, 0, c5, 0;
    0, -1, 0, d5;
    0, 0, 0, 1];
T5ee = [1, 0, 0, 0;
    0, 1, 0, 0;
    0, 0, 1, dee;
    0, 0, 0, 1];

% The radius for the big joint and the small joint
R = 0.08;
r = 0.04;

% create several cylinders based on the structure of UR5
cy(1, 1) = collisionCylinder(R, 0.16);
cy(1, 1).Pose = eye(4);
cy(1, 1).Pose(1:3, 4) = cy(1, 1).Pose(1:3, 4) + 0.05*cy(1, 1).Pose(1:3, 3);

cy(2, 1) = collisionCylinder(R, 0.3);
T = T01;
T02 = T01*T12;
T(1:3, 1:3) = T02(1:3, 1:3);
T(1:3, 4) = T(1:3, 4) + 0.07*T(1:3, 3);
cy(2, 1).Pose = T;

cy(3, 1) = collisionCylinder(R, 0.56);
T = T01;
T02 = T01*T12;
T(1:3, 1:3) = T02(1:3, 1:3);
T(1:3, 4) = T(1:3, 4) - T(1:3, 1)*(-a2)*0.5 + 0.15*T(1:3, 3);
T(1:3, 1:3) = [T(1:3, 3), T(1:3, 2), -T(1:3, 1)];
cy(3, 1).Pose = T;

cy(4, 1) = collisionCylinder(R, 0.3);
T = T01;
T02 = T01*T12;
T(1:3, 1:3) = T02(1:3, 1:3);
T(1:3, 4) = T(1:3, 4) + 0.07*T(1:3, 3) - (-a2)*T(1:3, 1);
cy(4, 1).Pose = T;


cy(5, 1) = collisionCylinder(R, 0.48);
T = T01*T12;
T03 = T01*T12*T23;
T(1:3, 1:3) = T03(1:3, 1:3); 
T(1:3, 4) = T(1:3, 4)-T(1:3, 1)*0.12;
T(1:3, 1:3) = [T(1:3, 3), T(1:3, 2), -T(1:3, 1)];
cy(5, 1).Pose = T;

cy(6, 1) = collisionCylinder(r, 0.2);
T = T01*T12*T23;
T(1:3, 4) = T(1:3, 4)+T(1:3, 3)*0.02;
cy(6, 1).Pose = T;

cy(7, 1) = collisionCylinder(r, 0.2);
T = T01*T12*T23*T34;
T(1:3, 4) = T(1:3, 4)+T(1:3, 3)*0.04;
cy(7, 1).Pose = T;

cy(8, 1) = collisionCylinder(r, 0.2);
T = T01*T12*T23*T34*T45;
T(1:3, 4) = T(1:3, 4)+T(1:3, 3)*0.04;
cy(8, 1).Pose = T;

%% Check whether the manipulator hits something
for i = 1:size(global_obstacles, 1)
    if isempty(global_obstacles{i})
        continue;
    end
    for j = 1:size(cy, 1)
        b = checkCollision(global_obstacles{i}, cy(j));
        if b
            result = false;
            return ;
        end
    end
end

%% Check self collision
b = checkCollision(cy(5), cy(8));
if b
    result = false;
    return ;
end

result = true;

% for i=1:size(cy, 1)
%     hold on
%     cy(i, 1).show();
% end

end