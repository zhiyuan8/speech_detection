function [score,label] = TreeClassification ...
    ( Data, Fs, tree,Feature_Names, MEAN, STD, Statistics, stWin, stStep, mtWin, mtStep,filter_dec)
% short-term feature extraction:
sFt = stFeatureExtraction(Data, Feature_Names, Fs, stWin, stStep,filter_dec); % get shot-term features, use another name to store because we already have 'Features'     
mtWinRatio  = round(mtWin  / stStep); %= 1 / 0.05 =20
mtStepRatio = round(mtStep / stStep); %= 1 / 0.05 =20
% mid-term feature statistic calculation:
[mtFeatures] = mtFeatureExtraction(...
    sFt, mtWinRatio, mtStepRatio, Statistics);
X = (mtFeatures - MEAN') ./ STD';% mid-term feature normalization
if size(X,2)==1
   X = X'; 
end

[label,score] = predict(tree,X); % predict result according to tree strcture
