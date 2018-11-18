# A Demo

This matlab classifier aims to distinguish normal speech, abusive/angry/violate speech and environmental noise. The classifier is based on audio features and KNN. SVM and decision tree are also tested, but are not chosen due to poor performance. Noted, codes for short-term feature extraction is based on Theodoros Giannakopoulos's Matlab Audio Analysis Library (https://www.mathworks.com/matlabcentral/fileexchange/45831-matlab-audio-analysis-library)

### Prerequisites
Matlab R2014 or higher (not quite sure...)
Most bugs in old versions are due to different names of functions. For example, '''wavread''' is used in old version rather than '''audioread'''. To check if your version of matlab is suitable, type in your matlab console
```
help audioread
```
If the explanation for 'audioread' apears, then continue to type
```
help audiorecorder
```
If the explanations for two functions are listed, then you have them in your current matlab, and you can run my code now.

### Installation and running the code
Download my matlab code
```
git clone https://github.com/zhiyuan8/speech_detection.git
```
Change your Matlab working directory to the folder where you download my code. Open '''main.m''' file. Go to ```load KNN model and do normalization``` section, paste the code in your matlab console.
```
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
```
The only part you shall change is 'durationSecs' which indicates the length of this audio recording. I set it as 30s. The codes above tells matlab what features you choose for detection, and the parameters for audio recorder and KNN classifier.
Then, paste the code above in matlab console to launch detection:
```
[recorder,samples,label1, P1, trainchosen1, label2, P2, trainchosen2, calc_time] ...
    = Real_Time_KNN(Fs,nbit, durationSecs,modelSpeech_Non,modelSpeech_Abuse,...
        KNN_Non,KNN_Abuse,filter_dec1,filter_dec2);
```
A figure will be generated and you can speak to your computer and see performance of this classifier.

## Results
1.Open Matlab, Normally Speak to microphone. Speech identification works well and can identify my speech. When there is a short break between my two sentences, the classifier can find that short blank.

![Classfier performance for my speak in normal emotion and pace](https://github.com/zhiyuan8/speech_detection/blob/master/figures/1.jpg)

2.Open Matlab, make some noises. Noise identification works well.  At first some high-frequent noises (clapping table, knock keyboards) are hard to tell, but after adding a dB filter, the classifier works better. 

![Classfier performance for some noise](https://github.com/zhiyuan8/speech_detection/blob/master/figures/2.jpg)

3.Open Matlab, Speak violently or broadcast an angry audio from phone. In this example the abusive classifier works well. But when I test it with my voice, it is hard to distinguish. Due to the fact that most of training audios are scream shouting, my low male voice is hard to classify when I speak violently.

![Classfier performance for a 20s angry female speech from Internet](https://github.com/zhiyuan8/speech_detection/blob/master/figures/3.jpg)


## Tranining data source
All my training data are uploaded this this Dropbox link: https://www.dropbox.com/sh/ysphojpsy0gy1i0/AACPxTSIqPiRnOBROvT6Ee6Sa?dl=0
The training data comes from different databases, and I use matlab to change sampling frequency and nbits. All my training audios have been transferred to 16000 kHz and 16 nbits (see ```Training and Testing by User``` Section). It can be regarded as audio compression because some audios are 44100kHz or 22050kHz.

In speech / environmental noise identification, there are around 1000 files for each class. The comments help you find the corresponding folder after you download the whole datasets. 
| Class | Description |# of files | Database| Comments|
| --- | --- | --- | --- | --- |
| Speech | Voice on phone | ≈350 | http://www.speech.cs.cmu.edu/databases/pda/ | a | 

In speech / abusive speech identification, there are around 400 files for each class. The comments help you find the corresponding folder after you download the whole datasets.

| Class | Description |# of files | Database| Comments|
| --- | --- | --- | --- | --- |
|Abusive Speech | Male/female/baby scream or cry | ≈200 | https://github.com/amsehili/noise-of-life |See 'BabyCry' 'FemaleCry' 'FemaleScream' 'MaleScream' folder in this repo|
|Abusive Speech | angry abusive speeches | ≈200 | https://freesound.org/search/?q=abusive&f=&s=score+desc&advanced=0&g=1 |Search 'f_ck', 'sh_t','abusive','cursive'... Be ready for a mental pollution... |
|Normal Speech | Randomly choosen speeches | ≈400 | from 'Voice on phone' and 'Daily speech' above | Randomly choosen files |

## Training and Testing by User
To be continued

## Contributing

* **Jim Zhiyuan Li** - *Initial work* 
Email: zhiyuan.li1995@hotmail.com

## Acknowledgments

* Thanks for Theodoros Giannakopoulos's Matlab Audio Analysis Library and his wonderful book <Introduction to Audio Analysis> (https://www.elsevier.com/books/introduction-to-audio-analysis/giannakopoulos/978-0-08-099388-1)
* Thanks for Professor Ashish Goel for this giving project.Thanks for Nikhil Garg's and Sukolsak Sakshuwong's advice during weekly meetings.
