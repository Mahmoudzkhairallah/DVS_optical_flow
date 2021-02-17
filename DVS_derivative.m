function [spatial_x,spatial_y,temporal]= DVS_derivative(event,type,neigh,dt,sign,C,a,order) 
    
    global im1; 
    global row ;
    global col;
    spatial_x = zeros(neigh);
    spatial_y = zeros(neigh);
    temporal = zeros(neigh);
    idx = floor(neigh/2);
    if strcmp(type,'backward')
        padding = 1;
        if ((event(3)> idx+ padding) && (event(3)<row-idx-padding) && (event(2)>idx+padding) && (event(2)<col-idx-padding))
            for ii = -idx:idx
                for jj = -idx:idx
                    if isempty(im1(event(3)+1+ii,event(2)+1+jj,sign).time)~= 1
                        x = length(im1(event(3)+1+ii,event(2)+1+jj,sign).time(event(1) - im1(event(3)+1+ii,event(2)+1+jj,sign).time < dt));
                        y = x; %supposedly we should use the same line above but since they are equal I try to minimize the usage of functions to reduce calculation time
                        t = x;
                        t2 = length(im1(event(3)+1+ii,event(2)+1+jj,sign).time(event(1) - im1(event(3)+1+ii,event(2)+1+jj,sign).time < (2*dt)));
                    else
                        x = 0; 
                        y = 0;
                        t = 0;
                        t2 = 0;
                    end
                    if isempty(im1(event(3)+1+ii,event(2)+jj,sign).time)~= 1
                        x_1 = length(im1(event(3)+1+ii,event(2)+jj,sign).time(event(1) - im1(event(3)+1+ii,event(2)+jj,sign).time < dt));
                    else
                        x_1= 0; 
                    end
                    if isempty(im1(event(3)+ii,event(2)+1+jj,sign).time)~= 1
                        y_1 = length(im1(event(3)+ii,event(2)+1+jj,sign).time(event(1) - im1(event(3)+ii,event(2)+1+jj,sign).time < dt));
                    else
                        y_1= 0; 
                    end
                        spatial_x(ii+idx+1,jj+idx+1) = x - x_1;
                        spatial_y(ii+idx+1,jj+idx+1) = y - y_1;
                        temporal(ii+idx+1,jj+idx+1) = 2*t - 2*t2;
                        temporal(ii+idx+1,jj+idx+1) = temporal(ii+idx+1,jj+idx+1) /(dt*1e-6);

                end
            end
        end
    end
    if strcmp(type,'central')
        padding = 1;
        if ((event(3)> idx+ padding) && (event(3)<row-idx-padding) && (event(2)>idx+padding) && (event(2)<col-idx-padding))
            for ii = -idx:idx
                for jj = -idx:idx
                    
                    if isempty(im1(event(3)+1+ii,event(2)+2+jj,sign).time)~= 1
                        xp1 = length(im1(event(3)+1+ii,event(2)+2+jj,sign).time(event(1) - im1(event(3)+1+ii,event(2)+2+jj,sign).time < dt));
                    else
                        xp1 = 0; 
                    end
                    if isempty(im1(event(3)+1+ii,event(2)+jj,sign).time)~= 1
                        xm1 = length(im1(event(3)+1+ii,event(2)+jj,sign).time(event(1) - im1(event(3)+1+ii,event(2)+jj,sign).time < dt));
                    else
                        xm1= 0; 
                    end
                    if isempty(im1(event(3)+2+ii,event(2)+1+jj,sign).time)~= 1
                        yp1 = length(im1(event(3)+2+ii,event(2)+1+jj,sign).time(event(1) - im1(event(3)+2+ii,event(2)+1+jj,sign).time < dt));
                    else
                        yp1= 0; 
                    end
                    if isempty(im1(event(3)+ii,event(2)+1+jj,sign).time)~= 1
                        ym1 = length(im1(event(3)+ii,event(2)+1+jj,sign).time(event(1) - im1(event(3)+ii,event(2)+1+jj,sign).time < dt));
                    else
                        ym1= 0; 
                    end
                    if isempty(im1(event(3)+1+ii,event(2)+1+jj,sign).time)~= 1
                        t = length(im1(event(3)+1+ii,event(2)+1+jj,sign).time(event(1) - im1(event(3)+1+ii,event(2)+1+jj,sign).time < dt));
                        t2 = length(im1(event(3)+1+ii,event(2)+1+jj,sign).time(event(1) - im1(event(3)+1+ii,event(2)+1+jj,sign).time < (2*dt)));

                    else
                        t = 0;
                        t2 = 0;
                    end
                        spatial_x(ii+idx+1,jj+idx+1) = (xp1 - xm1);
                        spatial_y(ii+idx+1,jj+idx+1) = (yp1 - ym1);
                        temporal(ii+idx+1,jj+idx+1) = 2*t - 2*t2;
                        temporal(ii+idx+1,jj+idx+1) = temporal(ii+idx+1,jj+idx+1) /(dt*1e-6);

                end
            end
        end
    end
    if strcmp(type,'SG')
        padding = 0;
        if ((event(3)> idx+ padding) && (event(3)<row-idx-padding) && (event(2)>idx+padding) && (event(2)<col-idx-padding))
            jj= 1;
            if order == 1
                for i = -idx:idx
                    for j = -idx:idx
                        if isempty(im1(event(3)+1+i,event(2)+1+j,sign).time)~= 1
                            a(1,2) = a(1,2) + (C(3,jj)*length(im1(event(3)+1+i,event(2)+1+j,sign).time(event(1) - im1(event(3)+1+i,event(2)+1+j,sign).time < dt)));
                            a(2,1) = a(2,1) + (C(2,jj)*length(im1(event(3)+1+i,event(2)+1+j,sign).time(event(1) - im1(event(3)+1+i,event(2)+1+j,sign).time < dt)));
                        end
                        jj = jj+1;
                    end
                end
                for i = -idx:idx
                    for j = -idx:idx
                        spatial_x(i+idx+1,j+idx+1) = a(2,1);
                        spatial_y(i+idx+1,j+idx+1) = a(1,2);
                        if isempty(im1(event(3)+1+i,event(2)+1+j,sign).time)~= 1
                            temporal(i+idx+1,j+idx+1) = 2 * length(im1(event(3)+1+i,event(2)+1+j,sign).time(event(1) - im1(event(3)+1+i,event(2)+1+j,sign).time < dt))...
                                                        - length(im1(event(3)+1+i,event(2)+1+j,sign).time(event(1) - im1(event(3)+1+i,event(2)+1+j,sign).time < (2*dt)));
                            temporal(i+idx+1,j+idx+1) = temporal(i+idx+1,j+idx+1) /(idx*dt*1e-6)/5;
                        else
                            temporal(i+idx+1,j+idx+1) = 0;
                            
                        end
                    end
                end
            else
                iii = 1;
                jjj = 1;
                for j = 0:order
                    for i = 0: order - j
                        a(i+1,j+1) = 0;
                        for jj = -idx:idx
                            for ii = -idx:idx
                                if isempty(im1(event(3)+1+ii,event(2)+1+jj,sign).time)~= 1
                                    a(i+1,j+1) = a(i+1,j+1) + (C(iii,jjj)*length(im1(event(3)+1+ii,event(2)+1+jj,sign).time(event(1) - im1(event(3)+1+ii,event(2)+1+jj,sign).time < dt)));
                                end
                                jjj = jjj + 1;
                            end
                        end
                        iii = iii + 1;
                        jjj =1;
                    end
                end
                for jjj = -idx:idx
                    for iii = -idx:idx
                        spatial_x(iii+idx+1,jjj+idx+1) = 0;
                        spatial_y(iii+idx+1,jjj+idx+1) = 0;
                        for j = 0:order
                            for i = 1:order - j
                                spatial_x(iii+idx+1,jjj+idx+1) = spatial_x(iii+idx+1,jjj+idx+1) + (i*a(i+1,j+1)*(iii^(i-1))*(jjj^j));
                            end
                        end
                        for j = 1:order
                            for i = 1:order - j
                                spatial_y(iii+idx+1,jjj+idx+1) = spatial_x(iii+idx+1,jjj+idx+1) + (j*a(i+1,j+1)*(iii^i)*(jjj^(j-1)));
                            end
                        end
                        if isempty(im1(event(3)+1+iii,event(2)+1+jjj,sign).time)~= 1
                            temporal(iii+idx+1,jjj+idx+1) = 2 * length(im1(event(3)+1+iii,event(2)+1+jjj,sign).time(event(1) - im1(event(3)+1+iii,event(2)+1+jjj,sign).time < dt))...
                                                        - length(im1(event(3)+1+iii,event(2)+1+jjj,sign).time(event(1) - im1(event(3)+1+iii,event(2)+1+jjj,sign).time < (2*dt)));
                            temporal(iii+idx+1,jjj+idx+1) = temporal(iii+idx+1,jjj+idx+1) /(idx*dt*1e-6)/20;
                        else
                            temporal(iii+idx+1,jjj+idx+1) = 0;
                            
                        end

                    end
                end
                
            end
        end
    end
    if ~(strcmp(type,'central') || strcmp(type,'backward') || strcmp(type,'SG'))
        error('this type is not supported')
    end
    
end
