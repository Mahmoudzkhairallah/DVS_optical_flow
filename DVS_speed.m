function  [V,Dir] = DVS_speed(event,neigh,sign,orient)

    global row;
    global col;
    global im1;
    global im2;
    V = [];
    idx = floor(neigh/2);
    if ((event(3)> idx) && (event(3)<row-idx) && (event(2)>idx) && (event(2)<col-idx))
        if (orient==1) % 90 or 270
            dir1 = im1(event(3)+1,event(2)+1,sign).time - im2(event(3),event(2)+1,sign).time; % 270
            dir2 = im1(event(3)+1,event(2)+1,sign).time - im2(event(3)+2,event(2)+1,sign).time; % 90
            if (dir1>dir2)
                Dir = 270;
                V = 1000000/dir2;
            else
                Dir = 90;
                V = 1000000/dir1;            
            end
        end

        if (orient==2) % 135 or 315
            dir1 = im1(event(3)+1,event(2)+1,sign).time - im2(event(3),event(2),sign).time; % 315
            dir2 = im1(event(3)+1,event(2)+1,sign).time - im2(event(3)+2,event(2)+2,sign).time; % 135
            if (dir1>dir2)
                Dir = 135;
                V = 1000000/dir2;
            else
                Dir = 315;
                V = 1000000/dir1;            
            end
        end

        if (orient==3) % 0 or 180
            dir1 = im1(event(3)+1,event(2)+1,sign).time - im2(event(3)+1,event(2),sign).time; % 0
            dir2 = im1(event(3)+1,event(2)+1,sign).time - im2(event(3)+1,event(2)+2,sign).time; % 180
            if (dir1>dir2)
                Dir = 180;
                V = 1000000/dir2;
            else
                Dir = 0;
                V = 1000000/dir1;            
            end
        end

        if (orient==4) % 45 or 225
            dir1 = im1(event(3)+1,event(2)+1,sign).time - im2(event(3),event(2)+2,sign).time; % 225
            dir2 = im1(event(3)+1,event(2)+1,sign).time - im2(event(3)+2,event(2),sign).time; % 45
            if (dir1>dir2)
                Dir = 45;
                V = 1000000/dir2;
            else
                Dir = 225;
                V = 1000000/dir1;            
            end
        end
    end
    







end