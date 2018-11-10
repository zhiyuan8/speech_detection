# Real-time Speech-non-speech classifier

This matlab classifier aims to distinguish normal speech, abusive/angry/violate speech and environmental noise. The classifier is based on audio features and KNN. Noted, codes for short-term feature extraction is based on Theodoros Giannakopoulos's Matlab Audio Analysis Library (https://www.mathworks.com/matlabcentral/fileexchange/45831-matlab-audio-analysis-library)

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

| Class | Description |# of files | Database|
| --- | --- | --- | --- |
| Normal Speech | Voice on phone | ≈250 | http://www.speech.cs.cmu.edu/databases/pda/README.html|
|Normal Speech | Daily speech | ≈250 | https://github.com/vocobox/human-voice-dataset|
|Abusive Speech |Scream, shouts, very loud angry sounds |≈300|https://www.freesoundeffects.com/free-sounds/human-sound-effects-10037/|
|Abusive Speech |Abusive words |≈200 |https://freesound.org/search/?q=shit|
|Non-speech | Noise in life(animals, music, cars, alarms, machines...)| ≈800 | https://github.com/karoldvl/ESC-50|
|Non-speech | Noise indoor(breath, yawns, keyboards, electronic devices...)| ≈200 | https://github.com/amsehili/noise-of-life |

## Results
1.Open Matlab, Normally Speak to microphone. Speech identification works well and can identify my speech. When there is a short break between my two sentences, the classifier can find that short blank.

![Classfier performance for my speak in normal emotion and pace](https://github.com/zhiyuan8/speech_detect/blob/master/figures/1.jpg)

2.Open Matlab, make some noises. Noise identification works well.  At first some high-frequent noises (clapping table, knock keyboards) are hard to tell, but after adding a dB filter, the classifier works better. 

![Classfier performance for some noise](speech_detection/figures/2.jpg)

3.Open Matlab, Speak violently or broadcast an angry audio from phone. In this example the abusive classifier works well. But when I test it with my voice, it is hard to distinguish. Due to the fact that most of training audios are scream shouting, my low male voice is hard to classify when I speak violently.

![Classfier performance for a 20s angry female speech from Internet](speech_detection/figures/3.jpg)

## Contributing

* **Jim Zhiyuan Li** - *Initial work* 
Email: zhiyuan.li1995@hotmail.com

## Acknowledgments

* Thanks for Theodoros Giannakopoulos's Matlab Audio Analysis Library and his wonderful book <<Introduction to Audio Analysis>> (https://www.elsevier.com/books/introduction-to-audio-analysis/giannakopoulos/978-0-08-099388-1)
* Thanks for Professor Ashish Goel for this giving project.Thanks for Nikhil Garg's and Sukolsak Sakshuwong's advice during weekly meetings
