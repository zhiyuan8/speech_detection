function [Bit_temp, Fs_temp, Channel_temp, FileNamesTemp] = check_bits_Fz(path)

if ~exist(path,'dir')
    error('Audio sample path is not valid!');
else
    path = [path filesep];
end

% Feature extraction:
D = dir([path '*.wav']);
FileNamesTemp = cell(length(D),1); % Pre-allocate size
Bit_temp = zeros(length(D),1); % Pre-allocate size
Fs_temp = zeros(length(D),1); % Pre-allocate size
Channel_temp = zeros(length(D),1); % Pre-allocate size

for ( i=1:length(D) ) % for each wav file in the given path:
    curFileName = [path D(i).name];
    FileNamesTemp{i} = D(i).name;
    INFO = audioinfo(curFileName);
    Bit_temp(i) = INFO.BitsPerSample;
    Fs_temp(i) = INFO.SampleRate;
    Channel_temp(i) = INFO.NumChannels;
end

