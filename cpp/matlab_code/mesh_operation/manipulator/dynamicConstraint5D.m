% function b = dynamicConstraint5D(t1, t2, t3, t4, t5)
function b = dynamicConstraint5D(temp)
% dynamicConstraint5D(joint)
% Since we use the z-axis of the EE to polish the surface (no torque, only force), 
% we calculate the first three rows of the velocity Jacobian, thus the first
% three coloumns of the static force Jacobian, J(5*3). We calculate
% det(J^TJ) for a threshold of the robustness of the configuration
global global_robustness;
t1 = temp(1);
    t2 = temp(2);
    t3 = temp(3);
    t4 = temp(4);
    t5 = temp(5);

a2 = -0.425;
a3 = -0.39225;
d1 = 0.089159;
d4 = 0.10915;
d5 = 0.09465;
d_ee = 0.0823;

% the threshold of robustness
robust_f = global_robustness;


%% Besides the constraint of static force, we need the manipulator to have robustness on the x-axis and y-axis
dfx1 = d_ee*(cos(t1)*cos(t5) - sin(t5)*(cos(t4)*(sin(t1)*sin(t2)*sin(t3) - cos(t2)*cos(t3)*sin(t1)) + sin(t4)*(cos(t2)*sin(t1)*sin(t3) + cos(t3)*sin(t1)*sin(t2)))) - d5*(cos(t4)*(cos(t2)*sin(t1)*sin(t3) + cos(t3)*sin(t1)*sin(t2)) - sin(t4)*(sin(t1)*sin(t2)*sin(t3) - cos(t2)*cos(t3)*sin(t1))) + d4*cos(t1) - a2*cos(t2)*sin(t1) - a3*cos(t2)*cos(t3)*sin(t1) + a3*sin(t1)*sin(t2)*sin(t3);
dfx2 = d_ee*sin(t5)*(cos(t4)*(cos(t1)*cos(t2)*sin(t3) + cos(t1)*cos(t3)*sin(t2)) - sin(t4)*(cos(t1)*sin(t2)*sin(t3) - cos(t1)*cos(t2)*cos(t3))) - d5*(cos(t4)*(cos(t1)*sin(t2)*sin(t3) - cos(t1)*cos(t2)*cos(t3)) + sin(t4)*(cos(t1)*cos(t2)*sin(t3) + cos(t1)*cos(t3)*sin(t2))) - a2*cos(t1)*sin(t2) - a3*cos(t1)*cos(t2)*sin(t3) - a3*cos(t1)*cos(t3)*sin(t2);
dfx3 = d_ee*sin(t5)*(cos(t4)*(cos(t1)*cos(t2)*sin(t3) + cos(t1)*cos(t3)*sin(t2)) - sin(t4)*(cos(t1)*sin(t2)*sin(t3) - cos(t1)*cos(t2)*cos(t3))) - d5*(cos(t4)*(cos(t1)*sin(t2)*sin(t3) - cos(t1)*cos(t2)*cos(t3)) + sin(t4)*(cos(t1)*cos(t2)*sin(t3) + cos(t1)*cos(t3)*sin(t2))) - a3*cos(t1)*cos(t2)*sin(t3) - a3*cos(t1)*cos(t3)*sin(t2);
dfx4 = d_ee*sin(t5)*(cos(t4)*(cos(t1)*cos(t2)*sin(t3) + cos(t1)*cos(t3)*sin(t2)) - sin(t4)*(cos(t1)*sin(t2)*sin(t3) - cos(t1)*cos(t2)*cos(t3))) - d5*(cos(t4)*(cos(t1)*sin(t2)*sin(t3) - cos(t1)*cos(t2)*cos(t3)) + sin(t4)*(cos(t1)*cos(t2)*sin(t3) + cos(t1)*cos(t3)*sin(t2)));
dfx5 = -d_ee*(sin(t1)*sin(t5) - cos(t5)*(cos(t4)*(cos(t1)*sin(t2)*sin(t3) - cos(t1)*cos(t2)*cos(t3)) + sin(t4)*(cos(t1)*cos(t2)*sin(t3) + cos(t1)*cos(t3)*sin(t2))));

dfy1 = d5*(cos(t4)*(cos(t1)*cos(t2)*sin(t3) + cos(t1)*cos(t3)*sin(t2)) - sin(t4)*(cos(t1)*sin(t2)*sin(t3) - cos(t1)*cos(t2)*cos(t3))) + d4*sin(t1) + d_ee*(cos(t5)*sin(t1) + sin(t5)*(cos(t4)*(cos(t1)*sin(t2)*sin(t3) - cos(t1)*cos(t2)*cos(t3)) + sin(t4)*(cos(t1)*cos(t2)*sin(t3) + cos(t1)*cos(t3)*sin(t2)))) + a2*cos(t1)*cos(t2) + a3*cos(t1)*cos(t2)*cos(t3) - a3*cos(t1)*sin(t2)*sin(t3);
dfy2 = d_ee*sin(t5)*(cos(t4)*(cos(t2)*sin(t1)*sin(t3) + cos(t3)*sin(t1)*sin(t2)) - sin(t4)*(sin(t1)*sin(t2)*sin(t3) - cos(t2)*cos(t3)*sin(t1))) - d5*(cos(t4)*(sin(t1)*sin(t2)*sin(t3) - cos(t2)*cos(t3)*sin(t1)) + sin(t4)*(cos(t2)*sin(t1)*sin(t3) + cos(t3)*sin(t1)*sin(t2))) - a2*sin(t1)*sin(t2) - a3*cos(t2)*sin(t1)*sin(t3) - a3*cos(t3)*sin(t1)*sin(t2);
dfy3 = d_ee*sin(t5)*(cos(t4)*(cos(t2)*sin(t1)*sin(t3) + cos(t3)*sin(t1)*sin(t2)) - sin(t4)*(sin(t1)*sin(t2)*sin(t3) - cos(t2)*cos(t3)*sin(t1))) - d5*(cos(t4)*(sin(t1)*sin(t2)*sin(t3) - cos(t2)*cos(t3)*sin(t1)) + sin(t4)*(cos(t2)*sin(t1)*sin(t3) + cos(t3)*sin(t1)*sin(t2))) - a3*cos(t2)*sin(t1)*sin(t3) - a3*cos(t3)*sin(t1)*sin(t2);
dfy4 = d_ee*sin(t5)*(cos(t4)*(cos(t2)*sin(t1)*sin(t3) + cos(t3)*sin(t1)*sin(t2)) - sin(t4)*(sin(t1)*sin(t2)*sin(t3) - cos(t2)*cos(t3)*sin(t1))) - d5*(cos(t4)*(sin(t1)*sin(t2)*sin(t3) - cos(t2)*cos(t3)*sin(t1)) + sin(t4)*(cos(t2)*sin(t1)*sin(t3) + cos(t3)*sin(t1)*sin(t2)));
dfy5 = d_ee*(cos(t1)*sin(t5) + cos(t5)*(cos(t4)*(sin(t1)*sin(t2)*sin(t3) - cos(t2)*cos(t3)*sin(t1)) + sin(t4)*(cos(t2)*sin(t1)*sin(t3) + cos(t3)*sin(t1)*sin(t2))));

dfz1 = 0;
dfz2 = a2*cos(t2) + d5*(cos(t4)*(cos(t2)*sin(t3) + cos(t3)*sin(t2)) + sin(t4)*(cos(t2)*cos(t3) - sin(t2)*sin(t3))) + a3*cos(t2)*cos(t3) - a3*sin(t2)*sin(t3) - d_ee*sin(t5)*(cos(t4)*(cos(t2)*cos(t3) - sin(t2)*sin(t3)) - sin(t4)*(cos(t2)*sin(t3) + cos(t3)*sin(t2)));
dfz3 = d5*(cos(t4)*(cos(t2)*sin(t3) + cos(t3)*sin(t2)) + sin(t4)*(cos(t2)*cos(t3) - sin(t2)*sin(t3))) + a3*cos(t2)*cos(t3) - a3*sin(t2)*sin(t3) - d_ee*sin(t5)*(cos(t4)*(cos(t2)*cos(t3) - sin(t2)*sin(t3)) - sin(t4)*(cos(t2)*sin(t3) + cos(t3)*sin(t2)));
dfz4 = d5*(cos(t4)*(cos(t2)*sin(t3) + cos(t3)*sin(t2)) + sin(t4)*(cos(t2)*cos(t3) - sin(t2)*sin(t3))) - d_ee*sin(t5)*(cos(t4)*(cos(t2)*cos(t3) - sin(t2)*sin(t3)) - sin(t4)*(cos(t2)*sin(t3) + cos(t3)*sin(t2)));
dfz5 = -d_ee*cos(t5)*(cos(t4)*(cos(t2)*sin(t3) + cos(t3)*sin(t2)) + sin(t4)*(cos(t2)*cos(t3) - sin(t2)*sin(t3)));


% The Jacobian for the force
J = [dfx1, dfy1, dfz1; 
    dfx2, dfy2, dfz2; 
    dfx3, dfy3, dfz3; 
    dfx4, dfy4, dfz4; 
    dfx5, dfy5, dfz5];

robustness = sqrt(det(J'*J));

if robustness < robust_f
    b = false;
else
    b = true;
end

end