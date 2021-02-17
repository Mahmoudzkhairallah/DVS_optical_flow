function [C,a]= DVS_SG_parameters(neigh,order)


idx = floor(neigh/2);
A = zeros(neigh^2,(order+1)*(order +2)/2);
a = zeros(round((order+1)*(order+2)/4),round((order+1)*(order + 2)/4));
ii = 1;
jj = 1;
for jjj = -idx :idx
    for iii = -idx:idx
        for j = 0:order
            for i = 0:order-j
                A(ii,jj) = (iii^(i))*(jjj^j);
                jj = jj+1;
            end
        end
        ii = ii + 1;
        jj = 1;
    end
end
C = pinv(A);