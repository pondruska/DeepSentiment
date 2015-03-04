function y = Softmax(x)
    z = exp(x);
    y = z / sum(z);
end