function  n = DVS_neighborhood(event,neigh,Sign,t0,dt)


    n = struct;
    n.data = [];
    global im1;
    global row ;
    global col;
    idx = floor(neigh/2);
    if ((event(3)> idx) && (event(3)<row-idx) && (event(2)>idx) && (event(2)<col-idx))
        if ((isempty(im1(event(3)+1,event(2)+1,Sign).time)~= 1))
            tc =  im1(event(3)+1,event(2)+1,Sign).time(end);
        else
            tc = 1e20;
        end
        ii = 1;
        for i = -idx:idx
            for j = -idx:idx
                if (isempty(im1(event(3)+i+1,event(2)+j+1,Sign).time)~= 1)
                    if(tc - im1(event(3)+i+1,event(2)+j+1,Sign).time(end))<dt
                        n.data(ii,:) = [event(3)+ i , event(2)+j ,(im1(event(3)+i+1,event(2)+j+1,Sign).time(end) - t0)*1e-6, 1];
                        ii = ii+1;
                    end
                end                
            end
        end
    end


end