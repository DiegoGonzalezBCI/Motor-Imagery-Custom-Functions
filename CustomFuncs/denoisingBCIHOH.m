%% This program aims to denoise the database "BCI+HOH" which is part of the
% neuroexperiment conducted at Tec de Monterrey campus GDL on the academic
% period 2022/23 and which main purpose is to analyse the neuroactivity of
% 60 participants: 30 young (18-25 yrs) and 30 old (55-older). This program
% is to clean the data using frequency bandpassing and noise-source
% elimination. For rapidity purposes, it is to be known that the first
% components of a neurological signal are almost always the noisiest ones. 
%% For simplicity purposses, the 8th electrode is delated. 
% The data cleaned is stored in the following: 
% EEG1Beep.mat (8th electrode eliminated for noisy purposes)
% its power: POW1Beep.mat
% EEG2Beep.mat
% its power: POW2Beep.mat
%% First extract and segmentate the data
info.fs = 256; % frequency rate of the data
info.at = 0.5; % seconds before the occurrance of the event
info.wt = 1; % seconds after the occurrance of the event MAKE SURE THAT 256*(wt + at) is an integer
info.cutoff = [4 30]; % cutoff frequency for the bandpass filter
info.type = 1:2; % Types of moments to partake (training == 1 & validation == 2) 
% ACHTUNG! If type = 1:2 specify in info.pivot BOTH pivots (they should
% match the event, but they might be numerically different)
info.numM = 1:2; % Number of moments to partake (first T, first V, second T, second V) 1: only the first training and validation, 2: only the second training and validation; [1 2]: both
info.YvsO = 1:2; % Types of participants (young == 1) (old == 2) (young and old == [1 2])
info.pro = 100; % Percentage of the maximal popullation to partake in the study
info.pivot = [203 203]; % To specifically extract 1 sec from the imagination period
info.pow = 1;
% ACHTUNG! Training ALWAYS reffers to the first element in pivot
% whereas  Online Validation ALWAYS reffers to the second element in pivot
[EEG1,EEG2,POW1,POW2,POW1Avg,POW2Avg] = segmentationTrainingAgesBeep(info);

%[EEG1,EEG2] = segmentationTrainingAgesBeep(info);
% cfg                  = [];
% cfg.keeptrials       = 'no';
% AVG1                 = ft_timelockanalysis(cfg, EEG1);
% AVG2                 = ft_timelockanalysis(cfg, EEG2);
%% Now we ask if the unaveraged powerspectrum shows noisy signals (if it surpasses 1 uV^2/Hz)
% Names of the outputs:
% EEG1cleaned.mat & EEG2cleaned.mat
powY = POW1.powspctrm; % powerspectrum of young
powO = POW2.powspctrm; % powerspectrum of older
cleanedData = cell(1,size(EEG1.trial,2));
threshold = 5;
for k = 1:2
    if k == 2
        powY = powO;
    end
for i = 1:size(powY,1)
    whichannel = zeros(1,8);
    for j = 1:8
        if sum(powY(i,j,:) > threshold)
            if sum(powY(i,j,:) > threshold) >= 1 && sum(powY(i,j,:) > threshold) < 3
                a = 1;
            elseif sum(powY(i,j,:) > threshold) >= 3 && sum(powY(i,j,:) > threshold) < 5
                a = 2;
            elseif sum(powY(i,j,:) > threshold) >= 5 && sum(powY(i,j,:) > threshold) < 7
                a = 3;
            elseif sum(powY(i,j,:) > threshold) >= 7 && sum(powY(i,j,:) > threshold) < 10
                a = 4;
            elseif sum(powY(i,j,:) > threshold) >= 10 && sum(powY(i,j,:) > threshold) < 20
                a = 5;
            elseif sum(powY(i,j,:) > threshold) >= 20 && sum(powY(i,j,:) > threshold) < 30
                a = 6;
            elseif sum(powY(i,j,:) > threshold) >= 30 && sum(powY(i,j,:) > threshold) < 70
                a = 7;
            end
            switch j
                case 1 
                    whichannel(1) = whichannel(1)+a;
                case 2
                    whichannel(2) = whichannel(2)+a;
                case 3
                    whichannel(3) = whichannel(3)+a;
                case 4
                    whichannel(4) = whichannel(4)+a;
                case 5
                    whichannel(5) = whichannel(5)+a;
                case 6
                    whichannel(6) = whichannel(6)+a;
                case 7
                    whichannel(7) = whichannel(7)+a;
                case 8
                    whichannel(8) = whichannel(8)+a;
            end
        end
    end
    if sum(whichannel)
        %eeg = squeeze(powY(i,:,:));
        if k == 1
            eeg = EEG1.trial{i};
        else
            eeg = EEG2.trial{i};
        end
        [V,I] = max(whichannel);
        data = [];
        data.label = {'C3';'C1';'Cz';'C2';'C4';'CP3';'CPz';'CP4'};
        sampRate = 256;
        time = (0:1:size(eeg,2)-1)/sampRate; % AQUI EEG ES LA DATA
        data.time = time;
        data.trial = eeg;
        data.fsample = sampRate;
        cfg        = [];
        cfg.method = 'runica'; % this is the default and uses the implementation from EEGLAB
        comp = ft_componentanalysis(cfg, data);
        cfg = [];
        cfg.component = I; % to be removed component(s)
        dataClean = ft_rejectcomponent(cfg, comp, data);
        dataClean = dataClean.avg;
    else
        if k == 1
            dataClean = EEG1.trial{i};
        else
            dataClean = EEG2.trial{i};
        end
    end
    cleanedData{i} = dataClean;
end
if k == 1
    EEG1.trial = cleanedData;
else
    EEG2.trial = cleanedData;
end
end
%% Let's convert the signal to Frequency and then average it, so that we know if it is still noisy
EEG1 = importdata('EEG1cleaned.mat'); % This is cleaned (7 electrodes)
EEG2 = importdata('EEG2cleaned.mat'); % This is cleaned (8 electrodes)
[POW1Avg, POW2Avg, POW1, POW2] = fieldPSD(EEG1, EEG2, 0, 0);
figure; plot(POW1Avg.powspctrm')
figure; plot(POW2Avg.powspctrm')

%% Let's analyze the data in frequency one by one, without breaking it into its components
% Wichtig: the prior program proved to be useless let's see if we can do better
% First import the data
% One must have the noisy data structures EEG1, EEG2, POW1, POW2, POW1Avg, POW2Avg to run this program
% The plan: inspectionate each frequencystamp without breaking it into its main components, if the signal surpasses a certain threshold, then inspectionate their components and eliminate the noisiest ones

pow = POW1.powspctrm;
eeg = EEG1.trial;
for i = 1:size(pow,1)
    i
    whichannel = zeros(1,8);
    for j = 1:size(pow,2)
        for k = 1:size(pow,3)
            if pow(i,j,k) > 2
                whichannel(j) = whichannel(j) + 1;
            end
        end
    end
    if sum(whichannel) 
        [V,I] = max(whichannel);
        data = [];
        data.label = {'C3';'C1';'Cz';'C2';'C4';'CP3';'CPz';'CP4'};
        sampRate = 256;
        time = (0:1:size(eeg{i},2)-1)/sampRate; 
        data.time = time;
        data.trial = eeg{i};
        data.fsample = sampRate;
        cfg        = [];
        cfg.method = 'runica'; % this is the default and uses the implementation from EEGLAB
        comp = ft_componentanalysis(cfg, data);
        cfg = [];
        cfg.component = I; % to be removed component(s)
        dataClean = ft_rejectcomponent(cfg, comp, data);
        eeg{i} = dataClean.avg;
    end
end
%% Let's average the EEG data in time, across all trials
EEG = EEG2;
eegUncompressed = zeros(8,size(EEG.trial{1},2),size(EEG.trial,2));
for i = 1:size(EEG.trial,2)
    eegUncompressed(:,:,i) = EEG.trial{i};
end
eegUncompressedAvg = mean(eegUncompressed,3);
figure(1) ; plot(eegUncompressedAvg')
%% Let's average the EEG data in freq, across all trials
figure(2); plot(POW1Avg.powspctrm')
%%
% Wow that revealed telling things, let's eliminate the 8th component
PSD = 1;
nuances.Ntrials = size(eegUncompressedAvg,3);
nuances.fsample = 256;
nuances.timeSampled = 1;
nuances.chan = {'C3';'C1';'Cz';'C2';'C4';'CP3';'CPz';'CP4'};
nuances.maxfrec = 40;
[EEG, POW, POWAvg] = buildUniFieldTrip(eegUncompressedAvg, PSD, nuances);
data = [];
data.label = {'C3';'C1';'Cz';'C2';'C4';'CP3';'CPz';'CP4'};
sampRate = 256;
time = (0:1:size(EEG.trial{1},2)-1)/sampRate;
data.time = time;
data.trial = EEG.trial{1};
data.fsample = sampRate;
cfg        = [];
cfg.method = 'runica'; % this is the default and uses the implementation from EEGLAB
comp = ft_componentanalysis(cfg, data);
cfg = [];
cfg.component = 8; % to be removed component(s)
dataClean = ft_rejectcomponent(cfg, comp, data);
figure(2); hold on; plot(dataClean.avg');
eegUncompressedAvg = dataClean.avg;
%% Delate the 8th electrode in time of the young participants
EEG = EEG1;
for i = 1:size(EEG.trial,2)
    EEG.trial{i}(8,:) = [];
end
EEG.label = {'C3';'C1';'Cz';'C2';'C4';'CP3';'CPz'};
%% Delete the 8th electrode in freq of the participants
POW = POW1;
POW.powspctrm(:,8,:) = [];
POW.label = {'C3';'C1';'Cz';'C2';'C4';'CP3';'CPz'};
%% To see the data
eegUncompressed = zeros(7,size(EEG.trial{1},2),size(EEG.trial,2));
for i = 1:size(EEG.trial,2)
    eegUncompressed(:,:,i) = EEG.trial{i};
end
eegUncompressedAvg = mean(eegUncompressed,3);
plot(eegUncompressedAvg')
%% Let's try a new way of cleaning up the data:
% Inspectionate each n in frequency, if the signal is noisy, delete it
POW1Rest = importdata('POW_YOUNG_REST.mat');
POW2Rest = importdata('POW_OLDER_REST.mat');
POW1Imag = importdata('POW_YOUNG_IMAG.mat');
POW2Imag = importdata('POW_OLDER_IMAG.mat');
% TIME: 8 x 384 x 24 x 2 x 30
% FREQ: 1440 x 8 x 41
[a,b,c,d] = ind2sub([24 1 2 30],1413);
% Use ind2sub function to recove the indices of the unreshaped matrix,
% whose original indices are specified in the first argument and whose
% target index is the second one. The number of outputs matches the number
% of original dimensions. 
%% Denoise the P300 data to perform the following analysis
EEG1P300 = importdata('EEG1P300.mat');
EEG2P300 = importdata('EEG2P300.mat');
prettier = 0;
denoise = 1;
noisy_participants = {[1 5 7 23 27],[5 12 18 23 28]};
if denoise == 1
    cfg                  = [];
    cfg.keeptrials       = 'no';
    for i = 1:2
        switch i
            case 1
                for j = length(noisy_participants{i}):-1:1
                    EEG1P300.trial(96*(noisy_participants{i}(j)-1)+1:96*noisy_participants{i}(j)) = [];
                    EEG1P300.time(96*(noisy_participants{i}(j)-1)+1:96*noisy_participants{i}(j)) = [];
                end
            case 2
                for j = length(noisy_participants{i}):-1:1
                    EEG2P300.trial(96*(noisy_participants{i}(j)-1)+1:96*noisy_participants{i}(j)) = [];
                    EEG2P300.time(96*(noisy_participants{i}(j)-1)+1:96*noisy_participants{i}(j)) = [];
                end
        end
    end
    AVG1P300                 = ft_timelockanalysis(cfg, EEG1P300);
    AVG2P300                 = ft_timelockanalysis(cfg, EEG2P300);
end
%% Averaging P300 in time and computing max, min, std per channel for both groups

p300youngMetrics = zeros(3,8);
for i = 1:8
    p300youngMetrics(1,i) = max(AVG1P300.avg(i,128:end));
    p300youngMetrics(2,i) = min(AVG1P300.avg(i,128:end));
    p300youngMetrics(3,i) = std2(AVG1P300.avg(i,128:end));
end
X = categorical({'C3';'C1';'Cz';'C2';'C4';'CP3';'CPz';'CP4'});
X = reordercats(X,{'C3';'C1';'Cz';'C2';'C4';'CP3';'CPz';'CP4'});
figure; subplot(1,2,1)
m = bar(X,p300youngMetrics);
[val, indx] = max(AVG1P300.avg(:,128:end)');
[val, indx_] = min(AVG1P300.avg(:,128:end)');
xtips1 = m(1).XEndPoints;
ytips1 = m(1).YEndPoints;
ylim([-2.2 1.7])
labels1 = string(indx/256);
text(xtips1,ytips1,labels1,'HorizontalAlignment','center',...
    'VerticalAlignment','bottom')
xtips1 = m(2).XEndPoints;
ytips1 = m(2).YEndPoints;
labels1 = string(indx_/256);
text(xtips1,ytips1,labels1,'HorizontalAlignment','center',...
    'VerticalAlignment','top')
legend('Max','Min','Std','Location','northwest')
title('Young')
ylabel('Voltage (\muV)')

p300elderlyMetrics = zeros(3,8);
for i = 1:8
    p300elderlyMetrics(1,i) = max(AVG2P300.avg(i,128:end));
    p300elderlyMetrics(2,i) = min(AVG2P300.avg(i,128:end));
    p300elderlyMetrics(3,i) = std2(AVG2P300.avg(i,128:end));
end
subplot(1,2,2); 
m = bar(X,p300elderlyMetrics);
[val, indx] = max(AVG2P300.avg(:,128:end)');
[val, indx_] = min(AVG2P300.avg(:,128:end)');
xtips1 = m(1).XEndPoints;
ytips1 = m(1).YEndPoints;
ylim([-2.2 2])
labels1 = string(indx/256);
text(xtips1,ytips1,labels1,'HorizontalAlignment','center',...
    'VerticalAlignment','bottom')
xtips1 = m(2).XEndPoints;
ytips1 = m(2).YEndPoints;
labels1 = string(indx_/256);
text(xtips1,ytips1,labels1,'HorizontalAlignment','center',...
    'VerticalAlignment','top')
legend('Max','Min','Std')
title('Elderly')
ylabel('Voltage (\muV)')

sgtitle('ERP Metrics')
%% Compute all time series peaks and overlap them in one image with all electrodes
cfg                  = [];
cfg.LineWidth        = 2;
MIBCIHoH_PlotERP(cfg, AVG1, AVG2)
sgtitle('ERP response')




