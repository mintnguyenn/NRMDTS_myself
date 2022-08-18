function colorCell(ytCell, index, color)
% colorCell(ytCell, index, color
% draw ytCell(index) through the given color
% the color is a 1*3 array of RGB between 0~255

global global_generalized_ver;
global global_generalized_tri;

hold on
for i = 1:size(index, 1)
    bd = ytCell(index(i)).boundary_;
    
    face = global_generalized_tri(ytCell(index(i)).tri_, :);
    
    patch('Faces', face, 'Vertices', global_generalized_ver, 'EdgeColor', 'none', 'FaceColor', color/255);
        
end


end