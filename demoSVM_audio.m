clear;
model = 'model_11_12_speech_abuse_all_features_filter_6stats.mat';
[Features, FeatureStats, Feature_Names, classNames, FileNames, MEAN, STD, Statistics,stWin, stStep, mtWin, mtStep] = kNN_model_load(model);
F           = [Features{1}, Features{2}]';% Get the features to matrix (rows correspond to samples):
numOfSamples = length(F);
Labels = cell(size(Features{1}, 2) + size(Features{2}, 2), 1) ;
Labels(1:size(Features{1}, 2)) = {classNames{1}};
Labels(size(Features{1}, 2)+1: size(Features{1}, 2)+size(Features{2}, 2)) = {classNames{2}};
randPerm     = randperm(numOfSamples);
Ftrain       = F(randPerm(1:ceil(numOfSamples/2)),:);
LabelsTrain  = Labels(randPerm(1:ceil(numOfSamples/2)));
Ftest        = F(randPerm(ceil(numOfSamples/2)+1:end), :);
LabelsTest   = Labels(randPerm(ceil(numOfSamples/2)+1:end));

% train the SVM classifier (default values used):
svmStruct = fitcsvm(Ftrain, LabelsTrain);
% test the SVM classifier:
[label,score]  = predict(svmStruct,Ftest);
score = (score-min(score,2)) ./ (max(score,2)-min(score,2));% rescare score to [0,1]

% compute accuracy 
% (number of correctly classified samples / total number of testing samples):
Accuracy    = length(find(strcmp(label, LabelsTest))==1) ...
    / length(label)
