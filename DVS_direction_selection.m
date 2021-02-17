clc; clear all; close all
load cropped_tv2.mat

load colorcode
addpath('correspondenceVisualization/matlab/hci')
cropped = [cropped(:,3),cropped(:,1),cropped(:,2),cropped(:,4)];
data = cropped;
colorcode = imresize(rgbImage1,0.2);
data = data(data(:,1)<1500000,:);
% data = importdata('Events_dat_to_txt3.txt');
% data = data(1:450000,:);
pos = data(data(:,4) == 1,1:3);
neg = data(data(:,4) == 0,1:3);
global im1;
global im2;
global prev_t;
% images to save consequent events for the activity filter
im1pos = zeros(max(data(:,3))+1,max(data(:,2))+1);
im2pos = zeros(max(data(:,3))+1,max(data(:,2))+1);
im1neg = zeros(max(data(:,3))+1,max(data(:,2))+1);
im2neg = zeros(max(data(:,3))+1,max(data(:,2))+1);
count = 0;
Tmax = 30000;
Tmin = 100;
global row ;
global col;
row = 360;
col = 480;
im1 = struct;
im2 = struct;
prev_t = zeros(row,col);
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

histpos = zeros(row,col);
histneg = zeros(row,col);
im_v_pos = zeros(row,col,4);
im_v_neg = zeros(row,col,4);
im = 128*ones(row,col,3);
cleanpos = zeros(size(pos,1),5);
cleanneg = zeros(size(neg,1),5);
filteredpos = zeros(size(pos,1),5);
filteredneg = zeros(size(neg,1),5);
origin = [col/2, row/2];
neigh = 5;
j = 1;
k = 1;
l = 1;
m = 1;
% vid = VideoWriter('direction selective.mp4','MPEG-4');
% vid.FrameRate = 75;
% open(vid);
total_t = 0;
Nsamples = 10;
Fsamples = 1000;
h = 1;
for i = 1:size(data,1)- Nsamples
    tic
    event = data(i,:);
    events_packet = data(i:i+Nsamples,1);
    flag = DVS_activity_filter(event,events_packet,Nsamples,Tmax,Tmin);
    if (flag == 1)
        if (event(4) == 1)
            if (j>Fsamples)
                v_pos = cleanpos(j-Fsamples:j-1,4);
                M_v_pos = mean(v_pos);
                V_v_pos = std(v_pos);
            end
            sign = 2; % which layer of im1 to bee treated
            im2(event(3)+1,event(2)+1,sign).time = im1(event(3)+1,event(2)+1,sign).time;
            im1(event(3)+1,event(2)+1,sign).time = event(1);
            im(event(3)+1,event(2)+1,:) = [255,255,255];
            tic;
            dir = DVS_direction(event,neigh,sign);
            if isempty(dir)
                v = [];
            else
                [v,Dir] = DVS_speed(event,neigh,sign,dir);
                sec(h) = toc;
                h = h+1;
            end
            if (isempty(v) ~= 1)
                cleanpos(j,:) = [event(1:3), v, Dir];
                j = j+1;
                if (j>Fsamples+1)
                    if ((v > M_v_pos-1.5*V_v_pos) && (v < M_v_pos+1.5*V_v_pos))
                        filteredpos(l,:) = [event(1:3), v, Dir];
                        im_v_pos(event(3)+1,event(2)+1,:) = [v*cosd(Dir),v*sind(Dir),v,Dir];
                        l = l+1;
                    end
                end
            end  
        else
            if (k>Fsamples)
                v_neg = cleanneg(k-Fsamples:k-1,4);
                M_v_neg = mean(v_neg);
                V_v_neg = std(v_neg);
            end
            sign = 3;
            im2(event(3)+1,event(2)+1,sign).time = im1(event(3)+1,event(2)+1,sign).time;
            im1(event(3)+1,event(2)+1,sign).time = event(1);
            im(event(3)+1,event(2)+1,:) = [0,0,0];
            dir = DVS_direction(event,neigh,sign);
            if isempty(dir)
                v = [];
            else
                [v,Dir] = DVS_speed(event,neigh,sign,dir); 
            end
            if (isempty(v) ~= 1)
                cleanneg(k,:) = [event(1:3), v, Dir];
                k = k+1;
                if (k>Fsamples+1)
                    if ((v > M_v_neg-1.5*V_v_neg) && (v < M_v_neg+1.5*V_v_neg))
                        filteredneg(m,:) = [event(1:3), v, Dir];
                        im_v_neg(event(3)+1,event(2)+1,:) = [v*cosd(Dir),v*sind(Dir),v,Dir];
                        m = m+1;
                    end
                end
            end   
        end
    end
    total_t = total_t + toc;
    if (rem(i,10000)==0)
        i
%         img1 = im;
        img2 = flow_visualization(im_v_pos(:,:,1)+im_v_neg(:,:,1),im_v_pos(:,:,2)+im_v_neg(:,:,2));
        img2(1:size(colorcode,1),end-size(colorcode,2)+1:end,:) = colorcode;
%         im = [img1,zeros(360,3,3),img2];
        imshow(img2,'InitialMagnification',1200)
        hold on 
        quiver(im_v_pos(:,:,1),im_v_pos(:,:,2),8,'Color','r')
        quiver(im_v_neg(:,:,1),im_v_neg(:,:,2),8,'Color','b')
        drawnow
%         frame = getframe(gcf);
%         writeVideo(vid,frame);
        clf('reset')
        disp(total_t)
        im_v_pos = zeros(row,col,4);
        im_v_neg = zeros(row,col,4);
%         im = 128*ones(row,col,3);
    end
    if (rem(i,20000)==0)
        prev_t = zeros(row,col);
    end
end
% close(vid)
cleanpos(cleanpos(:,1)==0,:) = [];
filteredpos(filteredpos(:,1)==0,:) = [];
filteredneg(filteredneg(:,1)==0,:) = [];
direction_selective = [filteredpos;filteredneg];
