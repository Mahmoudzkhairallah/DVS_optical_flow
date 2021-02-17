function V = DVS_LK_optical_flow(spatial_x,spatial_y,temporal,threshold)

    sx2 = 0;
    sy2 = 0;
    sxy = 0;
    sxt = 0;
    syt = 0;
    num = numel(spatial_x);
    under_test = floor(num/2)+1;
    for i = 1:num
        sx2 = sx2 + (spatial_x(i) .* spatial_x(i));
        sy2 = sy2 + (spatial_y(i) .* spatial_y(i));
        sxy = sxy + (spatial_x(i) .* spatial_y(i));
        sxt = sxt + (spatial_x(i) .* temporal(i));
        syt = syt + (spatial_y(i) .* temporal(i));
    end
    a = sx2 + sy2;
    b = (sx2 * sy2) - (sxy * sxy);
    tmp = sqrt(a*a - 4*b);
    l1 = (a + tmp)/2;
    l2 = (a - tmp)/2;
    if (l1 < threshold || isnan(l1))
        V(1) = 0;
        V(2) = 0;
    elseif(l2 < threshold)
        tmp2 = spatial_x(under_test)*spatial_x(under_test) + spatial_y(under_test)*spatial_y(under_test);
        if (tmp2 == 0)
            V(1) = 0;
            V(2) = 0;
        else
            V(1) = - spatial_x(under_test)*temporal(under_test)/tmp2;
            V(2) = - spatial_y(under_test)*temporal(under_test)/tmp2;
        end
    else
        V(1) = ((sxy*syt) - (sy2*sxt)) / b;
        V(2) = ((sxy*sxt) - (sx2*syt)) / b;
    end
    V(3) = sqrt(V(1)*V(1) + V(2)*V(2));   
end