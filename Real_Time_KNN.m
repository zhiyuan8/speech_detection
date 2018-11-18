function [recorder,samples,label1, P1, trainchosen1, label2, P2, trainchosen2, calc_time] = Real_Time_KNN...
    (Fs, nbit, durationSecs, modelSpeech_Non,modelSpeech_Abuse,KNN_Non,KNN_Abuse,filter_dec1,filter_dec2) 

    % load modelSpeech_Non & modelSpeech_Abuse model
    [Features1, FeatureStats1, Feature_Names1, classNames1, FileNames1, MEAN1, STD1, Statistics1,stWin1, stStep1, mtWin1, mtStep1] = kNN_model_load(modelSpeech_Non);
    [Features2, FeatureStats2, Feature_Names2, classNames2, FileNames2, MEAN2, STD2, Statistics2,stWin2, stStep2, mtWin2, mtStep2] = kNN_model_load(modelSpeech_Abuse);
    
    % define storage size
    label1 = cell(1,ceil(durationSecs)); % length of labels = # of durationSecs
    label2 = cell(1,ceil(durationSecs)); % length of labels = # of durationSecs
    trainchosen1 = cell(ceil(durationSecs),length(classNames1)); % temp names of files in training datasets that are used in KNN
    trainchosen2 = cell(ceil(durationSecs),length(classNames2)); % temp names of files in training datasets that are used in KNN
    calc_time = zeros(1,ceil(durationSecs)); % length of labels = # of durationSecs
    P1 = zeros(ceil(durationSecs),size(Features1,2)); % length of Ps = (# of durationSecs,# of class)
    P2 = zeros(ceil(durationSecs),size(Features2,2)); % length of Ps = (# of durationSecs,# of class)
    durationSecs = durationSecs + 0.5;% add an extra half-second so that we get the full duration in our processing
    lastSampleIdx = 0;% index of the last sample obtained from our recording
    atTimSecs     = 0;% start time of the recording
    recorder = audiorecorder(Fs,nbit,1);% create the audio recorder The number of bits shall be 16 which is what I use for training datasets
    % assign a timer function to the recorder
    set(recorder,'TimerPeriod',1,'TimerFcn',@audioTimerCallback); %TimerPeriod- Time in seconds between TimerFcn callbacks.
    %TimerFcn- Function to execute repeatedly during recording. To specify time intervals for the repetitions, use the TimerPeriod property.
    
    % Define figure handles
    hFig   = figure; % create a figure with two subplots
    hFig.Position= [250 50 950 700]; % Resize the figure I am going to show
    hAxes1 = subplot(3,1,1); % figure for real-time audio wave
    hAxes2 = subplot(3,1,2); % figure for real-time speechnon-speech classfication
    hAxes3 = subplot(3,1,3); % figure for real-time speechabusive speech classfication
    
    %hFig1   = figure; % create a figure with two subplots
    %hFig1.Position= [20 150 150 300]; % Resize the figure I am going to show
    %hAxes4 = subplot(1,1,1);
    %hPlot4 = plot(hAxes4,NaN,NaN);
    
    % create the graphics handles to the data that will be plotted on each axes
    hPlot1 = plot(hAxes1,NaN,NaN);
    legend(hAxes1,'Wave')
    hPlot2 = plot(hAxes2,NaN,NaN,'--ob',NaN,NaN,'--*r',NaN,NaN,'--.g'); % Indicating plot(X1,Y1,X2,Y2,X3,Y3)
    legend(hAxes2,'Speech','Noise')
    hPlot3 = plot(hAxes3,NaN,NaN,'--*k',NaN,NaN,'--ob',NaN,NaN,'--.g'); % Indicating plot(X1,Y1,X2,Y2,X3,Y3)
    legend(hAxes3,'Abusive Speech','Speech')
    hAxes2.YLim=[0,1];hAxes3.YLim=[0,1]; % Make sure ylim is [0,1]
    set(hAxes1.Title,'String','Real-time Audio Wave');
    set(hAxes1.XLabel,'String','Time(s)');
    set(hAxes1.YLabel,'String','Scaled Amplitude');
    set(hAxes2.Title,'String','Speech Detection');
    set(hAxes2.XLabel,'String','Time(s)');
    set(hAxes2.YLabel,'String','Probability');
    set(hAxes3.Title,'String','Abusive Speech Detection');
    set(hAxes3.XLabel,'String','Time(s)');
    set(hAxes3.YLabel,'String','Probability');

    drawnow;
    
    % start the recording
    record(recorder,durationSecs);
    
    % define the timer callback
    function audioTimerCallback(hObject,~)
        
        atTimSecs = atTimSecs + 1; % increment the time in seconds counter
        lastSampleIdx = lastSampleIdx + Fs; % increment the last sample index 
        samples  = getaudiodata(hObject);% get the sample data
        
        % skip if not enough data
        if (length(samples) < lastSampleIdx)
            return;
        end
        % extract information for plot and data-analysis
        %samples = medfilt1(samples,90);
        Data = samples(lastSampleIdx - Fs+1: lastSampleIdx); % X for data analysis
        Y = samples(1:lastSampleIdx); % Y for wave plot
        t1 = (1/Fs):(1/Fs):atTimSecs; % t for time plot
        t2 = 0.5:1:length(P1(:,1));
        
        % real-time data analysis for array X
        tic; % begin documenting time
        [prob1,lab1,index1] = NewClassification(Data, Fs, KNN_Non, modelSpeech_Non, Features1, Feature_Names1, FileNames1, MEAN1, STD1, Statistics1, stWin1, stStep1, mtWin1, mtStep1,2,filter_dec1); % set Normarlize as 2
        label1{atTimSecs} = classNames1{lab1};
        P1(atTimSecs,:) = prob1;
        for i=1:length(classNames1) % there are 2 classes
            if ( length(index1{i}) > 0 ) % index2{i} is not null
                trainchosen1{atTimSecs,i} = index1{i};
            end
        end
        if strcmpi(classNames1{lab1}, 'Speech') % I need to check if this is abusive speech
            [prob2,lab2,index2] = NewClassification(Data, Fs, KNN_Abuse, modelSpeech_Abuse, Features2, Feature_Names2, FileNames2, MEAN2, STD2, Statistics2, stWin2, stStep2, mtWin2, mtStep2,2,filter_dec2); % set Normarlize as 2
            label2{atTimSecs} = classNames2{lab2};
            P2(atTimSecs,:) = prob2;
            for i=1:length(classNames2) % there are 2 classes
                if ( length(index2{i}) > 0 ) % index2{i} is not null
                    trainchosen2{atTimSecs,i} = index2{i};
                end
            end
        else % only noise
            label2{atTimSecs} = 'Noise';
            P2(atTimSecs,:) = [0,0];
        end
        calc_time(atTimSecs) = toc;% stop documenting time
        
        % plot three real-time figures
        %hText = text(0.5, 0.5, label2{atTimSecs}, 'Parent', hAxes4);
        %if (atTimSecs>1)
        %delete(hText);
        %hText = text(0.5, 0.5, label2{atTimSecs}, 'Parent', hAxes4);
        %end
        %set(hPlot4.text, 'String', myString);
        %t = uicontrol(hPlot1,'Style','text','String','Select a data set.','Position',[30 50 130 30]);
        
        set(hPlot1,'XData',t1,'YData',Y);
        set(hPlot2(1),'XData',t2,'YData',P1(:,1));
        set(hPlot2(2),'XData',t2,'YData',P1(:,2));
        set(hPlot2(3),'XData',[0,durationSecs-0.5],'YData',[0.5,0.5]);
        set(hPlot3(1),'XData',t2,'YData',P2(:,1));
        set(hPlot3(2),'XData',t2,'YData',P2(:,2));
        set(hPlot3(3),'XData',[0,durationSecs-0.5],'YData',[0.5,0.5]);
        refreshdata(hPlot1,'caller');
        refreshdata(hPlot2,'caller');
        refreshdata(hPlot3,'caller');
    end

    % do not exit function until the figure has been deleted
    waitfor(hFig);
end