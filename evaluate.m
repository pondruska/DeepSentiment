%% extract words dictionary
D = unique([
  ExtractVocabulary('train.txt')
  ExtractVocabulary('dev.txt')
  ExtractVocabulary('test.txt')
]);

%% load data sets
X_train = LoadDataset(D, 'train.txt');
X_dev   = LoadDataset(D, 'dev.txt');
X_test  = LoadDataset(D, 'test.txt');

%% init parameters of model
d  = 30; % dimension of the word-vector
V  = InitArray([2*d,2*d,d], 0.0001);
W  = InitArray([d,2*d], 0.0001);
Ws = InitArray([5,d], 0.0001);
L  = InitArray([d, length(D)], 0.0001);

%% train network
learningRate = 0.001;
lambda = 0.001; % regularisation strength
K = 500; % number of epochs
M = 32; % minibatch size

error    = []; % training set log-loss error
%accuracy = []; % validation set accuracy

% AdaGrad: gradient mean-square
MS_V  = 0;
MS_W  = 0;
MS_Ws = 0;
MS_L  = 0;

for k=1:K
    for i=1:M:8544
        idx = i:(i+M-1); % sentences in the batch
        
        [A, E, GV, GW, GWs, GL] = EvaluateBatch(X_train(idx), V, W, Ws, L);
        
        % regularize
        E = E + lambda / 2 * (V(:)' * V(:) + W(:)' * W(:) + Ws(:)' * Ws(:) + L(:)' * L(:));
        GV  = GV  + lambda * V;
        GW  = GW  + lambda * W;
        GWs = GWs + lambda * Ws;
        GL  = GL  + lambda * L;
        
        % compute running gradient mean-square
        MS_V  = 0.9 * MS_V  + 0.1 * GV  .* GV;
        MS_W  = 0.9 * MS_W  + 0.1 * GW  .* GW;
        MS_Ws = 0.9 * MS_Ws + 0.1 * GWs .* GWs;
        MS_L  = 0.9 * MS_L  + 0.1 * GL  .* GL;
        
        % update weights
        V  = V  - learningRate * (GV  ./ sqrt(MS_V  + 1e-5));
        W  = W  - learningRate * (GW  ./ sqrt(MS_W  + 1e-5));
        Ws = Ws - learningRate * (GWs ./ sqrt(MS_Ws + 1e-5));
        L  = L  - learningRate * (GL  ./ sqrt(MS_L  + 1e-5));
        
        % draw progress
        error(end+1) = E;
        plot(error); drawnow;
    end
end
