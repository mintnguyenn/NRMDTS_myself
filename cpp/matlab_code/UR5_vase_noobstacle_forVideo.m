function UR5_vase_noobstacle_forVideo(our_ver)

global global_ori_ver;
global global_ori_tri;


v = VideoWriter('vase_noobstacle_1_left.mp4', 'MPEG-4');
w = VideoWriter('vase_noobstacle_1_right.mp4', 'MPEG-4');
v.Quality = 95;
w.Quality = 95;
open(v);
open(w);
pointlist = [52:73, 123:-1:102];
for i = 1:10
    l = [i*100+52:i*100+73, (i+1)*100+23:-1:(i+1)*100+2];
    pointlist = [pointlist, l];
end
pointlist = [pointlist, 1152:1173];
    
h = figure(1);
for i = 1:size(pointlist, 2)
    i
    p = pointlist(i);
    hold off
    plot_mesh(global_ori_tri, global_ori_ver);
    hold on
    b = find(our_ver(p).color_ == 1);
    showUR5(our_ver(p).IK_(b, :));
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

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
v = VideoWriter('vase_noobstacle_2_left.mp4', 'MPEG-4');
w = VideoWriter('vase_noobstacle_2_right.mp4', 'MPEG-4');
v.Quality = 95;
w.Quality = 95;
open(v);
open(w);
pointlist = [74:99, 149:-1:124];
for i = 1:10
    l = [i*100+74:i*100+99, (i+1)*100+49:-1:(i+1)*100+24];
    pointlist = [pointlist, l];
end
pointlist = [pointlist, 1174:1199];
    
h = figure(1);
for i = 1:size(pointlist, 2)
    i
    p = pointlist(i);
    hold off
    plot_mesh(global_ori_tri, global_ori_ver);
    hold on
    b = find(our_ver(p).color_ == 2);
    showUR5(our_ver(p).IK_(b, :));
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