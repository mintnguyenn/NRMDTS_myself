% clear; clc;

robot = ur5e();

q1 = [0, -pi/2, 0, -pi/2, 0, 0];
q2 = [-pi/4, -pi/3, pi/2, 0, 0, 0];
% qMatrix1 = jtraj(robot.qDef, q1, 50);
% qMatrix2 = jtraj(q1, robot.qDef, 50);

% controlURRobot();

while(1)
robot.moveRealRobot(q1);
robot.moveRealRobot(q2);
end

%%
