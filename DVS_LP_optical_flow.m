function V =  DVS_LP_optical_flow(n,event,type,dt,neigh,sign)
    
    global im1;
    global row;
    global col;
    sxx = 0;
    syy = 0;
    stt = 0;
    sx2 = 0;
    sy2 = 0;
    st2 = 0;
    sxy = 0;
    sxt = 0;
    syt = 0;
    
    thr1=1e-5;
    thr2 = 0.005;
    thr3 = 1e-4;
    V = [0,0,0];
    if strcmp(type,'single fit')
        if (size(n.data,1)< 3)
            V(1) = 0;
            V(2) = 0;
            V(3) = 0;
            return
        else
            for i = 1:size(n.data,1)
                sxx = sxx + n.data(i,1);
                syy = syy + n.data(i,2);
                stt = stt + n.data(i,3);
                sx2 = sx2 + n.data(i,1)^2;
                sy2 = sy2 + n.data(i,2)^2;
                st2 = st2 + n.data(i,3)^2;
                sxy = sxy + n.data(i,1)*n.data(i,2);
                sxt = sxt + n.data(i,1)*n.data(i,3);
                syt = syt + n.data(i,2)*n.data(i,3); 
            end
            check = (sx2*sy2*st2) + (2*sxy*sxt*syt) - (sxt*sxt*sy2) - (sx2*syt*syt) - (sxy*sxy*st2);
            if (check ==0)
                V(1) = 0;
                V(2) = 0;
                V(3) = 0;
                return
            else
                gx = sxx*(syt*syt - sy2*st2) + syy*(sxy*st2 - sxt*syt) + stt*(sxt*sy2 - sxy*syt);
                gy = sxx*(sxy*st2 - syt*sxt) + syy*(sxt*sxt - sx2*st2) + stt*(syt*sx2 - sxy*sxt);
                gt = sxx*(sxt*sy2 - sxy*syt) + syy*(sx2*syt - sxy*sxt) + stt*(sxy*sxy - sx2*sy2);

                if (abs(gx)<thr3*10 || abs(gy)<thr3*10)
                    V(1) = 0;
                    V(2) = 0;
                    V(3) = 0;
                    return
                else
                    V(1) = -(gt*gx)/(gx^2 + gy^2);
                    V(2) = -(gt*gy)/(gx^2 + gy^2);
                    V(3) = sqrt(V(1)*V(1) + V(2)*V(2));
                end
            end
        end
        
    elseif strcmp(type,'iterated fit')
        if (size(n.data,1)< 4)
            V(1) = 0;
            V(2) = 0;
            V(3) = 0;
            return
        else
            A = n.data;
            [vec,~] = eig((A')*A);
            old_plane = vec(:,1);
            plane_estimate = old_plane;
            eps = 1e6;
            while(eps>thr1)
                change = false;
                i = 1;
                if (i<=size(n.data,1))
                    ch = abs((old_plane(1)*n.data(i,1)) + (old_plane(2)*n.data(i,2)) + (old_plane(2)*n.data(i,3)) + old_plane(4)*n.data(i,4));
                    if (ch>thr2)
                        n.data(i,:) = [];
                        change = true;
                        i = i-1;
                    end
                    i = i+1;
                end
                if (change == false)
                    eps = 0;
                elseif (size(n.data,1)> 3)
                    A = n.data;
                    [vec,~] = eig((A')*A);
                    plane_estimate = vec(:,1);
                    eps = sqrt((plane_estimate(1)-old_plane(1))^2 + (plane_estimate(2)-old_plane(2))^2 ...
                          + (plane_estimate(3)-old_plane(3))^2 + (plane_estimate(4)-old_plane(4))^2);
                    old_plane = plane_estimate;
                else
                    V(1) = 0;
                    V(2) = 0;
                    V(3) = 0;
                    return
                end
                if (abs(plane_estimate(1))<thr2 || abs(plane_estimate(1))<thr2)
                    V(1) = 0;
                    V(2) = 0;
                    V(3) = 0;
                    return
                else
                    V(1) = -plane_estimate(3)/plane_estimate(1);
                    V(2) = -plane_estimate(3)/plane_estimate(2);
                    V(3) = sqrt(V(1)^2+V(2)^2);
                end
            end
            
        end
        
    elseif strcmp(type, 'SG')
        a = zeros(2);
        idx = floor(neigh/2);
        if ((event(3)> idx) && (event(3)<row-idx) && (event(2)>idx) && (event(2)<col-idx))
            ii = 1;
            jj = 1;
            if ((isempty(im1(event(3)+1,event(2)+1,sign).time)~= 1))
                tc =  im1(event(3)+1,event(2)+1,sign).time(end);
            else
                tc = 1e20;
            end
            for i = -idx :idx
                for j = -idx:idx
                    if ((isempty(im1(event(3)+i+1,event(2)+j+1,sign).time)~= 1))
                        t1 =  im1(event(3)+i+1,event(2)+j+1,sign).time(end);
                        if ((tc - t1)<dt)
                            for iii = i+1:idx
                                if isempty(im1(event(3)+iii+1,event(2)+j+1,sign).time)~=1
                                    t2 = im1(event(3)+iii+1,event(2)+j+1,sign).time(end);
                                    if ((tc - t2)<dt)
                                        a(2,1) = a(2,1) + (t2-t1)/(iii-i);
                                        ii = ii+1;
                                    end
                                end
                            end
                            for jjj = j+1:idx
                                if isempty(im1(event(3)+i+1,event(2)+jjj+1,sign).time)~=1
                                    t2 = im1(event(3)+i+1,event(2)+jjj+1,sign).time(end);
                                    if ((tc - t2)<dt)
                                        a(1,2) = a(1,2) + (t2-t1)/(jjj-j);
                                    jj = jj+1;
                                    end
                                end
                            end
                        end

                    end

                end
            end
            if ((ii-1) == 0)
                a(2,1) = 0;
            else
                a(2,1) = 1e-6 * a(2,1)/(ii-1);
            end
            if ((jj-1) == 0)
                a(1,2) = 0;
            else
                a(1,2) = 1e-6 * a(1,2)/(jj-1);
            end
            if (abs(a(2,1))<thr3 && abs(a(2,1))<thr3)
                V(1) = 0;
                V(2) = 0;
                V(3) = 0;
                return
            else
                V(1) = a(2,1)/(a(2,1)^2 + a(1,2)^2)/5;
                V(2) = a(1,2)/(a(2,1)^2 + a(1,2)^2)/5;
                V(3) = sqrt(V(1)^2 + V(2)^2);
            end
        end
        
    else
        error('Unsupported type is chosen, supported types are "single fit", "iterated fit" and "SG"')
    end


end