function P=getInvMap(face, vertex, uv2, P2d)
%P2d: pose2D, 1*2 array
%P: pose3D, 1*3 array
if P2d(1) > 1
    P2d(1) = 1;
end
if P2d(2) > 1
    P2d(2) = 1;
end
if P2d(1) < 0
    P2d(1) = 0;
end
if P2d(2) < 0 
    P2d(2) = 0;
end
i = locatePos2(P2d(1), P2d(2), face, uv2);%, kdtree);
% hold on
% plot_one_surf3(i, face, vertex);

A2d = uv2(face(i, 1), :);
B2d = uv2(face(i, 2), :);
C2d = uv2(face(i, 3), :);
A3d = vertex(face(i, 1), :);
B3d = vertex(face(i, 2), :);
C3d = vertex(face(i, 3), :);

%cross ratio
dp2dBC = abs(det([C2d-B2d; P2d - B2d])/norm(C2d - B2d));
da2dBC = abs(det([C2d-B2d; A2d - B2d])/norm(C2d - B2d));
facBC = dp2dBC/da2dBC;

%calculate the point

pAB1 = facBC * A2d + (1-facBC) * B2d;
pAC1 = facBC * A2d + (1-facBC) * C2d;
%AB1, AC1是AB, AC上的等比例点

facBC2 = norm(P2d - pAC1) / norm(pAB1 - pAC1);

pAB3d1 = facBC * A3d + (1-facBC) * B3d;
pAC3d1 = facBC * A3d + (1-facBC) * C3d;
P = facBC2 * pAB3d1 + (1-facBC2) * pAC3d1;


end