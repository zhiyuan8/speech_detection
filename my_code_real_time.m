%% The first classfier aims to tell noise and speech
clear all;
clc;
fclose('all'); % close all open files

%% train a KNN-model with desired features + stats
stWin=0.05; stStep=0.05; % there will be 20 elements in each window 
mtWin=1.0; mtStep=1.0; % our discriminative window is 1s
filter_dec = true; % Remeber to double check it
Statistics = { 'mean', 'median' , 'min' , 'max' , 'std' , 'std / mean'}; % 6 stats
%Feature_Names_all = {'ZCR','E','E_Entropy','S_Centroid','S_Spread','S_Entropy','S_Flux','S_Rolloff','MFCC_01','MFCC_02','MFCC_03','MFCC_04','MFCC_05','MFCC_06','MFCC_07','MFCC_08'...
%'MFCC_09','MFCC_10','MFCC_11','MFCC_12','MFCC_13','H_Ratio'};
Feature_Names_all = {'ZCR','E','E_Entropy','S_Centroid','S_Spread','S_Entropy','S_Flux','S_Rolloff'};
%for i=1:length(Feature_Names_all)
    %for j=1:length(Feature_Names_all)
        %if (i~=j)
        Feature_Names = {'H_Ratio','MFCC_01','MFCC_02','MFCC_03','MFCC_04','MFCC_05','MFCC_06','MFCC_07','MFCC_08'...
'MFCC_09','MFCC_10','MFCC_11','MFCC_12','MFCC_13'};
        %Feature_Names
        modelFileName = ['new_model_11_12_speech_abuse_MFCC_H_Ratio_filter_6stats.mat']; 
        strDir = 'C:\Users\Zhiyuan Li\Desktop\Prof_Ashish_Goel\training_data\speech_abuse\';
        kNN_model_add_class(modelFileName, 'abuse', [strDir 'abuse'], Statistics, Feature_Names, stWin, stStep, mtWin, mtStep,filter_dec);
        kNN_model_add_class(modelFileName, 'speech', [strDir 'speech'], Statistics, Feature_Names, stWin, stStep, mtWin, mtStep,filter_dec);
        %end
    %end
%end
%% load KNN model and do normalization
clear all;% close worksheet
clc;% close console
fclose('all'); % close all open files

modelSpeech_Non = 'model_11_11_speech_noise_S_Flux_ZCR_filter_6stats.mat';
modelSpeech_Abuse = 'model_11_12_speech_abuse_MFCC_filter_6stats.mat'; 

if strfind(modelSpeech_Non, 'filter')
    filter_dec1 = true;
else
    filter_dec1 = false;
end

if (strfind(modelSpeech_Abuse, 'filter'))
    filter_dec2 = true;
else
    filter_dec2 = false;
end

KNN_Non=10; %
KNN_Abuse=10;
durationSecs=30;
Fs=16000; %Keep consistant with 16 kHz that I use for training datasets
nbit=16; %Keep consistant with 16 nbits that I use for training datasets

%% run real-time analysis
[recorder,samples,label1, P1, trainchosen1, label2, P2, trainchosen2, calc_time] ...
    = Real_Time_KNN(Fs,nbit, durationSecs,modelSpeech_Non,modelSpeech_Abuse,KNN_Non,KNN_Abuse,filter_dec1,filter_dec2);

%% check choosen file names
[~, ~, ~, classNames1, FileNames1] = kNN_model_load(modelSpeech_Non);
[~, ~, ~, classNames2, FileNames2] = kNN_model_load(modelSpeech_Abuse);
for i= 1:length(trainchosen1)
    ['in second' num2str(i), classNames1{1},'speech class is identified according to']
    FileNames1{1}(trainchosen1{i,1})
end

for i= 1:length(trainchosen2)
    ['in second' num2str(i), classNames1{2}, 'is identified according to']
    FileNames1{2}(trainchosen1{i,2})
end

%% load feature_stats datasheets, and train a tree model 
clear all;% close worksheet
clc;% close console
fclose('all'); % close all open files
modelSpeech_Non = 'model_11_11_speech_noise_S_Flux_ZCR_filter_6stats.mat';
modelSpeech_Abuse = 'new_model_11_12_speech_abuse_all_features_without_MFCC_filter_6stats.mat'; 
durationSecs=30;
KNN_Non=10; 
Fs=16000; %Keep consistant with 16 kHz that I use for training datasets
nbit=16; %Keep consistant with 16 nbits that I use for training datasets
tc2 = train_tree(modelSpeech_Abuse);
%view(tc1,'Mode','graph')
%view(tc2,'Mode','graph')

%% run real-time analysis
[recorder,samples,label1, P1, label2, P2, calc_time] ...
    = Real_Time_tree(Fs,nbit, durationSecs,modelSpeech_Non,KNN_Non, modelSpeech_Abuse,tc2,true,true);

%% load feature_stats datasheets, and train a SVM model 
clear all;% close worksheet
clc;% close console
fclose('all'); % close all open files
modelSpeech_Non = 'model_11_12_speech_noise_all_features_filter_6stats.mat'; % The model that I will load to train
modelSpeech_Abuse = 'model_11_12_speech_abuse_all_features_filter_6stats.mat'; % The model that I will load to train
durationSecs=30;
KNN_Non=10;
Fs=16000; %Keep consistant with 16 kHz that I use for training datasets
nbit=16; %Keep consistant with 16 nbits that I use for training datasets
svmStruct2 = train_SVM(modelSpeech_Abuse);
%% load feature_stats datasheets, and train a shallow NN model 
[recorder,samples,label1, P1, label2, P2, calc_time] ...
    = Real_Time_SVM(Fs,nbit, durationSecs,modelSpeech_Non,KNN_Non, modelSpeech_Abuse,svmStruct2,true,true);
