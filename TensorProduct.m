function y = TensorProduct(V, x)
    d  = size(V, 3);
    y = zeros(d,1);
    for i=1:d
        y(i) = x' * V(:,:,i) * x;
    end
end