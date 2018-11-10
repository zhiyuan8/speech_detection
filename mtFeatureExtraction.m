function [mtFeatures] = mtFeatureExtraction(stFeatures, mtWin, mtStep, listOfStatistics)

[numOfFeatures, numOfStWins] = size(stFeatures);
curPos = 1;
% compute the total number of mid-term frames:
numOfMidFrames = ceil((numOfStWins)/mtStep);
mtFeatures = zeros(numOfFeatures * length(listOfStatistics), numOfMidFrames);

for (i=1:numOfMidFrames) % for each mid-term frame
    % get current frame:
    N1 = curPos;
    N2 = curPos+mtWin-1;
    if (N2>size(stFeatures,2))
        N2 = size(stFeatures,2);
    end
    
    CurStFeatures  = stFeatures(:, N1:N2);

    for (j=1:length(listOfStatistics))
        mtFeatures( (j-1)*numOfFeatures + 1: j*numOfFeatures, i) = ...
            computeStatistic(CurStFeatures', listOfStatistics{j});
    end
    curPos = curPos + mtStep;
end
    
function S = computeStatistic(seq, statistic)
    if strcmpi(statistic, 'mean')
        S = mean(seq); return;
    end
    if strcmpi(statistic, 'median')
        S = median(seq); return;
    end
    if strcmpi(statistic, 'std')
        S = std(seq); return;
    end
    if strcmpi(statistic, 'std / mean')
        S = std(seq) ./ (mean(seq)+eps); return;
    end
    if strcmpi(statistic, 'max')
        S = max(seq); return;
    end
    if strcmpi(statistic, 'min')
        S = min(seq); return;
    end    
    if strcmpi(statistic, 'meanNonZero')
        for i=1:size(seq, 2)
            curSeq = seq(:, i);
            S(i) = mean(curSeq(curSeq>0));
        end
        return;
    end
    if strcmpi(statistic, 'medianNonZero')
        for i=1:size(seq, 2)
            curSeq = seq(:, i);
            S(i) = median(curSeq(curSeq>0));
        end
        return;
    end
