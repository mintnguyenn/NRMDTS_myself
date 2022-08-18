function showBoundaryOfCell(ytCell, index)
% showBoundaryOfCell(ytCell, index)
% index: n*1 array

global global_generalized_ver;
hold on
for i = 1:size(index, 1)
    t = index(i);
    bd = ytCell(t).boundary_;
    bd = [bd; bd(1)];
    X = global_generalized_ver(bd, 1);
    Y = global_generalized_ver(bd, 2);
    Z = global_generalized_ver(bd, 3);
    plot3(X, Y, Z, '--', 'Color', 'black', 'linewidth', 3);
end


end