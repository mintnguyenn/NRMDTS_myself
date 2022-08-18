function UR5_vase_withobstacle_forVideo(our_ver, object1, object2)

global global_ori_ver;
global global_ori_tri;

% 
% v = VideoWriter('vase_withobstacle_1_left.mp4', 'MPEG-4');
% w = VideoWriter('vase_withobstacle_1_right.mp4', 'MPEG-4');
% v.Quality = 95;
% w.Quality = 95;
% open(v);
% open(w);
% pointlist = [63:66, 116:-1:112, 161:166, 216:-1:211, 260:266, 316:-1:309, ...
%     358:366, 416:-1:407, 455:466, 516:-1:505, 554:566, 616:-1:604, 652:666, ...
%     716:-1:702, 752:766, 816:-1:802, 852:866, 916:-1:902, 952:966, ...
%     1016:-1:1002, 1052:1066, 1116:-1:1102, 1152:1166];
%     
% h = figure(1);
% for i = 1:size(pointlist, 2)
%     i
%     p = pointlist(i);
%     hold off
%     plot_mesh(global_ori_tri, global_ori_ver);
%     hold on
%     b = find(our_ver(p).color_ == 1);
%     showUR5(our_ver(p).IK_(b, :));
%     object1.show
%     object2.show
%     
%     axis([-0.2, 1.0, -0.6, 0.6, 0, 0.6]);
%     view(200, 20)    
%     frame = getframe(h);
%     writeVideo(v, frame);
%     view(-20, 20);
%     frame = getframe(h);
%     writeVideo(w, frame);
% end
% close(v);
% close(w);
% 
% 
% v = VideoWriter('vase_withobstacle_3_left.mp4', 'MPEG-4');
% w = VideoWriter('vase_withobstacle_3_right.mp4', 'MPEG-4');
% v.Quality = 95;
% w.Quality = 95;
% open(v);
% open(w);
% pointlist = [888:899, 949:-1:938, 988:999, 1049:-1:1038, 1088:1099, 1149:-1:1138, 1188:1199];
%     
% h = figure(1);
% for i = 1:size(pointlist, 2)
%     i
%     p = pointlist(i);
%     hold off
%     plot_mesh(global_ori_tri, global_ori_ver);
%     hold on
%     b = find(our_ver(p).color_ == 4);
%     showUR5(our_ver(p).IK_(b, :));
%         object1.show
%     object2.show
% 
%     axis([-0.2, 1.0, -0.6, 0.6, 0, 0.6]);
%     view(200, 20)    
%     frame = getframe(h);
%     writeVideo(v, frame);
%     view(-20, 20);
%     frame = getframe(h);
%     writeVideo(w, frame);
% end
% close(v);
% close(w);
% 


v = VideoWriter('vase_withobstacle_2_left.mp4', 'MPEG-4');
w = VideoWriter('vase_withobstacle_2_right.mp4', 'MPEG-4');
v.Quality = 95;
w.Quality = 95;
open(v);
open(w);
pointlist = [];
for i = 0:7
    l = [i*100+67:i*100+99, (i+1)*100+49:-1:(i+1)*100+17];
    pointlist = [pointlist, l];
end
pointlist = [pointlist, 867:887, 937:-1:917, 967:987, ...
    1037:-1:1017, 1067:1087, 1137:-1:1117, 1167:1187];

    
h = figure(1);
for i = 1:size(pointlist, 2)
    i
    p = pointlist(i);
    hold off
    plot_mesh(global_ori_tri, global_ori_ver);
    hold on
    b = find(our_ver(p).color_ == 2);
    showUR5(our_ver(p).IK_(b, :));
        object1.show
    object2.show

    axis([-0.2, 1.0, -0.6, 0.6, 0, 0.6]);
    view(200, 20)    
    frame = getframe(h);
    writeVideo(v, frame);
    view(-20, 20);
    frame = getframe(h);
    writeVideo(w, frame);
end
close(v);
close(w);





end