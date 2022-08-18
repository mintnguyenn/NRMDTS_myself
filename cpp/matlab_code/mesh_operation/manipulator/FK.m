function [pose, position, EE_zaxis] = FK(joint_angle)
% given a list of joint angles, calculate their position of EE
n = size(joint_angle, 1);
pose = [];
position = zeros(n, 3);
EE_zaxis = zeros(n, 3);

d1 = 0.089159;
d4 = 0.10915;
d5 = 0.09465;
dee = 0.0823;
% dee = 0.2;
a2 = -0.425;
a3 = -0.39225;

for i = 1:n
    c1 = cos(joint_angle(i, 1));
    s1 = sin(joint_angle(i, 1));
    c2 = cos(joint_angle(i, 2));
    s2 = sin(joint_angle(i, 2));
    c3 = cos(joint_angle(i, 3));
    s3 = sin(joint_angle(i, 3));
    c4 = cos(joint_angle(i, 4));
    s4 = sin(joint_angle(i, 4));
    c5 = cos(joint_angle(i, 5));
    s5 = sin(joint_angle(i, 5));
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
    T = T01*T12*T23*T34*T45*T5ee;
    position(i, 1:3) = T(1:3, 4)';
    EE_zaxis(i, 1:3) = T(1:3, 3)';
end


end