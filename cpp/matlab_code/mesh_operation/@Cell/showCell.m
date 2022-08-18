function showCell(obj)

global global_generalized_ver;

n = size(obj.boundary_, 1);
X = zeros(n+1, 1);
Y = zeros(n+1, 1);
Z = zeros(n+1, 1);

for i = 1:n
    X(i) = global_generalized_ver(obj.boundary_(i), 1);
    Y(i) = global_generalized_ver(obj.boundary_(i), 2);
    Z(i) = global_generalized_ver(obj.boundary_(i), 3);
end
X(n+1) = global_generalized_ver(obj.boundary_(1), 1);
Y(n+1) = global_generalized_ver(obj.boundary_(1), 2);
Z(n+1) = global_generalized_ver(obj.boundary_(1), 3);

figure(1);
hold on
plot3(X, Y, Z, 'black');
end