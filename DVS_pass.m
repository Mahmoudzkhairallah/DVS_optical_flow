function flag =  DVS_pass(event,v,sign,neigh)

    global im_v_pos;
    global im_v_neg;
    global row;
    global col;
    idx = 3;
    flag = 1;
    if ((event(3)> idx) && (event(3)<row-idx) && (event(2)>idx) && (event(2)<col-idx))
        if (sign==2)
            data = reshape(im_v_pos(event(3)-idx+1:event(3)+idx+1,event(2)-idx+1:event(2)+idx+1,:),49,3);
            data(data(:,3)==0) =[];
            if(isempty(data)~=1)
                meanv = mean(data(:,3));
                stdv = std(data(:,3));
                lowerv = meanv - 0.5*stdv;
                upperv = meanv + 0.5*stdv;
                dir = atan2d(data(:,2),data(:,1))+180; 
                meandir = mean(dir);
                stddir = std(dir);
                lowerdir = meandir - 0.5*stddir;
                upperdir = meandir + 0.5*stddir;
            else
                flag = 1;
                return
            end
            if (v(3)<lowerv || v(3)>upperv ||atan2d(v(2),v(1))+180<lowerdir ||atan2d(v(2),v(1))+180>upperdir)
                flag = 0;
                return;
            end


        elseif(sign ==3)
            data = reshape(im_v_neg(event(3)-idx+1:event(3)+idx+1,event(2)-idx+1:event(2)+idx+1,:),neigh^2,3);
            data(data(:,3)==0) =[];
            if(isempty(data)~=1)
                meanv = mean(data(:,3));
                stdv = std(data(:,3));
                lowerv = meanv - 0.5*stdv;
                upperv = meanv + 0.5*stdv;
                dir = atan2d(data(:,2),data(:,1))+180; 
                meandir = mean(dir);
                stddir = std(dir);
                lowerdir = meandir - 0.5*stddir;
                upperdir = meandir + 0.5*stddir;
            else
                flag = 1;
                return
            end
            if (v(3)<lowerv || v(3)>upperv ||atan2d(v(2),v(1))+180<lowerdir ||atan2d(v(2),v(1))+180>upperdir)
                flag = 0;
                return
            end
        end
    else
        flag = 0;
        return
    end







end