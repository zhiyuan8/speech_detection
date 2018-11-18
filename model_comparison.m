%% load KNN model and do normalization
clear all;% close worksheet
clc;% close console
fclose('all'); % close all open files
 filter_dec1 = true;
  filter_dec2 = true;
modelSpeech_Non = 'model_11_12_speech_noise_S_Flux_ZCR_filter_6stats.mat';
KNN_Non=10; %
KNN_Abuse=10;
durationSecs=20;
Fs=16000; %Keep consistant with 16 kHz that I use for training datasets
nbit=16; %Keep consistant with 16 nbits that I use for training datasets

%% load tree model and do simulation
modelSpeech_Non = 'model_11_12_speech_noise_S_Flux_ZCR_filter_6stats.mat'; % The model that I will load to train
tc1 = train_tree(modelSpeech_Non);
tc2 = train_tree(modelSpeech_Abuse);
%view(tc1,'Mode','graph')
%view(tc2,'Mode','graph')

%% load SVM model and do simulation
modelSpeech_Non = 'model_11_12_speech_noise_all_features_filter_6stats.mat'; % The model that I will load to train
svmStruct1 = train_SVM(modelSpeech_Non);
svmStruct2 = train_SVM(modelSpeech_Abuse);

%% run real-time analysis comparison
[recorder,samples, calc_time] ...
    = Real_Time_comparison_speech(Fs,nbit, durationSecs,modelSpeech_Non,modelSpeech_Abuse,KNN_Non,KNN_Abuse,filter_dec1,filter_dec2);
