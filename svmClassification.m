function [score,label] = svmClassification ...
    ( Data, Fs, svm,Feature_Names, MEAN, STD, Statistics, stWin, stStep, mtWin, mtStep,filter_dec)
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

[label,score] = predict(svm,X); % predict result according to tree strcture

for i=1:size(score,1)
    score(i,1) = (score(i,1) - min(score(i,:))) / ( max(score(i,:)) - min(score(i,:)) );
    score(i,2) = (score(i,2) - min(score(i,:))) / ( max(score(i,:)) - min(score(i,:)) );
end
