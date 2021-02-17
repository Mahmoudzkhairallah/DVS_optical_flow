

global im_v_pos
global im_v_neg
p = im_v_pos(:,:,3);
py = im_v_pos(:,:,2);
px = im_v_pos(:,:,1);

n = im_v_neg(:,:,3);
ny = im_v_neg(:,:,2);
nx = im_v_neg(:,:,1);

pz = p(p~=0);
pxz = px(px~=0);
pyz = py(py~=0);

nz = n(n~=0);
nxz = nx(nx~=0);
nyz = ny(ny~=0);

mp = mean(pz);
mpx = mean(pxz);
mpy = mean(pyz);

mn = mean(nz);
mnx = mean(nxz);
mny = mean(nyz);

sp = std(pz);
spx = std(pxz);
spy = std(pyz);

sn = std(nz);
snx = std(nxz);
sny = std(nyz);

scale = 3;
[rp1,cp1] = find(p<mp-scale*sp);
[rp2,cp2] = find(p>mp+scale*sp);
[rpx1,cpx1] = find(px<mpx-scale*spx);
[rpx2,cpx2] = find(px>mpx+scale*spx);
[rpy1,cpy1] = find(py<mpy-scale*spy);
[rpy2,cpy2] = find(py>mpy+scale*spy);
[rn1,cn1] = find(n<mn-scale*sn);
[rn2,cn2] = find(n>mn+scale*sn);
[rnx1,cnx1] = find(nx<mnx-scale*snx);
[rnx2,cnx2] = find(nx>mnx+scale*snx);
[rny1,cny1] = find(ny<mny-scale*sny);
[rny2,cny2] = find(ny>mny+scale*sny);

for i  = 1:length(rpx1)
    im_v_pos(rpx1(i),cpx1(i),:) = [0,0,0];
end
for i  = 1:length(rpx2)
    im_v_pos(rpx2(i),cpx2(i),:) = [0,0,0];
end
for i  = 1:length(rpy1)
    im_v_pos(rpy1(i),cpy1(i),:) = [0,0,0];
end
for i  = 1:length(rpy2)
    im_v_pos(rpy2(i),cpy2(i),:) = [0,0,0];
end

for i  = 1:length(rnx1)
    im_v_neg(rnx1(i),cnx1(i),:) = [0,0,0];
end
for i  = 1:length(rnx2)
    im_v_neg(rnx2(i),cnx2(i),:) = [0,0,0];
end
for i  = 1:length(rny1)
    im_v_neg(rny1(i),cny1(i),:) = [0,0,0];
end
for i  = 1:length(rny2)
    im_v_neg(rny2(i),cny2(i),:) = [0,0,0];
end

for i  = 1:length(rn1)
    im_v_neg(rn1(i),cn1(i),:) = [0,0,0];
end
for i  = 1:length(rn2)
    im_v_neg(rn2(i),cn2(i),:) = [0,0,0];
end
for i  = 1:length(rp1)
    im_v_pos(rp1(i),cp1(i),:) = [0,0,0];
end
for i  = 1:length(rp2)
    im_v_pos(rp2(i),cp2(i),:) = [0,0,0];
end


figure
subplot(1,2,1)
hold on
title('optical flow vectors')
xlabel('X')
ylabel('Y')
quiver(flip(im_v_pos(:,:,2)),flip(im_v_pos(:,:,1)),3,'Color','r','LineWidth',0.3)
quiver(flip(im_v_neg(:,:,2)),flip(im_v_neg(:,:,1)),3,'Color','b','LineWidth',0.3)
subplot(1,2,2)
hold on
title('a closer look to optical flow vectors')
xlabel('X')
ylabel('Y')
quiver(flip(im_v_pos(1:90,170:260,2)),flip(im_v_pos(1:90,170:260,1)),5,'Color','r','LineWidth',0.3)
quiver(flip(im_v_neg(1:90,170:260,2)),flip(im_v_neg(1:90,170:260,1)),5,'Color','b','LineWidth',0.3)












