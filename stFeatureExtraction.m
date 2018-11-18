function Features = stFeatureExtraction(signal, Feature_Names, fs, win, step, filter_dec)

% test my code:
% [signal,fs]=audioread('C:\Users\Zhiyuan Li\Desktop\Prof_Ashish_Goel\resource\test_speech_non_speech\speech\abuse_boss_shout.wav');
%Feature_Names = {'ZCR','E','E_Entropy','S_Centroid','S_Spread','S_Entropy','S_Flux','S_Rolloff','MFCC_01','MFCC_02','MFCC_03','MFCC_04','MFCC_05','MFCC_06','MFCC_07','MFCC_08'...
%    'MFCC_09','MFCC_10','MFCC_11','MFCC_12','MFCC_13','H_Ratio'};

% if STEREO ...
if (size(signal,2)>1)
    signal = (sum(signal,2)/2); % convert to MONO
end

% convert window length and step from seconds to samples:
windowLength = round(win * fs);
step = round(step * fs);
curPos = 1;
L = length(signal);

% compute the total number of frames:
numOfFrames = floor((L-windowLength)/step) + 1;

% number of features to be computed:
numOfFeatures = length(Feature_Names);
Features = zeros(numOfFeatures, numOfFrames);
Ham = window(@hamming, windowLength);

% Decide if I need to get MFCC
MFCC_dec = false; % First regard it as false
for i=1:length(Feature_Names)
    if( strfind(Feature_Names{i},'MFCC')) % Decide if I have 'MFCC' as a set of my feature array
        MFCC_dec =true;
        temp = zeros(13,1); % save MFCCs and extract some of them for calculation
        mfccParams = feature_mfccs_init(windowLength, fs);  % If MFCC_dec=true, initialize them for MFCC calculation
        break;
    end
end

% Decide if I need to get DFT
DFT_dec = false; % First regard it as false
for i=1:length(Feature_Names)
    if( strfind(Feature_Names{i},'S_')) % Decide if I have 'S_' as a set of my feature array
        DFT_dec =true;
        break;
    end
end

% A large for-loop till the end of this function
for i=1:numOfFrames % for each frame
    % get current frame:
    frame  = double(signal(curPos:curPos+windowLength-1));
    frame  = frame .* Ham;
    if ( (DFT_dec ==true)||(MFCC_dec ==true) )  % compute DFT features before for loop
        frameFFT = getDFT(frame, fs);
        if (i==1) % decide if this is the first column
            frameFFTPrev = frameFFT; 
        end;
    end
    if (MFCC_dec ==true) % compute MFCC features before for loop
        temp =feature_mfccs(frameFFT, mfccParams);
    end
    % loop over all features
    if (sum(abs(frame))>eps)
        for j=1:length(Feature_Names)
            if strcmpi(Feature_Names{j}, 'ZCR')% compute time-domain feature ZCR
                Features(j,i) = feature_zcr(frame);
                continue;
            end
            if strcmpi(Feature_Names{j}, 'E')% compute time-domain feature Energy
                Features(j,i) = feature_energy(frame);
                continue;
            end
            if strcmpi(Feature_Names{j}, 'E_Entropy')% compute time-domain feature Energy_Entropy
                Features(j,i) = feature_energy_entropy(frame, 10);
                continue;
            end
            if (DFT_dec ==true) % compute freq-domain features:
                if strcmpi(Feature_Names{j}, 'S_Centroid')
                    [a,b] = feature_spectral_centroid(frameFFT, fs); % get spectral centroid and spread
                    Features(j,i) = a;
                    continue;
                end
                if strcmpi(Feature_Names{j}, 'S_Spread')
                    [a,b] = feature_spectral_centroid(frameFFT, fs); % get spectral centroid and spread
                    Features(j,i) = b;
                    continue;
                end
                if strcmpi(Feature_Names{j}, 'S_Entropy')
                    Features(j,i) = feature_spectral_entropy(frameFFT, 10); % get spectral entropy
                    continue;
                end
                if strcmpi(Feature_Names{j}, 'S_Flux')
                    Features(j,i) = feature_spectral_flux(frameFFT, frameFFTPrev); % get spectral entropy
                    continue;
                end
                if strcmpi(Feature_Names{j}, 'S_Rolloff')
                    Features(j,i) = feature_spectral_rolloff(frameFFT, 0.90); % get spectral flux
                    continue;
                end                
            end
            switch( str2double( [Feature_Names{j}(6), Feature_Names{j}(7)] ) ) % make sure if it is 'MFCC_01' OR 'MFCC_02' OR 'MFCC_03'...
                case 1
                    Features(j,i) = temp(1);
                case 2
                    Features(j,i) = temp(2);
                case 3
                    Features(j,i) = temp(3);
                case 4
                    Features(j,i) = temp(4);
                case 5
                    Features(j,i) = temp(5);
                case 6
                    Features(j,i) = temp(6);
                case 7
                    Features(j,i) = temp(7);
                case 8
                    Features(j,i) = temp(8);
                case 9
                    Features(j,i) = temp(9);
                case 10
                    Features(j,i) = temp(10);
                case 11
                    Features(j,i) = temp(11);
                case 12
                    Features(j,i) = temp(12);
                case 13
                    Features(j,i) = temp(13);
            end
            if strcmpi(Feature_Names{j}, 'H_Ratio')% compute time-domain feature Energy_Entropy
                [HR, F0] = feature_harmonic(frame, fs);
                Features(j,i) = HR;
                continue;
            end
        end    
    else
        Features(:,i) = zeros(numOfFeatures, 1);
    end    
    curPos = curPos + step; % after a loop ends, add s step for next short-term window
    if (DFT_dec ==true)
        frameFFTPrev = frameFFT; % update your frameFFTPrev
    end
end

if (filter_dec == true)
    Features(length(Feature_Names), :) = medfilt1(Features(length(Feature_Names), :), 3); % returns the output of a third-order median filtering of X.
end