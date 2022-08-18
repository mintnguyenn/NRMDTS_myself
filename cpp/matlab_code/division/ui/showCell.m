function showCell(result_cell)
if isempty(result_cell)
    return;
end
fprintf('Show Cell:\n');
for i = 1:size(result_cell, 1)
    result_cell(i).showNode();
end
fprintf('\n');
end