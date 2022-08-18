% For signal calculation of UR5
syms t1 t2 t3 t4 t5 a2 a3 d1 d4 d5 d_ee
% c1 = cos(t1);
% s1 = sin(t1);
% c2 = cos(t2);
% s2 = sin(t2);
% c3 = cos(t3);
% s3 = sin(t3);
% c4 = cos(t4);
% s4 = sin(t4);
% c5 = cos(t5);
% s5 = sin(t5);
% T01 = [c1, 0, s1, 0; 
%     s1, 0, -c1, 0; 
%     0, 1, 0, d1; 
%     0, 0, 0, 1];
% T12 = [c2, -s2, 0, a2*c2;
%     s2, c2, 0, a2*s2; 
%     0, 0, 1, 0; 
%     0, 0, 0, 1];
% T23 = [c3, -s3, 0, a3*c3; 
%     s3, c3, 0, a3*s3; 
%     0, 0, 1, 0;
%     0, 0, 0, 1];
% T34 = [c4, 0, s4, 0; 
%     s4, 0, -c4, 0; 
%     0, 1, 0, d4; 
%     0, 0, 0, 1];
% T45 = [c5, 0, -s5, 0; 
%     s5, 0, c5, 0; 
%     0, -1, 0, d5;
%     0, 0, 0, 1];
% T5ee = [1, 0, 0, 0; 
%     0, 1, 0, 0; 
%     0, 0, 1, d_ee; 
%     0, 0, 0, 1];
% T01*T12*T23*T34*T45*T5ee;
% latex(d1 + a2*sin(t2) - d5*(cos(t4)*(cos(t2)*cos(t3) - sin(t2)*sin(t3)) - sin(t4)*(cos(t2)*sin(t3) + cos(t3)*sin(t2))) + a3*cos(t2)*sin(t3) + a3*cos(t3)*sin(t2) - d_ee*sin(t5)*(cos(t4)*(cos(t2)*sin(t3) + cos(t3)*sin(t2)) + sin(t4)*(cos(t2)*cos(t3) - sin(t2)*sin(t3))));

expressx = d5*(cos(t4)*(cos(t1)*cos(t2)*sin(t3) + cos(t1)*cos(t3)*sin(t2)) - sin(t4)*(cos(t1)*sin(t2)*sin(t3) - cos(t1)*cos(t2)*cos(t3))) + d4*sin(t1) + d_ee*(cos(t5)*sin(t1) + sin(t5)*(cos(t4)*(cos(t1)*sin(t2)*sin(t3) - cos(t1)*cos(t2)*cos(t3)) + sin(t4)*(cos(t1)*cos(t2)*sin(t3) + cos(t1)*cos(t3)*sin(t2)))) + a2*cos(t1)*cos(t2) + a3*cos(t1)*cos(t2)*cos(t3) - a3*cos(t1)*sin(t2)*sin(t3);
expressy = d5*(cos(t4)*(cos(t2)*sin(t1)*sin(t3) + cos(t3)*sin(t1)*sin(t2)) - sin(t4)*(sin(t1)*sin(t2)*sin(t3) - cos(t2)*cos(t3)*sin(t1))) - d_ee*(cos(t1)*cos(t5) - sin(t5)*(cos(t4)*(sin(t1)*sin(t2)*sin(t3) - cos(t2)*cos(t3)*sin(t1)) + sin(t4)*(cos(t2)*sin(t1)*sin(t3) + cos(t3)*sin(t1)*sin(t2)))) - d4*cos(t1) + a2*cos(t2)*sin(t1) + a3*cos(t2)*cos(t3)*sin(t1) - a3*sin(t1)*sin(t2)*sin(t3);
expressz = d1 + a2*sin(t2) - d5*(cos(t4)*(cos(t2)*cos(t3) - sin(t2)*sin(t3)) - sin(t4)*(cos(t2)*sin(t3) + cos(t3)*sin(t2))) + a3*cos(t2)*sin(t3) + a3*cos(t3)*sin(t2) - d_ee*sin(t5)*(cos(t4)*(cos(t2)*sin(t3) + cos(t3)*sin(t2)) + sin(t4)*(cos(t2)*cos(t3) - sin(t2)*sin(t3)));
% fprintf('YT: show differentiation\n');

dfx1 = diff(expressx, 't1')
dfx2 = diff(expressx, 't2')
dfx3 = diff(expressx, 't3')
dfx4 = diff(expressx, 't4')
dfx5 = diff(expressx, 't5')

dfy1 = diff(expressy, 't1')
dfy2 = diff(expressy, 't2')
dfy3 = diff(expressy, 't3')
dfy4 = diff(expressy, 't4')
dfy5 = diff(expressy, 't5')

dfz1 = diff(expressz, 't1')
dfz2 = diff(expressz, 't2')
dfz3 = diff(expressz, 't3')
dfz4 = diff(expressz, 't4')
dfz5 = diff(expressz, 't5')




