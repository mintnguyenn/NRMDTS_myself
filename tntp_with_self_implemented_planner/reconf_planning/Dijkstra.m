function result_path = Dijkstra(start, goal)

global PRM_V;
global PRM_E;

MAX = 10000;


V = PRM_V;

E = zeros(size(PRM_V, 1), size(PRM_V, 1));
E(1:size(PRM_E, 1), 1:size(PRM_E, 1)) = full(PRM_E);

% E = full(PRM_E);
E(E == 0) = MAX;

D = zeros(size(V, 1), 1);% length of shortest path
% p = zeros(size(V, 1), size(V, 1));% The paths
p = zeros(size(V, 1), 1);

final = zeros(size(V, 1), 1);% final[i] = 1 means that vi has been in set S

n = size(V, 1);
v0 = start;
p(:) = -1;

for v = 1:size(V, 1)
    D(v) = E(v0, v);
    if D(v) < MAX
        p(v) = v0;
    end
end
D(v0) = 0;
final(v0) = 1;% We put v0 into the closed list

for i = 2:n
    min_cost = MAX;
    for w = 1:n
        if final(w) ~= 1
            if D(w) < min_cost
                v = w;
                min_cost = D(w);
            end
        end
    end
    if min_cost == MAX
        break;
    end
    final(v) = 1;
    for w = 1:n
        if final(w) ~= 1 && (min_cost + E(v, w) < D(w))
            D(w) = min_cost + E(v, w);
            p(w) = v;
        end
    end
end

result_path = [];
cur = goal;
while p(cur) ~= -1 && D(cur) < MAX
    result_path = [p(cur); result_path];
    cur = p(cur);
end

end
