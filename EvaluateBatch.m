function [accuracy, error, GV, GW, GWs, GL] = EvaluateBatch(X, V, W, Ws, L)
    N = length(X);
    
    function [accuracy, error, GV, GW, GWs, GL] = EvaluateTree(x)
        A = FeedForward(x, V, W, Ws, L);
        error = Error(A, x);
        [~, i] = max(A.y);
        accuracy = x.t(i);
        [GV, GW, GWs, GL] = BackPropagate(x, A, 0, V, W, Ws, L);
    end
    
    function A = SumCell(C)
        A = 0;
        for i=1:N
            A = A + C{i};
        end
    end
    
    [accuracy, error, GV, GW, GWs, GL] = cellfun(@EvaluateTree, X, 'UniformOutput', false);
    accuracy = SumCell(accuracy) / N;
    error    = SumCell(error)    / N;
    GV  = SumCell(GV)  / N;
    GW  = SumCell(GW)  / N;
    GWs = SumCell(GWs) / N;
    GL  = SumCell(GL)  / N;
end