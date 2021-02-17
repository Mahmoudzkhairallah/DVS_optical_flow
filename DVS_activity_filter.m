function [Flag,T] = DVS_activity_filter(event,events_packet,frequency,Tmax,Tmin)
    
    global im1; 
    global im2;
%     global prev_t;
%     Flag = 0;
%     T = DVS_activity_time(frequency,events_packet,Tmax,Tmin);
%     T = 1000;
%     T_fra = 000;
%     if ((event(3)> 0) && (event(3)<359) && (event(2)>0) && (event(2)<479))
%         last = prev_t(event(3)+1,event(2)+1);
%         current = event(1);
%         if (((current-last)<T) || (last==0))
%             if ((current-last)>T_fra)
%                 Flag = 1;
%                 prev_t(event(3),event(2)) = current;
%                 prev_t(event(3),event(2)+1) = current;
%                 prev_t(event(3),event(2)+2) = current;
%                 prev_t(event(3)+1,event(2)) = current;
%                 prev_t(event(3)+1,event(2)+2) = current;
%                 prev_t(event(3)+2,event(2)) = current;
%                 prev_t(event(3)+2,event(2)+1) = current;
%                 prev_t(event(3)+2,event(2)+2) = current;
%             end
%         end
%     end
%     Flag = 1;
    
    
    im2(event(3)+1,event(2)+1,1).time = im1(event(3)+1,event(2)+1,1).time;
    im1(event(3)+1,event(2)+1,1).time = event(1);
    portion = 0;
    T = DVS_activity_time(frequency,events_packet,Tmax,Tmin);
    T = 70000;
    if ((event(3)> 0) && (event(3)<359) && (event(2)>0) && (event(2)<479))
%         portion = [(im1(event(3)+1,event(2)+1,1).time - im2(event(3)+1,event(2)+1,1).time)<(T) && (im1(event(3)+1,event(2)+1,1).time - im2(event(3)+1,event(2)+1,1).time)>T_fra   ;...
%                    (im1(event(3)+1,event(2)+1,1).time - im2(event(3),event(2)+1,1).time)<(T) && (im1(event(3)+1,event(2)+1,1).time - im2(event(3),event(2)+1,1).time)>T_fra;...
%                    (im1(event(3)+1,event(2)+1,1).time - im2(event(3)+2,event(2)+1,1).time)<(T) && (im1(event(3)+1,event(2)+1,1).time - im2(event(3)+2,event(2)+1,1).time)>T_fra;...
%                    (im1(event(3)+1,event(2)+1,1).time - im2(event(3)+1,event(2),1).time)<(T) && (im1(event(3)+1,event(2)+1,1).time - im2(event(3)+1,event(2),1).time)>T_fra;...
%                    (im1(event(3)+1,event(2)+1,1).time - im2(event(3)+1,event(2)+2,1).time)<(T) && (im1(event(3)+1,event(2)+1,1).time - im2(event(3)+1,event(2)+2,1).time)>T_fra;...
%                    (im1(event(3)+1,event(2)+1,1).time - im2(event(3),event(2),1).time)<(T) && (im1(event(3)+1,event(2)+1,1).time - im2(event(3),event(2),1).time)>T_fra;...
%                    (im1(event(3)+1,event(2)+1,1).time - im2(event(3)+2,event(2)+2,1).time)<(T) && (im1(event(3)+1,event(2)+1,1).time - im2(event(3)+2,event(2)+2,1).time)>T_fra;...
%                    (im1(event(3)+1,event(2)+1,1).time - im2(event(3),event(2)+2,1).time)<(T) && (im1(event(3)+1,event(2)+1,1).time - im2(event(3),event(2)+2,1).time)>T_fra;...
%                    (im1(event(3)+1,event(2)+1,1).time - im2(event(3)+2,event(2),1).time)<(T) && (im1(event(3)+1,event(2)+1,1).time - im2(event(3)+2,event(2),1).time)>T_fra];
        portion = [(im1(event(3)+1,event(2)+1,1).time - im2(event(3)+1,event(2)+1,1).time)<(T);...
                   (im1(event(3)+1,event(2)+1,1).time - im2(event(3),event(2)+1,1).time)<(T);...
                   (im1(event(3)+1,event(2)+1,1).time - im2(event(3)+2,event(2)+1,1).time)<(T);...
                   (im1(event(3)+1,event(2)+1,1).time - im2(event(3)+1,event(2),1).time)<(T);...
                   (im1(event(3)+1,event(2)+1,1).time - im2(event(3)+1,event(2)+2,1).time)<(T);...
                   (im1(event(3)+1,event(2)+1,1).time - im2(event(3),event(2),1).time)<(T);...
                   (im1(event(3)+1,event(2)+1,1).time - im2(event(3)+2,event(2)+2,1).time)<(T);...
                   (im1(event(3)+1,event(2)+1,1).time - im2(event(3),event(2)+2,1).time)<(T);...
                   (im1(event(3)+1,event(2)+1,1).time - im2(event(3)+2,event(2),1).time)<(T)];    
    end
    count = sum(portion);
    if (count >= 1)
        Flag = 1;
    else
        Flag = 0;
    end
    

end