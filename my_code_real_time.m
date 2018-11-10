%% The first classfier aims to tell noise and speech
clear all;
clc;
fclose('all'); % close all open files

%% train a KNN-model with desired features + stats
stWin=0.05; stStep=0.05; % there will be 20 elements in each window 
mtWin=1.0; mtStep=1.0; % our discriminative window is 1s
filter_dec = true;
Statistics = { 'mean', 'median' , 'min' , 'max' , 'std' , 'std / mean'}; % 6 stats
Feature_Names = {'ZCR','H_Ratio'};
modelFileName = ['model_11_9_speech_abuse_',Feature_Names{1},Feature_Names{2},'_6stats.mat']; 
%Feature_Names = {'ZCR','E','E_Entropy','S_Centroid','S_Spread','S_Entropy','S_Flux','S_Rolloff','MFCC_01','MFCC_02','MFCC_03','MFCC_04','MFCC_05','MFCC_06','MFCC_07','MFCC_08'...
%MFCC_09','MFCC_10','MFCC_11','MFCC_12','MFCC_13','H_Ratio'};
strDir = 'C:\Users\Zhiyuan Li\Desktop\Prof_Ashish_Goel\resource\train_speech_abuse\';

kNN_model_add_class(modelFileName, 'abuse', [strDir 'abuse'], Statistics, Feature_Names, stWin, stStep, mtWin, mtStep,filter_dec);
kNN_model_add_class(modelFileName, 'speech', [strDir 'speech'], Statistics, Feature_Names, stWin, stStep, mtWin, mtStep,filter_dec);

%% load KNN model and do normalization
clear all;% close worksheet
clc;% close console
fclose('all'); % close all open files

modelSpeech_Non = 'model_11_9_speech_noise_S_flux_6stats.mat'; 
modelSpeech_Abuse = 'model_11_9_speech_abuse_ZCRH_Ratio_6stats.mat'; 

if (strfind(modelSpeech_Non, 'filter'))
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
durationSecs=20;
Fs=44100;%Keep consistant with 44.1 kHz that I use for training datasets

%% run real-time analysis
[recorder,samples,label1, P1, label2, P2, calc_time]  = Real_Time_Recording(Fs,durationSecs,modelSpeech_Non,modelSpeech_Abuse,KNN_Non,KNN_Abuse,filter_dec1,filter_dec2);
