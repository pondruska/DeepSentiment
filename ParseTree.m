function [T, S] = ParseTree(V, S)
    t = str2double(S(2)) == (0:4)';
    if S(4) == '('
        [T1, S] = ParseTree(V, S(4:end));
        [T2, S] = ParseTree(V, S(2:end));
        S = S(2:end);
        T = struct('t', t, 'L', T1, 'R', T2);
    else
        idx = find(S == ')');
        [~, i] = ismember(S(4:idx(1)-1), V);
        T = struct('t', t, 'i', i);
        S = S(idx(1)+1:end);
    end
end