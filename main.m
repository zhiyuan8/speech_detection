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
