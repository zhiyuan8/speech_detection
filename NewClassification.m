function [Ps,labels] = NewClassification ( Data, Fs, KNN, modelFileName,Features, Feature_Names, MEAN, STD, Statistics, stWin, stStep, mtWin, mtStep,Normalize,filter_dec)

% short-term feature extraction:
sFt = stFeatureExtraction(Data, Feature_Names, Fs, stWin, stStep,filter_dec); % get shot-term features, use another name to store because we already have 'Features'     
mtWinRatio  = round(mtWin  / stStep); %= 1 / 0.05 =20
mtStepRatio = round(mtStep / stStep); %= 1 / 0.05 =20
% mid-term feature statistic calculation:
[mtFeatures] = mtFeatureExtraction(...
    sFt, mtWinRatio, mtStepRatio, Statistics);
% mid-term classification
[Ps, labels] = classifyKNN_D_Multi(Features, (mtFeatures - MEAN') ./ STD', KNN, Normalize, false); 
