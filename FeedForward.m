function A = FeedForward(x, V, W, Ws, L)
    if isfield(x, 'i')
        A = struct('p', L(:,x.i));
    else
        AL = FeedForward(x.L, V, W, Ws, L);
        AR = FeedForward(x.R, V, W, Ws, L);
        p = tanh(TensorProduct(V, [AL.p; AR.p]) + W * [AL.p; AR.p]);
        A = struct('p', p, 'L', AL, 'R', AR);
    end
    A.y = Softmax(Ws * A.p);
end