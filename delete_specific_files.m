function delete_specific_files(path,symbol)

if ~exist(path,'dir')
    error('Audio sample path is not valid!');
else
    path = [path filesep];
end
D = dir([path '*.wav']);

for i=1:length(D) % for each wav file in the given path:
    curFileName = [path D(i).name];
    if (strfind(D(i).name,symbol) )
        delete(curFileName)
    end
end
