%% Main Script 
% Non-Linear approach for rainfall classification using NL-PCA and SOM
%
% Script to train networks - A simple autoencoder as Non-linear PCA
% generator and a Self-Organizing Map to cluster gauge stations.
%
% All gauge stations belong to Narino Department

% First we import data from available database. See [1].
outfilename = websave('database',...
    'https://ars.els-cdn.com/content/image/1-s2.0-S2352340919308728-mmc1.xlsx');

% From the downloaded file, we put the sheet name and the range of data
data = xlsread('database.xlsx','Est_Missing_Data_Arq 45-44-45','C2:AU409');

% Here we use a standard normalization, i.e., average 0 and standar
% deviation 1.
[Xn,PS] = mapstd(transpose(data));

% The next step is to choice the stations because some of them have
% behaviors associated to other climatologic variables as amazonic forrest.
% From data, we detected that station MON (gauge station in column 38 from
% Xn)had to remove.
X = transpose([Xn(1:37,:); Xn(39:end,:)]);

% Now, we are going to build an Autoencoder neural network. This
% architecture is similar to the work developed by Scholz et al. in [2],
% but using the Neuronal Network Toolbox from MatLab, which was introduced
% in R2015b version.

% This procedure includes a way to build a full autoencoder step by step to
% define the set of layers such as we can get the results from the middle
% layer. For this case, we prepare a layer of 200 units in the first hidden
% layer. We repeat this procedure until only five components represent the
% amount of data in the database. The output should be a 5x44
autoenc1 = trainAutoencoder(X,200,'MaxEpochs',3000,...
'DecoderTransferFunction','purelin');

% Z1 represents the output from the hidden layer which goes to the output
% layer. For this particular procedure our interest is reduce the number of
% sample times (408) to only five, where we hope to get these five
% non-linear principal components such that they represent the trend and
% the seasonally from all samples in the time.
Z1 = encode(autoenc1,X);

% Next, others layers are added, but deacreasing the number of units.
autoenc2 = trainAutoencoder(Z1,25,'MaxEpochs',1000,...
'DecoderTransferFunction','purelin');
Z2 = encode(autoenc2,Z1);
autoenc3 = trainAutoencoder(Z2,5,'MaxEpochs',1000,...
'DecoderTransferFunction','purelin');
Z3 = encode(autoenc3,Z2);

% Now, we build the full encode network using the function stack from
% Autoencoder class functions.
deepnet1 = stack(autoenc1,autoenc2,autoenc3);
view(deepnet1);

%% Optional Procedure to check the reconstruction for all gauge stations
% deco1 = linearlayer(0,1E-10);
% deco1.layers{1}.transferFcn = 'purelin';
% deco1 = train(deco1,Z1,X);
% deco1.IW{1} = autoenc1.DecoderWeights;
% deco1.b{1} = autoenc1.DecoderBiases;
% deco1.divideFcn = autoenc1.TrainingParameters.DataDivision;
% deco1.performFcn = autoenc1.TrainingParameters.LossFunction;
% deco1.trainFcn = autoenc1.TrainingParameters.Algorithm;
% 
% deco2 = linearlayer(0,1E-10);
% deco2.layers{1}.transferFcn = 'purelin';
% deco2 = train(deco2,Z2,Z1);
% deco2.IW{1} = autoenc2.DecoderWeights;
% deco2.b{1} = autoenc2.DecoderBiases;
% deco2.divideFcn = autoenc2.TrainingParameters.DataDivision;
% deco2.performFcn = autoenc2.TrainingParameters.LossFunction;
% deco2.trainFcn = autoenc2.TrainingParameters.Algorithm;
% 
% deco3 = linearlayer(0,1E-10);
% deco3.layers{1}.transferFcn = 'purelin';
% deco3 = train(deco3,Z3,Z2);
% deco3.IW{1} = autoenc3.DecoderWeights;
% deco3.b{1} = autoenc3.DecoderBiases;
% deco3.divideFcn = autoenc3.TrainingParameters.DataDivision;
% deco3.performFcn = autoenc3.TrainingParameters.LossFunction;
% deco3.trainFcn = autoenc3.TrainingParameters.Algorithm;
% 
% deepnet2 = stack(deco3,deco2,deco1);
% 
% deepnetT = stack(deepnet1,deepnet2);
% deepnetT = train(deepnetT,X,X);
% 
% Xobt = deepnetT(X);

%% Getting the Non-Linear Principal Components (P) 
P = deepnet1(X);

%% Building a Self-Organizing Map in hextop configuration with 5x5 map
net = selforgmap([5 5]);
net = train(net,P);

%% Visualizating the Results
SOM_ClusterDefinition(net,P);
