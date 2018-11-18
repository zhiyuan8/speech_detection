# A Demo

This matlab classifier aims to distinguish normal speech, abusive/angry/violate speech and environmental noise. The classifier is based on audio features and KNN. SVM and decision tree are also tested, but are not chosen due to poor performance. Noted, codes for short-term feature extraction is based on Theodoros Giannakopoulos's Matlab Audio Analysis Library (https://www.mathworks.com/matlabcentral/fileexchange/45831-matlab-audio-analysis-library)

### Prerequisites

Matlab R2015b and higher.
Most bugs in old versions are due to different names of functions. For example, '''wavread''' is used in old version rather than '''audioread'''.

### Installation and running the code

Download my matlab code
```
git clone https://github.com/zhiyuan8/speech_detection.git
```
Change your Matlab working directory to the folder where you download my code. Open '''main.m''' and press '''run''' button in matlab. A figure will be generated and you can speak to your computer and see performance of this classifier.

## Tranining data source
All my training data are uploaded this this Dropbox link:
https://www.dropbox.com/sh/ysphojpsy0gy1i0/AACPxTSIqPiRnOBROvT6Ee6Sa?dl=0
The training data comes from different databases, and I use matlab to change sampling frequency and nbits. All my training audios have been transferred to 16000 kHz and 16 nbits (see ```Training and Testing by User``` Section). It can be regarded as audio compression because some audios are 44100kHz or 22050kHz.
In speech / environmental noise identification, there are around 1000 files for each class. The comments help you find the corresponding folder after you download the whole datasets. 
| Class | Description |# of files | Database| Comments|
| --- | --- | --- | --- |
|Speech | Voice on phone | ≈350 | http://www.speech.cs.cmu.edu/databases/pda/| Very clear voice by phone recording. I randomly use some files
|Speech | Daily speech | ≈100 | https://github.com/amsehili/noise-of-life | See 'speech' folder in this repo
|Speech | 'A' 'E' 'I' 'O' 'U' | ≈50 | https://github.com/vocobox/human-voice-dataset| Basic pronouncation for 'A' 'E' 'I' 'O' 'U'
|Speech | Male/female/baby scream or cry | ≈200 | https://github.com/amsehili/noise-of-life |  See 'BabyCry' 'FemaleCry' 'FemaleScream' 'MaleScream' folder in this repo
|Speech | Scream, shout | ≈50 | https://www.freesoundeffects.com/free-sounds/human-sound-effects-10037/ | Search 'scream', 'shout'
|Speech | singing a song | ≈50 | https://www.upf.edu/web/mtg/irmas | See 'voi' folder, it means 'voice' 
|Speech | angry abusive speeches | ≈200 | https://freesound.org/search/?q=abusive&f=&s=score+desc&advanced=0&g=1 | This is the main resource for me to find abusive speeches. Search 'f_ck', 'sh_t','abusive','cursive'... Be ready for a mental pollution...
|Noice | Noise in life(animals, music, cars, alarms, machines...)| ≈800 | https://github.com/karoldvl/ESC-50 | I randomly choose around 800 files. There are more than 2000 audios.
|Noice | Noise indoor (breath, yawns, keyboards, electronic devices...)| ≈200 | https://github.com/amsehili/noise-of-life | See 'breathing' 'electricalShaver' 'doorOpening' 'hairDryer' 'handsClapping' 'keyboard' ''keys' 'paper' 'water' 'yawn' folder in this repo 

In speech / abusive speech identification, there are around 400 files for each class. The comments help you find the corresponding folder after you download the whole datasets. 

|Abusive Speech | Male/female/baby scream or cry | ≈200 | https://github.com/amsehili/noise-of-life |  See 'BabyCry' 'FemaleCry' 'FemaleScream' 'MaleScream' folder in this repo
|Abusive Speech | angry abusive speeches | ≈200 | https://freesound.org/search/?q=abusive&f=&s=score+desc&advanced=0&g=1 | This is the main resource for me to find abusive speeches. Search 'f_ck', 'sh_t','abusive','cursive'... Be ready for a mental pollution...
|Normal Speech | Randomly choosen speeches | ≈400 | from 'Voice on phone' and 'Daily speech' above | Randomly choose some normal speech files

## Run the classifier

## Results
1.Open Matlab, Normally Speak to microphone. Speech identification works well and can identify my speech. When there is a short break between my two sentences, the classifier can find that short blank.

![Classfier performance for my speak in normal emotion and pace](https://github.com/zhiyuan8/speech_detection/blob/master/figures/1.jpg)

2.Open Matlab, make some noises. Noise identification works well.  At first some high-frequent noises (clapping table, knock keyboards) are hard to tell, but after adding a dB filter, the classifier works better. 

![Classfier performance for some noise](https://github.com/zhiyuan8/speech_detection/blob/master/figures/2.jpg)

3.Open Matlab, Speak violently or broadcast an angry audio from phone. In this example the abusive classifier works well. But when I test it with my voice, it is hard to distinguish. Due to the fact that most of training audios are scream shouting, my low male voice is hard to classify when I speak violently.

![Classfier performance for a 20s angry female speech from Internet](https://github.com/zhiyuan8/speech_detection/blob/master/figures/3.jpg)

## Contributing

* **Jim Zhiyuan Li** - *Initial work* 
Email: zhiyuan.li1995@hotmail.com

## Acknowledgments

* Thanks for Theodoros Giannakopoulos's Matlab Audio Analysis Library and his wonderful book <Introduction to Audio Analysis> (https://www.elsevier.com/books/introduction-to-audio-analysis/giannakopoulos/978-0-08-099388-1)
* Thanks for Professor Ashish Goel for this giving project.Thanks for Nikhil Garg's and Sukolsak Sakshuwong's advice during weekly meetings.
