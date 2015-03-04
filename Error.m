function E = Error(a, x)
    E = - x.t' * log(a.y);
    if ~isfield(x, 'i')
        E = E + Error(a.L, x.L) + Error(a.R, x.R);
    end
end