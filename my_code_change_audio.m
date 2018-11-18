%% check Fz and bits of audios
clear all;% close worksheet
clc;% close console
fclose('all'); % close all open files
path= 'C:\Users\Zhiyuan Li\Desktop\Prof_Ashish_Goel\training_data\speech_non_speech\speech'; % remember to change your directory
[Bits, Fs, Channels, FileNames] = check_bits_Fz(path);

%% plot distribution of Bit_temp & Fs_temp
histogram(Bits)
xlabel('Bits');ylabel('Number of files');title('Histogram of Bits for all audio files')
histogram(Fs)
xlabel('Fs');ylabel('Number of files');title('Histogram of Fs for all audio files')
histogram(Channels,'BinWidth',1)
xlabel('Channels');ylabel('Number of files');title('Histogram of Channels for all audio files')

%% Check 
FileNames(Bits==16)
FileNames(Fs==44100)

%% change Fs, bites()
Fs_new = 16000; % New Fs, for those audios with Fs<Fs_new, they will be omitted
bit_new = 16; % New bit
path= 'C:\Users\Zhiyuan Li\Desktop\Prof_Ashish_Goel\training_data\speech_non_speech'; % remember to change your directory
pathNew= 'C:\Users\Zhiyuan Li\Desktop\Prof_Ashish_Goel\training_data\speech_non_speech\new'; % remember to change your directory and make sure this folder exists
change_bit_Fz(path,pathNew,Fs_new,bit_new);

%% delete specific files
path= 'C:\Users\Zhiyuan Li\Desktop\Prof_Ashish_Goel\training_data\speech_non_speech'; % remember to change your directory
symbol = '045';
delete_specific_files(path,symbol)
