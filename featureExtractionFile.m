function [midFeatures] = ...
    featureExtractionFile (fileName, Feature_Names, stWin, stStep, mtWin, mtStep, Statistics,filter_dec)

% This function reads a wav file and computes 
% audio feature statitstics on a mid-term basis.
%
% ARGUMENTS:
% - fileName:           the name of the input audio file
% - stWin:              short-term window size (in seconds)
% - stStep:             short-term window step (in seconds)
% - mtWin:              mid-term window size (in seconds)
% - mtStep:             mid-term window step (in seconds)
% - featureStatistics:  list of statistics to be computed (cell array)
% - Feature_Names:      list of features to be computed (cell array)
% RETURNS
% - midFeatures         [numOfFeatures x numOfMidTermWins] matrix 
%                       (each collumn represents a mid-term feature vector)
% - Centers:            representive centers for each 
%                       mid-term window (in seconds)
% - stFeaturesPerSegment cell that contains short-term feature sequences
%
% convert mt win and step to ratio (compared to the short-term):
mtWinRatio  = round(mtWin  / stStep);
mtStepRatio = round(mtStep / stStep);
readBlockSize = 60; % one minute block size, in most cases it is regarded as too-large
% get the length of the audio signal to be analyzed:
INFO = audioinfo(fileName);
fs=INFO.SampleRate;
numOfSamples = INFO.TotalSamples;
BLOCK_SIZE = round(readBlockSize * fs);
curSample = 1;
count = 0;
midFeatures = [];

while (curSample <= numOfSamples) % while the end of file has not been reahed
    % find limits of current block:
    N1 = curSample;
    N2 = curSample + BLOCK_SIZE - 1;
    if (N2>numOfSamples)
        N2 = numOfSamples;
    end
    
    tempX = audioread(fileName, [N1, N2]);        
    % STEP 1: short-term feature extraction:
    Features = stFeatureExtraction(tempX, Feature_Names, fs, stWin, stStep, filter_dec);
       
    % STEP 2: mid-term feature extraction:
    [mtFeatures] = mtFeatureExtraction(...
        Features, mtWinRatio, mtStepRatio, Statistics);
    
    midFeatures = [midFeatures mtFeatures];%considering pre-allocating for speed
    
    % update counter:
    curSample = curSample + BLOCK_SIZE;
    count = count + 1;    
end
