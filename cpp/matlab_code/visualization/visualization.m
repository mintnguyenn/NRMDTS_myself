function visualization(p, ytCell)
% visualization(p, ytCell)
% Draw the color for the final cells


%% First we color the cells
colorlist = zeros(size(p.all_cell_, 1), 1);
combinelist = [];

for i = 1:size(p.all_cell_, 1)
    if p.all_cell_(i).merged_ == true
        continue;
    end
    colorlist(i) = p.all_cell_(i).color_;
    if isempty(p.all_cell_(i).same_)
        m = size(combinelist, 1);
        combinelist(m+1, 1) = i;
        continue;
    end
    for j = 1:size(p.all_cell_(i).same_, 1)
        colorlist(p.all_cell_(i).same_(j)) = p.all_cell_(i).color_;
    end
    m = size(combinelist, 1);
    n = size(p.all_cell_(i).same_, 1);
    combinelist(m+1, 1:n+1) = [i, p.all_cell_(i).same_'];
end

%% Here we should divide the physical cells
result_cell = ytCell;
% Then the result_cell should have the same number of cells as p.all_cell_

%% Draw the color
% we randomly create RGB value for each color
% m = max(colorlist);
% colortable = rand(m, 3);
colortable = [0, 90, 165;
    90, 165, 90;
    165, 90, 90;
    120, 199, 199];

% we draw the color
global global_generalized_tri;
global global_generalized_ver;
for i = 1:size(result_cell, 1)
    tri = result_cell(i).tri_;
    face = global_generalized_tri(tri, :);
    hold on
    patch('Faces', face, 'Vertices', global_generalized_ver, ...
        'FaceVertexCData', colortable(colorlist(i, :)), 'FaceColor', 'flat', 'LineStyle', 'none');
end


end