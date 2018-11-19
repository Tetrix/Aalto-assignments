% DNN phoneme classifier, Speech recognition exercise 1 bonus task

% These are the commands you've already probably run to load data:
addpath /work/courses/T/S/89/5150/general/ex1
load ex1data

% Shape the input
% For now, Matlab can only handle image or sequence input,
% so we mock the MFCCs to look like images.
% They still have the same information, but just a few extra dimensions

train_data_shaped = permute(...
    reshape(train_data,size(train_data,1),size(train_data,2), 1, 1), ...
    [2 3 4 1]);
% The training function also needs the targets in a particular data type:
train_class_categorical = categorical(train_class);
% Do the same for the held out test data:
test_data_shaped = permute(...
    reshape(test_data, size(test_data,1), size(test_data,2), 1,1), ...
    [2 3 4 1]);
test_class_categorical = categorical(test_class);
num_classes = length(unique(train_class_categorical));

% Build the network architecture

% Hyperparameters related to network architecture:
num_hidden_layers = 3;
layer_size = 256;

total_parameters = 26 * layer_size +... %Input weights
    (num_hidden_layers - 1)*layer_size*layer_size +... %Hidden weights
    layer_size*num_classes+... %Output weights
    26 + (num_hidden_layers -1)*layer_size + num_classes+... %Biases
    4*num_hidden_layers*layer_size %Batch normalisation parameters

% Now create the layers
% Input layer:
layers = [ imageInputLayer([26 1 1],'Normalization','none') ];

% Hidden layers:
for layer_index = 1:num_hidden_layers
    layers = [ layers
        fullyConnectedLayer(layer_size)
        batchNormalizationLayer
        reluLayer ];
end

% Output layer:
layers = [ layers
    fullyConnectedLayer(num_classes)
    softmaxLayer
    classificationLayer ];

% Run the training

% Hyperparameters related to training:
options = trainingOptions('adam', ...
    'GradientDecayFactor',0.9,...
    'SquaredGradientDecayFactor',0.99,...
    'MaxEpochs',10,...
    'InitialLearnRate',0.01, ...
    'Verbose',true, ...
    'ValidationData',{test_data_shaped, test_class_categorical}, ...
    'LearnRateDropFactor',0.1,...
    'LearnRateDropPeriod',3,...
    'LearnRateSchedule','piecewise',...
    'ValidationPatience',10,...
    'ValidationFrequency', 300,...
    'L2Regularization',1e-5,...
    'MiniBatchSize',64,...
    'Shuffle', 'every-epoch',...
    'Plots','training-progress');

% Training:
network = trainNetwork(train_data_shaped, train_class_categorical, layers, options);

% Check the results

test_class_predictions = classify(network, test_data_shaped);
dnn_error = length(find(test_class_predictions~=test_class_categorical))...
    /length(test_class_categorical)*100
plotconfusion(categorical(cellstr(phonemes(test_class_categorical)')),...
    categorical(cellstr(phonemes(test_class_predictions)')));