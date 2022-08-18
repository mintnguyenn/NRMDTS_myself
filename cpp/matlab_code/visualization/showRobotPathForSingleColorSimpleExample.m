function showRobotPathForSingleColorSimpleExample(colornum, our_ver)
% showRobotPathForSingleColor(colornum, our_ver)
% The visualization for the original configuration, each color draws a
% continous region which can be polished using the specified kind of
% configuration
%% TODO: Generate real coverage path instead of only collect the IKs
global global_arm;
colortable = [90,146,173; 
    128,142,42; 
    101,191,101;
    238, 229, 248; 
    195, 100, 123; 
    146, 172, 209]/255;
color = colortable(unidrnd(size(colortable, 1)), :);

% collect all corrsponding vertex
all_IKs = [];
% all_indices = [];
for i = 1:size(our_ver, 1)
    if any(our_ver(i).color_ == colornum)
        n = size(all_IKs, 1);
        all_IKs(n+1, :) = our_ver(i).IK_(our_ver(i).color_ == colornum, :);
    end
end

if isempty(all_IKs)
    return ;
end

global_arm.plot(all_IKs, 'delay', 0.05);

