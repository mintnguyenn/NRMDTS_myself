function b = isSolved(pg1)

for i = 1:size(pg1, 1)
    all_cell = pg1(i).all_cell_;
    b = true;
    for i = 1:size(all_cell, 1)
        if all_cell(i).open_ == true
            b = false;
            return ;
        end
    end
end
end