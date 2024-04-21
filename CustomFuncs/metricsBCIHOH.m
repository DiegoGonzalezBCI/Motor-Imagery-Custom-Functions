%% New denoising approach
% First: segmentate a small quantity of data, for example, 1 s time window
% for any small number of participants. 

%% BCI+HOH Plotter
% whatToPlot == 1: cap-like, time series, video format
% whatToPlot == 2: cap-like, time series, non-video format
% whatToPlot == 3: non-cap like, time series, video format
% whatToPlot == 4: non-cap-like, time series, non-video format
% whatToPlot == 5: cap-like, frequency series, trial format
% whatToPlot == 6: non-cap like, frequency series, trial format
% whatToPlot == 7: non-cap like, time-frequency series, video format
% When using whatToPlot == 1 or 2 or 5, MAKE SURE that division.chan was 1:8
options.fps = 8; % frames per second of the video-like plot output % MAKE SURE that 256/fps is an integer
options.time = [0 1]; % start and end time of animation
options.domain = 1; % 1: time domain, 2: frequency domain, 3: both
options.video = 1; % 1: Video format, 0: no video format
options.chan = 1; % 1: C3, 2: C1 3: Cz, 4: C2, 5: C4, 6: CP3, 7: CPz, 8: CP4 % Channel number to partake in the output
options.trials = 1; % 1:24; % Trials to analyze (exclusively in frequency domain)
options.needed = true;
options.whatToPlot = 2;
plotBCIHOH(info, options, EEG1, POW1)
options.whatToPlot = 4;
plotBCIHOH(info, options, EEG1, POW1)
options.whatToPlot = 5;
plotBCIHOH(info, options, EEG1, POW1)
options.whatToPlot = 6;
plotBCIHOH(info, options, EEG1, POW1)
%% Apply exclusion criteria in time domain
for i = 1:24
    eval(sprintf("Trial_%d = EEG1.trial{i}';",i))
end
stackedplot(table(Trial_1,Trial_2,Trial_3,Trial_4,Trial_5,Trial_6,Trial_7,Trial_8,Trial_9,Trial_10,Trial_11,Trial_12,Trial_13,Trial_14,Trial_15,Trial_16,Trial_17,Trial_18,Trial_19,Trial_20,Trial_21,Trial_22,Trial_23,Trial_24))
clear Trial_1 Trial_2 Trial_3 Trial_4 Trial_5 Trial_6 Trial_7 Trial_8 Trial_9 Trial_10 Trial_11 Trial_12 Trial_13 Trial_14 Trial_15 Trial_16 Trial_17 Trial_18 Trial_19 Trial_20 Trial_21 Trial_22 Trial_23 Trial_24

%% For the Rest State 
info.event = 1; % 1: Rest, 2: Imagination, 3: Beep (mutually exclusive variable)
% A total of 4 different stages of the experiment, each with 24 trials, and 8 electrodes,
% counting for an amount of up to 768 possible vectors to inspectionate per
% participant. Per vector, 3 exclusion criteria metrics are to be computed.

% To plot:
ctr_names = ["MPP" "STD" "SNR"];
ctr_parti = ["1" "2" "3" "4" "5" "6" "7" "8" "9" "10" "11" "12" "13" "14" "15" "16" "17" "18" "19" "20" "21" "22" "23" "24" "25" "26" "27" "28" "29" "30"];
chan = {"C3", "C1", "Cz", "C2", "C4", "CP3", "CPz", "CP4"};
options.whatToPlot = 9; % Options: 8 or 9
options.ctr_names = ctr_names;
options.ctr_parti = ctr_parti;
options.chan = chan;
options.needed = false; POW1 = [];
% Three well defined exclusion criteria are to be computed: 
% MPP: Maximum peak-to-peak value over 200 microVolts
% STD: Standard Deviation amplitude over 50 microVolts
% SNR: Signal to Noise Ratio under 0.7

% Independent matrices are to be differentiated per age group.
% If done, independent matrices are to be differentiated per domain-analysis

nRest_young_time = zeros(4,8,24,3,30); 
% 4 stages, 8 electrodes, 3 metrics, 30 participants
nRest_older_time = zeros(4,8,24,3,30); 
% 4 stages, 8 electrodes, 3 metrics, 30 participants

stage = 0;
for i = 1:2 % For each moment 1:2
    for j = 1:2 % For each stage 1:2
        info.par = 1:60; % 1:60 % MAKE SURE that YvsO = 1:2
        info.type = j; % 1: Training, 2: Online Validation
        info.numM = i; % 1: First moment, 2: Second moment
        [EEG1,EEG2] = divisionBCIHOH(info);
        stage = stage + 1;
        options.stage = stage;
        for k = 1:size(EEG1.trial,2)/24
            [MPP, STD, SNR] = exclusion_criteria(EEG1.trial(24*(k-1)+1:24*k));
            nRest_young_time(stage,:,:,1,k) = MPP;
            nRest_young_time(stage,:,:,2,k) = STD;
            nRest_young_time(stage,:,:,3,k) = SNR;
        end
        for k = 1:size(EEG2.trial,2)/24
            [MPP, STD, SNR] = exclusion_criteria(EEG2.trial(24*(k-1)+1:24*k));
            nRest_older_time(stage,:,:,1,k) = MPP;
            nRest_older_time(stage,:,:,2,k) = STD;
            nRest_older_time(stage,:,:,3,k) = SNR;
        end
        options.j = j; options.i = i;
        options.nRest_young_time = nRest_young_time;
        options.nRest_older_time = nRest_older_time;
        plotBCIHOH(info, options, EEG1, POW1)
    end
end
% Inspectionate which electrodes have the most artifacts 
% Do this per stage, across all trials and participants
%% Following implementation: 
% Inspectionate which electrodes have the most artifacts.
% Do this per stage, but make compairsons among similars. 

