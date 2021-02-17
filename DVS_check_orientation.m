function check = DVS_check_orientation(v,event,neigh,sign)

    global im_v_pos
    global im_v_neg
    idx = floor(neigh/2);
    data = zeros(neigh*neigh,1);
    orient = atan2d(v(2),v(1))+180;
    k = 1;
    check = 0;
    if((event(3)> idx) && (event(3)<359-idx) && (event(2)>idx) && (event(2)<479-idx))
        for i =  -idx:idx
            for j = -idx:idx
                if (sign == 2)
                    if ((im_v_pos(event(3)+1+i,event(2)+1+j,1)~= 0) && (im_v_pos(event(3)+1+i,event(2)+1+j,2) ~= 0))
                        data(k) = atan2d(im_v_pos(event(3)+1+i,event(2)+1+j,2),im_v_pos(event(3)+1+i,event(2)+1+j,1)) + 180;
                        k = k+1;
                    end
                elseif (sign == 3)
                    if ((im_v_neg(event(3)+1+i,event(2)+1+j,1) ~= 0) && (im_v_neg(event(3)+1+i,event(2)+1+j,2) ~= 0))
                        data(k) = atan2d(im_v_neg(event(3)+1+i,event(2)+1+j,2),im_v_neg(event(3)+1+i,event(2)+1+j,1)) + 180;
                        k = k+1;
                    end              
                end
            end
        end
    end
    data(data==0) = [];
    if((isempty(data)~=1) && length(data)>=2)
        m = mean(data);
        s = std(data);
        if ((orient> m-s)&& (orient < m+s))
            check = 1;
        else
            check = 0;
        end
    else 
        check =1;
    end
end