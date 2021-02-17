function [V,l] = DVS_statistics(v,l)
    
    global trans_m;
    global trans_std;
    global speed_m;
    global speed_std;
    
    V = v;
    l =l+1;
    
%     v(1)
%     lower = speed_m - 2*speed_std;
%     upper = speed_m + 2*speed_std;
%     if ((v(3)>lower) && (v(3)<upper))
%         V = v;
%         l =l+1;
%     else
%         V = [];
%     end
%     d_vx = v(1) - trans_m(1);
%     d_vy = v(2) - trans_m(1);
%     d_v = v(3) - speed_m;
%     trans_m = trans_m + [d_vx/l, d_vy/l];
%     speed_m = speed_m + d_v/l;
%     trans_std = trans_std + [d_vx ,d_vy].*[v(1)-trans_m(1), v(2)-trans_m(2)];
%     speed_std = speed_std + d_v*(v(3)-speed_m)


end