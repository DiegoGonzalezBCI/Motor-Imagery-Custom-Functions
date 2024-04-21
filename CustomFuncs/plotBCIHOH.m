function plotBCIHOH(info, options, EEG1, POW1)
%% PlotBCIHOH
% This is the specialized program to plot the data from the BCIHOH
% experiment.

% Fast viusalization of data
% The following program offers the extraction of each cell's data and
% partitions it from t1 sec to t2 sec taking into account sampling
% freqeuncy. It divides the visualization into 8 plots ordered in electrode
% manner or just a single one. Each frame is precisely of n sec/sec if the
% contrary is not specified.
whatToPlot = options.whatToPlot; % Decides what to plot

if options.needed == true
fs         = info.fs; % Sample Frequency
at         = info.at; % Seconds before
wt         = info.wt; % Seconds after
fps        = options.fps; % Frames per second
time       = options.time; % time of animation (2-element vector)
domain     = options.domain; % 1: time domain, 2: frequency domain, 3: both
video      = options.video; % 1: Video format, 0: no video format
chan       = options.chan; % Channels to partake in the output
trials     = options.trials; % Trials to analyze

t1 = time(1); % Start time (s)
t2 = time(2); % Final time (s) % Make sure that (t2-t1)*fps is an integer
t1 = fs*t1; % Start time (samples)
t2 = fs*t2; % Final time (samples)
step = fs/fps; % Number of time-samples in each frame
step_frec = size(POW1.powspctrm,3); % Number of frequency-samples in each frame
eeg1 = [];
% pow1 = [];
for i = 1:24
    eeg1 = cat(2, eeg1, EEG1.trial{i});
    % pow1 = cat(3, pow1, POW1.powspctrm(i,:,:));
end
% pow1 = squeeze(pow1);
end
%% Here starts cap-like, time series, video format
if whatToPlot == 1
    figure;
    sgtitle(sprintf('Timelapse %.1f-%.1f',t1/fs,t2/fs))
    for k = 1:(t2 - t1)/step
        for i = 1:8
            switch i
                case 1
                    j = 1;
                case 2
                    j = 2;
                case 3
                    j = 3;
                case 4
                    j = 4;
                case 5
                    j = 5;
                case 6
                    j = 7;
                case 7
                    j = 8;
                case 8
                    j = 9;
            end
            subplot(2,5,j)
            plot(eeg1(i,step*(k-1)+t1:step*k+t1))
            %hold on
            title(EEG1.label{i})
            xlabel('Time (s)')
            ylabel('Volts (v)')
            xticks([1 step])
            xticklabels({sprintf('%.2f',(step*(k-1)+t1)/fs), sprintf('%.2f',(step*k+t1)/fs)})
        end
        pause(0.5)
    end
end
%hold off
%% Here starts cap-like, time series, non-video format
if whatToPlot == 2
    figure;
    sgtitle(sprintf('Timelapse %.1f-%.1f',t1/fs,t2/fs))
    for i = 1:8
        switch i
            case 1
                j = 1;
            case 2
                j = 2;
            case 3
                j = 3;
            case 4
                j = 4;
            case 5
                j = 5;
            case 6
                j = 7;
            case 7
                j = 8;
            case 8
                j = 9;
        end
        subplot(2,5,j)
        plot(eeg1(i,t1+1:t2))
        title(EEG1.label{i})
        xlabel('Time (s)')
        ylabel('Volts (v)')
        xticks([1 t2])
        xticklabels({sprintf('%.2f',t1/fs), sprintf('%.2f',t2/fs)})
    end
end
%% Here starts non-cap like, time series, video format
if whatToPlot == 3
    figure;
    title(sprintf('Timelapse %.1f-%.1f',t1/fs,t2/fs))
    for k = 1:(t2 - t1)/step
        plot(eeg1(chan,step*(k-1)+t1:step*k+t1))
        title(EEG1.label{chan})
        xlabel('Time (s)')
        ylabel('Volts (v)')
        xticks([1 step])
        xticklabels({sprintf('%.2f',(step*(k-1)+t1)/fs), sprintf('%.2f',(step*k+t1)/fs)})
        pause(0.5)
    end
end
%% Here starts non-cap-like, time series, non-video format
if whatToPlot == 4
    figure;
    %title(sprintf('Timelapse %.1f-%.1f',t1/fs,t2/fs))
    plot(eeg1(chan,t1+1:t2))
    title(EEG1.label{chan})
    xlabel('Time (s)')
    ylabel('Volts (v)')
    xticks([1 t2])
    xticklabels({sprintf('%.2f',t1/fs), sprintf('%.2f',t2/fs)})
end
%% Here starts cap-like, frequency series, trial format
if whatToPlot == 5
    figure;
    for k = trials
        for i = 1:8
            switch i
                case 1
                    j = 1;
                case 2
                    j = 2;
                case 3
                    j = 3;
                case 4
                    j = 4;
                case 5
                    j = 5;
                case 6
                    j = 7;
                case 7
                    j = 8;
                case 8
                    j = 9;
            end
            subplot(2,5,j)
            plot(squeeze(POW1.powspctrm(k,i,:)))
            title(EEG1.label{i})
            xlabel('Frequency (Hz)')
            ylabel('Power (V^2/Hz)')
        end
        pause(0.5)
    end
end
%% Here starts non-cap like, frequency series, trial format
if whatToPlot == 6
    figure;
    for k = trials
        plot(squeeze(POW1.powspctrm(k,chan,:)))
        title(EEG1.label{chan})
        xlabel('Frequency (Hz)')
        ylabel('Power (V^2/Hz)')
        pause(0.5)
    end
end
%% Here starts non-cap like, time-frequency series, video format
if whatToPlot == 7
    figure;
    sgtitle(EEG1.label{chan})
    for k = trials
        subplot(2,1,1)
        plot(EEG1.time{k}, EEG1.trial{k}(chan,:))
        title('Time domain')
        xlabel('Time (s)')
        ylabel('Volts (v)')
        subplot(2,1,2)
        plot(POW1.freq, squeeze(POW1.powspctrm(k,chan,:)))
        title(EEG1.label{chan})
        title('Frequency domain')
        xlabel('Frequency (Hz)')
        ylabel('Power (V^2/Hz)')
        pause(0.5)
    end
end
%% Elimination Criteria 1
if whatToPlot == 8
chan = options.chan;
stage = options.stage;
ctr_names = options.ctr_names;
nRest_young_time = options.nRest_young_time;
nRest_older_time = options.nRest_older_time;
j = options.j; i = options.i;
for l = 1:8
    switch l
        case 1
            subplot(2,5,1)
        case 2
            subplot(2,5,2)
        case 3
            subplot(2,5,3)
        case 4
            subplot(2,5,4)
        case 5
            subplot(2,5,5)
        case 6
            subplot(2,5,7)
        case 7
            subplot(2,5,8)
        case 8
            subplot(2,5,9)
    end
    if and(j == 1, i == 1)
        sgtitle("Young First Training")
        figure(1)
    elseif and(j == 2, i == 1)
        sgtitle("Young First Online Validation")
        figure(3)
    elseif and(j == 1, i == 2)
        sgtitle("Young Second Training")
        figure(5)
    else
        sgtitle("Young Second Online Validation")
        figure(7)
    end
    bar(ctr_names, squeeze(mean(nRest_young_time(stage,l,:,:,:),[3 5])))
    title(sprintf("%s",chan{l}))
end
for l = 1:8
    switch l
        case 1
            subplot(2,5,1)
        case 2
            subplot(2,5,2)
        case 3
            subplot(2,5,3)
        case 4
            subplot(2,5,4)
        case 5
            subplot(2,5,5)
        case 6
            subplot(2,5,7)
        case 7
            subplot(2,5,8)
        case 8
            subplot(2,5,9)
    end
    if and(j == 1, i == 1)
        sgtitle("Old First Training")
        figure(2)
    elseif and(j == 2, i == 1)
        sgtitle("Old First Online Validation")
        figure(4)
    elseif and(j == 1, i == 2)
        sgtitle("Old Second Training")
        figure(6)
    else
        sgtitle("Old Second Online Validation")
        figure(8)
    end
    bar(ctr_names, squeeze(mean(nRest_older_time(stage,l,:,:,:),[3 5])))
    title(sprintf("%s",chan{l}))
end
end
%% Elimination Criteria 2
% Compare Criteria-wise
if whatToPlot == 9
    chan = options.chan;
stage = options.stage;
ctr_names = options.ctr_names;
nRest_young_time = options.nRest_young_time;
nRest_older_time = options.nRest_older_time;
ctr_parti = options.ctr_parti;
j = options.j; i = options.i;
for l = 1:8
    switch l
        case 1
            subplot(2,5,1)
        case 2
            subplot(2,5,2)
        case 3
            subplot(2,5,3)
        case 4
            subplot(2,5,4)
        case 5
            subplot(2,5,5)
        case 6
            subplot(2,5,7)
        case 7
            subplot(2,5,8)
        case 8
            subplot(2,5,9)
    end
    for q = 1:3
        if q == 1
            if and(j == 1, i == 1)
                sgtitle("Young First Training PP")
                figure(1)
            elseif and(j == 2, i == 1)
                sgtitle("Young First Online Validation PP")
                figure(2)
            elseif and(j == 1, i == 2)
                sgtitle("Young Second Training PP")
                figure(3)
            else
                sgtitle("Young Second Online Validation PP")
                figure(4)
            end
        elseif q == 2
            if and(j == 1, i == 1)
                sgtitle("Young First Training STD")
                figure(5)
            elseif and(j == 2, i == 1)
                sgtitle("Young First Online Validation STD")
                figure(6)
            elseif and(j == 1, i == 2)
                sgtitle("Young Second Training STD")
                figure(7)
            else
                sgtitle("Young Second Online Validation STD")
                figure(8)
            end
        elseif q == 3
            if and(j == 1, i == 1)
                sgtitle("Young First Training SNR")
                figure(9)
            elseif and(j == 2, i == 1)
                sgtitle("Young First Online Validation SNR")
                figure(10)
            elseif and(j == 1, i == 2)
                sgtitle("Young Second Training SNR")
                figure(11)
            else
                sgtitle("Young Second Online Validation SNR")
                figure(12)
            end
        end
        bar(ctr_parti, squeeze(mean(nRest_young_time(stage,l,:,q,:),3)))
        title(sprintf("%s",chan{l}))
    end
end
end
for l = 1:8
    switch l
        case 1
            subplot(2,5,1)
        case 2
            subplot(2,5,2)
        case 3
            subplot(2,5,3)
        case 4
            subplot(2,5,4)
        case 5
            subplot(2,5,5)
        case 6
            subplot(2,5,7)
        case 7
            subplot(2,5,8)
        case 8
            subplot(2,5,9)
    end
    for q = 1:3
        if q == 1
            if and(j == 1, i == 1)
                sgtitle("Older First Training PP")
                figure(13)
            elseif and(j == 2, i == 1)
                sgtitle("Older First Online Validation PP")
                figure(14)
            elseif and(j == 1, i == 2)
                sgtitle("Older Second Training PP")
                figure(15)
            else
                sgtitle("Older Second Online Validation PP")
                figure(16)
            end
        elseif q == 2
            if and(j == 1, i == 1)
                sgtitle("Older First Training STD")
                figure(17)
            elseif and(j == 2, i == 1)
                sgtitle("Older First Online Validation STD")
                figure(18)
            elseif and(j == 1, i == 2)
                sgtitle("Older Second Training STD")
                figure(19)
            else
                sgtitle("Older Second Online Validation STD")
                figure(20)
            end
        elseif q == 3
            if and(j == 1, i == 1)
                sgtitle("Older First Training SNR")
                figure(21)
            elseif and(j == 2, i == 1)
                sgtitle("Older First Online Validation SNR")
                figure(22)
            elseif and(j == 1, i == 2)
                sgtitle("Older Second Training SNR")
                figure(23)
            else
                sgtitle("Older Second Online Validation SNR")
                figure(24)
            end
        end
        bar(ctr_parti, squeeze(mean(nRest_older_time(stage,l,:,q,:),3)))
        title(sprintf("%s",chan{l}))
    end
end
end