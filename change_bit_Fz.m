function change_bit_Fz(path,pathNew,Fs_new,bit_new)

if ~exist(path,'dir')
    error('Audio sample path is not valid!');
else
    path = [path filesep];
end

if ~exist(pathNew,'dir')
    error('Generated audio sample path is not valid!');
else
    pathNew = [pathNew filesep];
end

% Feature extraction:
D = dir([path '*.wav']);

for i=1:length(D) % for each wav file in the given path:
    if ( rem(i,100)==0 )
        ['Finished ', num2str(i), ' files']
    end
    curFileName = [path D(i).name];
    newFileName = [pathNew D(i).name];
    [x,fs] = audioread(curFileName); 
    xnew = resample(x,Fs_new,fs); %get a uniformly sampled signal at Fs_new/fs times the original sample rate
    if (max(max(abs(xnew))) >= 1)
        xnew = xnew./max( max( abs(xnew) ) ); %normalize y  
    end
    audiowrite( newFileName,xnew, Fs_new,'BitsPerSample',bit_new);
end
