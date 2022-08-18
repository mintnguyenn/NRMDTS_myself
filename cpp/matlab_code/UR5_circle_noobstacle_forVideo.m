function UR5_circle_noobstacle_forVideo(our_ver)

global global_ori_ver;
global global_ori_tri;

v = VideoWriter('circle_noobstacle.mp4', 'MPEG-4');
v.Quality = 95;
open(v);

h = figure(1);
for i = 101:2401
    hold off
    plot_mesh(global_ori_tri, global_ori_ver);
    axis([-0.2, 1.0, -0.6, 0.6, 0, 0.6]);
    view(-20, 20)
    hold on
    showUR5(our_ver(i).IK_);
    
    frame = getframe(h);
    writeVideo(v, frame);
    pause(0.1);
end


% for i = 1:size(F, 1)
%     frame = F(i, 1);
%     
% end

close(v);

end