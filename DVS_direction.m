function dir = DVS_direction(event,neigh,sign)
    global row;
    global col;
    global im1;
    global im2;
    idx = floor(neigh/2);
    dir = [];
    if ((event(3)> idx) && (event(3)<row-idx) && (event(2)>idx) && (event(2)<col-idx))
        
            angle(1) = (1/5)*((im1(event(3)+1,event(2)+1,sign).time - im2(event(3)+1,event(2)-1,sign).time) +...
                              (im1(event(3)+1,event(2)+1,sign).time - im2(event(3)+1,event(2),sign).time) + ...
                              (im1(event(3)+1,event(2)+1,sign).time - im2(event(3)+1,event(2)+1,sign).time) +...
                              (im1(event(3)+1,event(2)+1,sign).time - im2(event(3)+1,event(2)+2,sign).time) + ...
                              (im1(event(3)+1,event(2)+1,sign).time - im2(event(3)+1,event(2)+3,sign).time)); % 0

            angle(2) = (1/5)*((im1(event(3)+1,event(2)+1,sign).time - im2(event(3)-1,event(2)+3,sign).time) +...
                              (im1(event(3)+1,event(2)+1,sign).time - im2(event(3),event(2)+2,sign).time) + ...
                              (im1(event(3)+1,event(2)+1,sign).time - im2(event(3)+1,event(2)+1,sign).time) +...
                              (im1(event(3)+1,event(2)+1,sign).time - im2(event(3)+2,event(2),sign).time) +...
                              (im1(event(3)+1,event(2)+1,sign).time - im2(event(3)+3,event(2)-1,sign).time)); % 45

            angle(3) = (1/5)*((im1(event(3)+1,event(2)+1,sign).time - im2(event(3),event(2)+1,sign).time) +...
                              (im1(event(3)+1,event(2)+1,sign).time - im2(event(3),event(2)+1,sign).time) +...
                              (im1(event(3)+1,event(2)+1,sign).time - im2(event(3)+1,event(2)+1,sign).time) +...
                              (im1(event(3)+1,event(2)+1,sign).time - im2(event(3)+2,event(2)+1,sign).time) +...
                              (im1(event(3)+1,event(2)+1,sign).time - im2(event(3)+3,event(2)+1,sign).time)); %90

            angle(4) = (1/5)*((im1(event(3)+1,event(2)+1,sign).time - im2(event(3)-1,event(2)-1,sign).time) +...
                              (im1(event(3)+1,event(2)+1,sign).time - im2(event(3),event(2),sign).time) +...
                              (im1(event(3)+1,event(2)+1,sign).time - im2(event(3)+1,event(2)+1,sign).time) +...
                              (im1(event(3)+1,event(2)+1,sign).time - im2(event(3)+2,event(2)+2,sign).time) +...
                              (im1(event(3)+1,event(2)+1,sign).time - im2(event(3)+3,event(2)+3,sign).time));
            dir = find(angle == min(angle),1);
    end

end
                      