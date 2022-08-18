function UR5_circle_withobstacle_forVideo(our_ver, object)

global global_ori_ver;
global global_ori_tri;

% v = VideoWriter('circle_withobstacle_1_left.mp4', 'MPEG-4');
% v.Quality = 95;
% open(v);
% pointlist = [171:200,101:120, ...
%     220:-1:201, 300:-1:271, ...
%     371:400, 301:320];
% for i = 4:2:23
%     l1 = [i*100+20:-1:i*100+1, (i+1)*100:-1:i*100+71];
%     l2 = [(i+1)*100+71:(i+2)*100, (i+1)*100+1:(i+1)*100+20];
%     pointlist = [pointlist, l1, l2];
% end
%     
%     
% h = figure(1);
% for i = 1:size(pointlist, 2)
%     i
%     p = pointlist(i);
%     hold off
%     plot_mesh(global_ori_tri, global_ori_ver);
%     axis([-0.2, 1.0, -0.6, 0.6, 0, 0.6]);
%     view(200, 20)
%     hold on
%     b = find(our_ver(p).color_ == 1);
%     object.show
%     showUR5(our_ver(p).IK_(b, :));
%     
%     frame = getframe(h);
%     writeVideo(v, frame);
%     pause(0.05);
% end
% close(v);

v = VideoWriter('circle_withobstacle_2_right.mp4', 'MPEG-4');
v.Quality = 95;
open(v);
pointlist = [121:170, 270:-1:221, ...
    321:370, 470:-1:421];
for i = 5:2:21
    l1 = [i*100+21:i*100+70, (i+1)*100+70:-1:(i+1)*100+21];
    pointlist = [pointlist, l1];
end
pointlist = [pointlist, 2321:2370];
    
    
h = figure(1);
for i = 1:size(pointlist, 2)
    i
    p = pointlist(i);
    hold off
    plot_mesh(global_ori_tri, global_ori_ver);
    axis([-0.2, 1.0, -0.6, 0.6, 0, 0.6]);
    view(-20, 20)
    hold on
    b = find(our_ver(p).color_ == 2);
    object.show
    showUR5(our_ver(p).IK_(b, :));
    
    frame = getframe(h);
    writeVideo(v, frame);
%     pause(0.05);
end
close(v);

end