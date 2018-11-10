function kNN_model_add_class(modelName, className, classPath, ...
    Statistics,Feature_Names, stWin, stStep, mtWin, mtStep,filter_dec)
%
% This function adds an audio class to the kNN classification model
% 
% ARGUMENTS;
% - modelName:  the filename of the model (mat file)
% - className:  the name of the audio class to be added to the model
% - classPath:  the path of the directory where the audio segments of the
%               new class are stored
% - Statistics:   list of mid-term statistics (cell array)
% - Feature_Names: list of short-term features (cell array)
% - stWin, stStep:      short-term window size and step
% - mtWin, mtStep:      mid-term window size and step
%
if ~exist(classPath,'dir')
    error('Audio sample path is not valid!');
else
    classPath = [classPath filesep];
end
% check if the model elaready exists:
fp = fopen(modelName, 'r');
if fp>0 % check if file already exists
    load(modelName);
end

% Feature extraction:
D = dir([classPath '*.wav']);
F = [];
FileNamesTemp = cell(length(D),1); % Pre-allocate size

for ( i=1:length(D) ) % for each wav file in the given path:
    curFileName = [classPath D(i).name];
    FileNamesTemp{i} = D(i).name; % I just save filename.wav rather than whole path
    % mid-term feature extraction for each wav file:
    midFeatures = featureExtractionFile(curFileName, Feature_Names, ...
        stWin, stStep, mtWin, mtStep, Statistics, filter_dec);
    % long-term averaging:
    longFeatures = mean(midFeatures,2);       
    
    F = [F longFeatures];
end

% save labels for feature-extractions
FeatureStats = cell(length(Feature_Names)*length(Statistics),1);
k=0;
for i=1:length(Feature_Names)
    for j=1:length(Statistics)
        k=k+1;
        FeatureStats{k} = [Statistics{j} Feature_Names{i}]; % Combine Features with Statistics
    end
end

% save the model:
fp = fopen(modelName, 'r');
if fp<0 % model does not exist --> generate     
    ClassNames{1} = className;
    Features{1} = F;   
    FileNames{1} = FileNamesTemp;
    save(modelName, 'ClassNames', 'Features', 'Feature_Names',...
        'Statistics', 'stWin', 'stStep', 'mtWin', 'mtStep', 'FileNames', 'FeatureStats');
else %add another class into .mat file
    load(modelName);
    ClassNames{end+1} = className;
    Features{end+1} = F;
    FileNames{end+1} = FileNamesTemp;
    save(modelName, 'ClassNames', 'Features', 'Feature_Names',...
        'Statistics', 'stWin', 'stStep', 'mtWin', 'mtStep', 'FileNames', 'FeatureStats');
end
