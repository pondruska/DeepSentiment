function [dzdV, dzdx] = GradientTensorProduct(V, x, dzdy)
    d  = size(V, 3);
    d2 = size(x, 1);
    
    dzdV = zeros(d2,d2,d);
    dzdx = zeros(d,d2);
    
    for i=1:d
        dzdV(:,:,i) = dzdy(i) * (x * x');
        dzdx(i,:)   = x' * (V(:,:,i) + V(:,:,i)');
    end
    dzdx = dzdx' * dzdy;
end

