clear;
model = 'model_11_12_speech_abuse_all_features_filter_6stats.mat';
[Features, FeatureStats, Feature_Names, classNames, FileNames, MEAN, STD, Statistics,stWin, stStep, mtWin, mtStep] = kNN_model_load(model);
F      = [Features{1},Features{2}]';
numOfSamples = length(F);     
Labels = cell(size(Features{1}, 2) + size(Features{2}, 2), 1) ;
Labels(1:size(Features{1}, 2)) = {classNames{1}};
Labels(size(Features{1}, 2)+1: size(Features{1}, 2)+size(Features{2}, 2)) = {classNames{2}};
randPerm     = randperm(numOfSamples);
Ftrain       = F(randPerm(1:ceil(numOfSamples/2)),:);
LabelsTrain  = Labels(randPerm(1:ceil(numOfSamples/2)));
Ftest        = F(randPerm(ceil(numOfSamples/2)+1:end), :);
LabelsTest   = Labels(randPerm(ceil(numOfSamples/2)+1:end));
cnum_true = ones(length(LabelsTest),1);
for i=1:length(LabelsTest)
    if strcmp(LabelsTest(i),'noise')
    cnum_true(i) = 2;
    end
end
tc = fitctree(Ftrain, LabelsTrain, 'PredictorNames', FeatureStats);
%tc = fitctree(Ftrain, LabelsTrain, 'PredictorNames', FeatureStats,'minparent', size(Ftrain,1)/10);
%view(tc,'Mode','graph')
[label,score]  = predict(tc,Ftest);
% compute accuracy 
% (number of correctly classified samples / total number of testing samples):
Accuracy    = length(find(strcmp(label, LabelsTest))==1) ...
    / length(label)



