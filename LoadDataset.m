function X = LoadDataset(V, filename)
    X = cell(1,10000);
    fileID = fopen(filename);
    for i=1:10000
        L = fgetl(fileID);
        if L == -1
            X = X(1:i-1);
            break;
        end
        X{i} = ParseTree(V, lower(L));
    end
    fclose(fileID);
end