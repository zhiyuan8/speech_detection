function [tc] = train_tree(modelName)

%load model and do normalization;
[Features, FeatureStats, Feature_Names, classNames, FileNames, MEAN, STD, Statistics,stWin, stStep, mtWin, mtStep] = kNN_model_load(modelName);
Ftrain   = [Features{1},Features{2}]'; % define training data
LabelsTrain = ones(length(Ftrain), 1) ; % define training labels
LabelsTrain( 1:length(Features{1}) ) = 1;
LabelsTrain( (1+length(Features{1})) : length(Ftrain) ) = 2;
tc = fitctree(Ftrain, LabelsTrain, 'PredictorNames', FeatureStats,'MinParentSize',size(Ftrain,1)/100);


