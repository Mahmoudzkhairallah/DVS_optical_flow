clc; clear all; close all
global im1;
global im2;
global im_v_pos;
global im_v_neg;
global prev_t;
load cropped_tv2.mat
load colorcode.mat
colorcode = imresize(rgbImage1,0.2);
cropped = [cropped(:,3),cropped(:,1),cropped(:,2),cropped(:,4)];
data = cropped;
data = data(data(:,1)<1500000,:);
% data = importdata('Events_dat_to_txt3.txt');
pos = data(data(:,4) == 1,1:3);
neg = data(data(:,4) == 0,1:3);
% images to save consequent events for the activity filter
global row ;
global col;
row = 360;
col = 480;
origin = [col/2, row/2];
prev_t = zeros(row,col);
im1 = struct;
im2 = struct;
for i =1:row
    for j =1:col
        im1(i,j,1).time = 0;
        im2(i,j,1).time = 0;
        im1(i,j,2).time = 0;
        im2(i,j,2).time = 0;
        im1(i,j,3).time = 0;
        im2(i,j,3).time = 0;
    end
end
im_v_pos = zeros(row,col,3);
im_v_neg = zeros(row,col,3);
histpos = zeros(row,col);
histneg = zeros(row,col);
im = 0.5*ones(row,col,3);
cleanpos = zeros(size(pos,1),6);
cleanneg = zeros(size(neg,1),6);
filteredpos = zeros(size(pos,1),6);
filteredneg = zeros(size(neg,1),6);
count = 0;
Tmax = 100000;
Tmin = 1000;
neigh = 5;
dt = 15000;
spatial = zeros(neigh,neigh,2);
temporal = zeros(neigh,neigh);

% calculating the event rates
j = 1;
k = 1;
l = 1;
m = 1;
t0 = data(1,1);
Nsamples = 10;
Fsamples = 5000;
type = 'SG';
order = 1;
[C,a]= DVS_SG_parameters(neigh,order);
h = 1;
for i = 1:size(data,1)- Nsamples
    event = data(i,:);
    events_packet = data(i:i+Nsamples,1);
    flag = DVS_activity_filter(event,events_packet,Nsamples,Tmax,Tmin);

    if (flag == 1)
        if (event(4) == 1)
            if (j>Fsamples)
                v_pos = cleanpos(j-Fsamples:j-1,6);
                M_v_pos = mean(v_pos);
                V_v_pos = std(v_pos);
            end
            sign = 2; % which layer of im1 to bee treated
            im1(event(3)+1,event(2)+1,2).time = [im1(event(3)+1,event(2)+1,2).time ; event(1)];
            im(event(3)+1,event(2)+1,:) = [255,255,255];
            n = DVS_neighborhood(event,neigh,sign,t0,dt);
            v =  DVS_LP_optical_flow(n,event,type,dt,neigh,sign);
           
            if (isempty(v) ~= 1)
                cleanpos(j,:) = [event(1:3), v(1), v(2), v(3)];
                j= j+1;
                check = DVS_check_orientation(v,event,5,sign);
                if(j>Fsamples+1)
                    if ((v(3) > M_v_pos-V_v_pos) && (v(3) < M_v_pos+V_v_pos) && check)
                        filteredpos(l,:) = [event(1:3), v(1), v(2), v(3)];
                        im_v_pos(event(3)+1,event(2)+1,:) = [v(1), v(2), v(3)];
                        l = l+1;
                    end
                end
            end
        else
            if (k>Fsamples)
                v_neg = cleanneg(k-Fsamples:k-1,6);
                M_v_neg = mean(v_neg);
                V_v_neg = std(v_neg);
            end
            sign = 3;
            im1(event(3)+1,event(2)+1,3).time = [im1(event(3)+1,event(2)+1,3).time ; event(1)];
            im(event(3)+1,event(2)+1,:) = [0,0,0];
            tic;
            n = DVS_neighborhood(event,neigh,sign,t0,dt);
            v =  DVS_LP_optical_flow(n,event,type,dt,neigh,sign);
            sec(h) = toc;
            h = h+1;
            if(isempty(v) ~= 1)
                cleanneg(k,:) = [event(1:3), v(1), v(2), v(3)];
                k = k+1;
                check = DVS_check_orientation(v,event,5,sign);
                if (k>Fsamples+1)
                    if ((v(3) > M_v_neg-V_v_neg) && (v(3) < M_v_neg+V_v_neg) && check)
                        filteredneg(m,:) = [event(1:3), v(1), v(2), v(3)];
                        im_v_neg(event(3)+1,event(2)+1,:) = [v(1), v(2), v(3)];
                        m = m+1;
                    end
                end
            end
        end 
    end
       
    if rem(i,10000)==0
        i
        img1 = im;
        img2 = flow_visualization(im_v_pos(:,:,2)+im_v_neg(:,:,2),im_v_pos(:,:,1)+im_v_neg(:,:,1));
        img2(1:size(colorcode,1),end-size(colorcode,2)+1:end,:) = colorcode;
        im = [img1,zeros(360,3,3),img2];
        imshow(im,'InitialMagnification',200)
        hold on
        quiver(im_v_pos(:,:,2),im_v_pos(:,:,1),15,'Color','r')
        quiver(im_v_neg(:,:,2),im_v_neg(:,:,1),15,'Color','b')
        drawnow
        clf('reset')
        im = 128*ones(row,col,3);
        im_v_pos = zeros(row,col,3);
        im_v_neg = zeros(row,col,3);
        
%         img1 = im;
%         img2 = flow_visualization(im_v_pos(:,:,2)+im_v_neg(:,:,2),im_v_pos(:,:,1)+im_v_neg(:,:,1));
%         img2(1:size(colorcode,1),end-size(colorcode,2)+1:end,:) = colorcode;
%         im = [img1,zeros(360,3,3),img2];
%         imshow(img1,'InitialMagnification',200)
%         hold on
%         quiver(im_v_pos(:,:,2),im_v_pos(:,:,1),15,'Color','r')
%         quiver(im_v_neg(:,:,2),im_v_neg(:,:,1),15,'Color','b')
%         drawnow
%         im = 128*ones(row,col,3);
%         im_v_pos = zeros(row,col,3);
%         im_v_neg = zeros(row,col,3);
%         imshow(im,'InitialMagnification',1000)
%         hold on 
%         quiver(im_v_pos(:,:,2),im_v_pos(:,:,1),15,'Color','r')
%         quiver(im_v_neg(:,:,2),im_v_neg(:,:,1),15,'Color','b')
%         drawnow
%         clf('reset')
%         disp(i)
%         im_v_pos = zeros(row,col,3);
%         im_v_neg = zeros(row,col,3);
%         im = 0.5*ones(row,col,3);
    end
    if (rem(i,20000)==0)
        prev_t = zeros(row,col);
    end
end

% close(vid)
filteredpos(filteredpos(:,1)==0,:) = [];
filteredneg(filteredneg(:,1)==0,:) = [];
single_LP = [filteredpos;filteredneg];

