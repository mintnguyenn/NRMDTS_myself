function result = IK(px, py, pz, nx, ny, nz)
% we assume that the parameter of the 5DOF manipulator has been given 
% px, py, pz is the 3D position of the EE
% nx, ny, nz is the unit normal vector pointing at the surface 

d1 = 0.089159;
d4 = 0.10915;
d5 = 0.09465;
% dee = 0.0823;
dee = 0.15;% for the UR5 
a2 = -0.425;
a3 = -0.39225;

%store the result
%[theta1, theta2, theta3, theta4, theta5, ax, ay, az, bx, by, bz, m1, m2, nouse]
%  1,       2,      3,      4,      5,    6,  7,  8,  9,  10, 11, 12, 13, 14
result = zeros(1, 14);

temp1 = d4/sqrt((px - dee*nx)^2 + (dee*ny - py)^2);
if abs(temp1) > 1
%     warning('YT: error, cannot find correct temp1\n');
    result = [];
    return ;
    
end

temp1(1) = acos(temp1);
temp1(2) = -temp1(1);

temp2 = atan2(px - dee*nx, dee*ny - py);
result(1, 1) = temp1(1)+ temp2;
result(2, 1) = temp1(2)+ temp2;

%% Clear the joint angles if theta1 greater than pi or less than -pi
for i = size(result, 1):-1:1
    if abs(result(i, 1)) > pi
        result(i, 1) = wrapToPi(result(i, 1));
    end
end

%% Solve theta5
n = size(result, 1);
for i = 1:n
    result(i+n, :) = result(i, :);

    s1 = sin(result(i, 1));
    c1 = cos(result(i, 1));
    
    temp2 = s1*nx - c1*ny;
    if abs(temp2) > 1
        warning('YT: cannot solve theta5\n');
    end
    result(i, 5) = acos(temp2);
    result(i+n, 5) = -acos(temp2);
end

% %% If theta5 does not satisfy the other constraint, then we delete it
% for i = size(result, 1):-1:1
%     c5 = cos(result(i, 5));
%     s5 = sin(result(i, 5));
%     s1 = sin(result(i, 1));
%     c1 = cos(result(i, 1));
%     if abs(c5 - s1*nx + c1*ny) > 0.01
%         warning('YT: error solving theta5\n');
%         result(i, :) = [];
%     end
% end


n = size(result, 1);
%% Solve bx
for i = 1:n
    result(i+n, :) = result(i, :);
    if result(i, 14) == 1
        continue;
    end
    s1 = sin(result(i, 1));
    c1 = cos(result(i, 1));
    t1 = tan(result(i, 1));
    
    temp3 = 1+ t1^2 + nx^2/nz^2 + ...
        ny^2/nz^2*t1^2 + ...
        2 * nx * ny * t1 / nz^2;

    result(i, 9) = sqrt(1/temp3);
    result(i+n, 9) = -sqrt(1/temp3);
end

%% Solve by, bz, ax, ay, az, m1, m2
n = size(result, 1);
for i = 1:n    
    result(i, 10) = tan(result(i, 1)) * result(i, 9);
    result(i, 11) = -nx/nz*result(i, 9) - ny/nz*result(i, 10);
    result(i, 6) = result(i, 10)*nz - result(i, 11)*ny;
    result(i, 7) = result(i, 11)*nx - result(i, 9)*nz;
    result(i, 8) = result(i, 9) * ny - result(i, 10)*nx;
    
    c1 = cos(result(i, 1));
    s1 = sin(result(i, 1));
    
    result(i, 12) = d5*(c1*result(i, 9) + s1*result(i, 10)) - ...
        dee*(c1*nx+s1*ny) + c1*px + s1*py;
    result(i, 13) = d5*result(i, 11) - dee*nz + pz - d1;
end

%% If ax and ay does not satisfy the constraint given in (3, 1), we delete it
for i = size(result, 1):-1:1
    s5 = sin(result(i, 5));
    c5 = cos(result(i, 5));
    ax = result(i, 6);
    ay = result(i, 7);
    s1 = sin(result(i, 1));
    c1 = cos(result(i, 1));
    if abs(s5 - s1*ax + c1*ay) > 0.01
%         warning('YT: the ax and ay are not valid\n');
        result(i, :) = [];
    end
end


%% Solve theta3
n = size(result, 1);
for i = 1:n
    result(i+n, :) = result(i, :);

    m1 = result(i, 12);
    m2 = result(i, 13);
    temp4 = (m1^2 + m2^2 - a3^2 - a2^2)/2/a2/a3;
    if abs(temp4) > 1
        result(i, 14) = 1;
        result(i+n, 14) = 1;
        continue;
    end
    result(i, 3) = acos(temp4);
    result(i+n, 3) = -acos(temp4);
end

for i = size(result, 1):-1:1
    if result(i, 14) == 1
        result(i, :) = [];
    end
end

n = size(result, 1);
%% Solve theta2
for i = 1:n
    result(i+n, :) = result(i, :);
    m2 = result(i, 13);
    m1 = result(i, 12);
    c3 = cos(result(i, 3));
    s3 = sin(result(i, 3));
    
    temp5 = (m1/a3/s3 + m2/(a3*c3+a2)) / ((a3*c3+a2)/a3/s3 + a3*s3/(a3*c3 + a2));
    if abs(temp5) > 1
        result(i, 14) = 1;
        result(i+n, 14) = 1;
        continue;
    end
    result(i, 2) = acos(temp5);
    result(i+n, 2) = -acos(temp5);

end

%% If theta2 and theta3 does not satisfy the constraint, we delete it
for i = size(result, 1):-1:1
    c23 = cos(result(i, 2)+ result(i, 3));
    s23 = sin(result(i, 2)+ result(i, 3));
    c2 = cos(result(i, 2));
    s2 = sin(result(i, 2));
    m1 = result(i, 12);
    m2 = result(i, 13);
    if abs(m1 - a3*c23 - a2*c2) > 0.01
%         warning('YT: error theta2 and theta3 when checking m1\n');
        result(i, :) = [];
        continue;
    end
    if abs(m2 - a3*s23 - a2*s2) > 0.01
%         warning('YT: error theta2 and theta3 when checking m2\n');
        result(i, :) = [];
        continue;
    end
end


%% Solve theta4
n = size(result, 1);
for i = 1:n
    c1 = cos(result(i, 1));
    c5 = cos(result(i, 5));
    ax = result(i, 6);
    ay = result(i, 7);
    az = result(i, 8);
    s1 = sin(result(i, 1));
    s5 = sin(result(i, 5));
    
    result(i, 4) = atan2(c5*az - s5*nz, c5*(c1*ax+s1*ay) - s5*(c1*nx + s1*ny) );
    
    result(i, 4) = wrapToPi(result(i, 4) - result(i, 2) - result(i, 3));
end

for i = size(result, 1):-1:1
    if result(i, 14) == 1
        result(i, :) = [];
    end
end

%% Clear result
result = result(:, 1:5);

i= 1;
while(1)
    if i >= size(result, 1)
        break;
    end
    for j = size(result, 1):-1:i+1
        if norm(result(i, :) - result(j, :)) < 0.01
            result(j, :) = [];
        end
    end    
    i = i+1;
end




