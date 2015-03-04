function V = ExtractVocabulary(filename)
    fileID = fopen(filename);
    D = lower(char(fread(fileID)'));
    fclose(fileID);
    W = regexp(D, '\([0-4] ([^) ]*)\)', 'tokens');
    V = unique([W{:}]');
end