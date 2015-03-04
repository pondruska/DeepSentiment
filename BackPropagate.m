function [GV, GW, GWs, GL] = BackPropagate(x, a, dEdp, V, W, Ws, L)
    [d, n] = size(L);
    
    GWs  = (a.y - x.t) * a.p';
    dEdp = dEdp + Ws' * (a.y - x.t);
    
    if isfield(x, 'i')
        GL = sparse(d, n);
        GL(:, x.i) = dEdp;
        
        GV = 0;
        GW = 0;
    else
        delta = dEdp .* (1 - a.p .* a.p);
        
        [GV, GX] = TensorProductDerivative(V, [a.L.p; a.R.p], delta);
        
        DD = W' * delta + GX;
        DL = DD((0+1):(0+d));
        DR = DD((d+1):(d+d));
        
        GW = delta * [a.L.p; a.R.p]';
        
        [GV_L, GW_L, GWs_L, GL_L] = BackPropagate(x.L, a.L, DL, V, W, Ws, L);
        [GV_R, GW_R, GWs_R, GL_R] = BackPropagate(x.R, a.R, DR, V, W, Ws, L);
        
        GV = GV + GV_L + GV_R;
        GW = GW + GW_L + GW_R;
        GWs = GWs + GWs_L + GWs_R;
        GL = GL_L + GL_R;
    end
end