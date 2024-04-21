%% This code aims to analyze the desynchronization of powerbands in the BCI+HOH
% neuroexperiment. The experiment was conducted at Tec de Monterrey campus
% GDL during the academic period 2022/23 with the aid of the
% Neurotechnology Laboratory. With a whole of 60 participants, 30 young
% ones and 30 older ones, this experiment aims to find statistical
% differences between the performance of both ages groups. Now it is our
% time to divide, analyze, and report the data.
%% After a huge aftermath, these are the names of the cleaned data:
% EEG1Rest.mat & POW1Rest.mat (8th electrode eliminated for noisy purposes)
% EEG2Rest.mat & POW2Rest.mat 
% EEG1Imag.mat & POW1Imag.mat
% EEG2Imag.mat & POW2Imag.mat
%% Import and convert data to frequency domain
% First extract and segmentate the data (-2 to 3)
% The following code gets the data segmentated just when the beep occurs,
% in the format required for the usage of FieldTrip functions. 
info.fs = 256; % frequency rate of the data
info.at = 0; % seconds before the occurrance of the event
info.wt = 1; % seconds after the occurrance of the event MAKE SURE THAT 256*(wt + at) is an integer
info.cutoff = [4 30]; % cutoff frequency for the bandpass filter
info.type = 1:2; % Types of moments to partake (training == 1 & validation == 2)
info.numM = 1:2; % Number of moments to partake (first T, first V, second T, second V) 1: only the first training and validation, 2: only the second training and validation; [1 2]: both
info.YvsO = 1:2; % Types of participants (young == 1) (old == 2) (young and old == [1 2])
info.pivot = [100 201]; % To specifically find the beep (fixation cross)
info.pro = 100; % Percentage of the maximal popullation to partake in the study
info.pow = 1;
[EEG1Rest,EEG2Rest,POW1Rest,POW2Rest,POW1AvgRest,POW2AvgRest] = segmentationTrainingAgesBeep(info);
info.pivot = [101 101]; % To specifically find the beep (test time)
[EEG1Imag,EEG2Imag,POW1Imag,POW2Imag,POW1AvgImag,POW2AvgImag] = segmentationTrainingAgesBeep(info);
%% Cleaning of the data
% Names of the outputs:
% EEG1rest.mat & EEG2rest.mat & EEG1imag.mat & EEG2imag.mat
% Where 1 == young and 2 == older
%powY = POW1r.powspctrm; % powerspectrum of young (REST)
%powO = POW2r.powspctrm; % powerspectrum of older (REST)
cleanedData = cell(1,size(EEG1r.trial,2));
threshold = 5;
for k = 1:4
    switch k 
        case 1 
            pow = POW1r.powspctrm;
        case 2
            pow = POW2r.powspctrm;
        case 3
            pow = POW1o.powspctrm;
        case 4
            pow = POW2o.powspctrm;
    end
for i = 1:size(pow,1)
    whichannel = zeros(1,8);
    for j = 1:8
        if sum(pow(i,j,:) > threshold)
            if sum(pow(i,j,:) > threshold) >= 1 && sum(pow(i,j,:) > threshold) < 3
                a = 1;
            elseif sum(pow(i,j,:) > threshold) >= 3 && sum(pow(i,j,:) > threshold) < 5
                a = 2;
            elseif sum(pow(i,j,:) > threshold) >= 5 && sum(pow(i,j,:) > threshold) < 7
                a = 3;
            elseif sum(pow(i,j,:) > threshold) >= 7 && sum(pow(i,j,:) > threshold) < 10
                a = 4;
            elseif sum(pow(i,j,:) > threshold) >= 10 && sum(pow(i,j,:) > threshold) < 20
                a = 5;
            elseif sum(pow(i,j,:) > threshold) >= 20 && sum(pow(i,j,:) > threshold) < 30
                a = 6;
            elseif sum(pow(i,j,:) > threshold) >= 30 && sum(pow(i,j,:) > threshold) < 70
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
        switch k
            case 1
                eeg = EEG1r.trial{i};
            case 2
                eeg = EEG2r.trial{i};
            case 3
                eeg = EEG1o.trial{i};
            case 4
                eeg = EEG2o.trial{i};
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
        switch k
            case 1
                dataClean = EEG1r.trial{i};
            case 2
                dataClean = EEG2r.trial{i};
            case 3
                dataClean = EEG1o.trial{i};
            case 4
                dataClean = EEG2o.trial{i};
        end
    end
    cleanedData{i} = dataClean;
end
switch k
    case  1
        EEG1r.trial = cleanedData;
    case 2
        EEG2r.trial = cleanedData;
    case 3
        EEG1o.trial = cleanedData;
    case 4
        EEG2o.trial = cleanedData;
end
end
%% Now we shall  transform these data to powerspectrum
EEG1rest = importdata('EEG1rest.mat'); % Young adults REST
EEG2rest = importdata('EEG2rest.mat'); % Older adults REST
EEG1imag = importdata('EEG1imag.mat'); % Young adults IMAG
EEG2imag = importdata('EEG2imag.mat'); % Older adults IMAG

[POW1AvgRest, POW2AvgRest, POW1rest, POW2rest] = fieldPSD(EEG1rest, EEG2rest, 0, 0);
[POW1AvgImag, POW2AvgImag, POW1imag, POW2imag] = fieldPSD(EEG1imag, EEG2imag, 0, 0);

%% Partition by bands
% Import data processed in last segment
POW1rest = importdata('POW1rest.mat'); % This signal is still noisy (Ch 8) [ELIMINATED]
POW2rest = importdata('POW2rest.mat'); % This signal is cleaned
POW1imag = importdata('POW1imag.mat'); % This signal is cleaned
POW2imag = importdata('POW2imag.mat'); % This signal is cleaned
% Which channel is noisy?
cfg                           = [];
cfg.variance                  = 'yes';
POW1AvgRest                   = ft_freqdescriptives(cfg,POW1rest);
POW2AvgRest                   = ft_freqdescriptives(cfg,POW2rest);
POW1AvgImag                   = ft_freqdescriptives(cfg,POW1imag);
POW2AvgImag                   = ft_freqdescriptives(cfg,POW2imag);
%% 
for i = 1:4
    figure(i)
    switch i 
        case 1
            pow = POW1AvgRest.powspctrm;
            title('Averaged Power Young Rest')
        case 2
            pow = POW2AvgRest.powspctrm;
            title('Averaged Power Older Rest')
        case 3
            pow = POW1AvgImag.powspctrm;
            title('Averaged Power Young Imag')
        case 4
            pow = POW2AvgImag.powspctrm;
            title('Averaged Power Older Imag')
    end
    for j = 1:8
        plot(pow(j,:))
        hold on
    end
    legend('C3','C1','Cz','C2','C4','CP3','CPz','CP4')
end
%% There's still noisy data, to delete those channels one shall apply ICA to the averaged data
%dataToBeCleaned = POW1AvgImag.powspctrm;
dataToBeCleaned = dataClean;
data = [];
data.label = {'C3';'C1';'Cz';'C2';'C4';'CP3';'CPz';'CP4'};
sampRate = 256;
time = (0:1:size(dataToBeCleaned,2)-1)/sampRate; % AQUI EEG ES LA DATA
data.time = time;
data.trial = dataToBeCleaned;
data.fsample = sampRate;
cfg        = [];
cfg.method = 'runica'; % this is the default and uses the implementation from EEGLAB
comp = ft_componentanalysis(cfg, data);
cfg = [];
cfg.component = [4 8]; % to be removed component(s)
dataClean = ft_rejectcomponent(cfg, comp, data);
dataClean = dataClean.avg;
%% Here we beginn truthfully to compute the desynchronization of the powerbands
% first import the data in frequency
POW1Rest = importdata('POW1Rest.mat');
POW2Rest = importdata('POW2Rest.mat');
POW1Imag = importdata('POW1Imag.mat');
POW2Imag = importdata('POW2imag.mat');
%%
% plot(squeeze(mean(POW2Imag.powspctrm))')
% Now let's segmentate the powerbands according to the following:
% Delta (0.1 - 4 Hz)  - 1
% Theta (4   - 8 Hz)  - 2
% Alpha (8   - 12 Hz) - 3
% Low Beta  (12  - 16 Hz) - 4
% Normal Beta (16 - 20 Hz) - 5
% High Beta (20 - 30 Hz) - 6
% Gamma (+ 30 Hz)     - 7
% The data is stored as follows: 1440 (trials) x 8 (or 7) electrodes x 41 (frequencystamps)
% Let's create a function specifically designed to compute the powerbands
% of any given tensor and return the magnitude of the powerbands segmentated
info.sampFreq = 1; % This reffers to the "sample frequency" of the data in the frequency domain
info.freqs = [2 3 4 5]; % This is a vector concerning which powerbands (see the upper part) we want
bands1Rest = squeeze(mean(compute_POW_magntiude_bands(POW1Rest,info)));
bands2Rest = squeeze(mean(compute_POW_magntiude_bands(POW2Rest,info)));
bands1Imag = squeeze(mean(compute_POW_magntiude_bands(POW1Imag,info)));
bands2Imag = squeeze(mean(compute_POW_magntiude_bands(POW2Imag,info)));
%%
% The following graphs show the magnitude
figure
X = categorical({'\theta','\alpha','Low \beta','\beta'});
X = reordercats(X,{'\theta','\alpha','Low \beta','\beta'});
for i = 1:8
    if i <= 5
        subplot(2,5,i)
    else
        subplot(2,5,i+1)
    end
    if i < 9
        bar(X,[bands1Rest(i,1) bands1Imag(i,1); bands1Rest(i,2) bands1Imag(i,2); bands1Rest(i,3) bands1Imag(i,3); bands1Rest(i,4) bands1Imag(i,4)])
        ylabel('Magnitude')
    else
        bar(X,[bands1Imag(i,1); bands1Imag(i,2); bands1Imag(i,3); bands1Imag(i,4)])
        ylabel('Magnitude')
    end
end
sgtitle('PSD Magnitude Young')
figure
for i = 1:8
    if i <= 5
        subplot(2,5,i)
    else
        subplot(2,5,i+1)
    end
    bar(X,[bands2Imag(i,1) bands2Rest(i,1); bands2Imag(i,2) bands2Rest(i,2); bands2Imag(i,3) bands2Rest(i,3); bands2Imag(i,4) bands2Rest(i,4)])
    ylabel('Magnitude')
end
sgtitle('PSD Magnitude Old')
%% For less electrodes:
% The following graphs show the magnitude
figure
X = categorical({'\theta','\alpha'});
X = reordercats(X,{'\theta','\alpha'});
for i = 1:7
    if i <= 5
        subplot(2,5,i)
    else
        subplot(2,5,i+1)
    end
    if i < 8
        bar(X,[bands1Rest(i,1) bands1Imag(i,1); bands1Rest(i,2) bands1Imag(i,2)])
        ylabel('Magnitude')
    else
        bar(X,[bands1Imag(i,1); bands1Imag(i,2)])
        ylabel('Magnitude')
    end
end
sgtitle('PSD Magnitude Young')
figure
for i = 1:7
    if i <= 5
        subplot(2,5,i)
    else
        subplot(2,5,i+1)
    end
    bar(X,[bands2Imag(i,1) bands2Rest(i,1); bands2Imag(i,2) bands2Rest(i,2)])
    ylabel('Magnitude')
end
sgtitle('PSD Magnitude Old')
%% The following graphs show desinchronization as a percentual decrease
% Due to the fact that the 8th electrode of the Young-Rest data was
% eliminated, we don't compute the desynchronization of the 8th electrode
% for this population
desYouth = abs(100*((bands1Imag - bands1Rest)./bands1Rest));
desOlder = abs(100*((bands2Imag - bands2Rest)./bands2Rest));
figure
X = categorical({'\theta','\alpha','Low \beta','\beta'});
X = reordercats(X,{'\theta','\alpha','Low \beta','\beta'});
for i = 1:8
    if i <= 5
        subplot(2,5,i)
    else
        subplot(2,5,i+1)
    end
        bar(X,[desYouth(i,1) desOlder(i,1); desYouth(i,2) desOlder(i,2); desYouth(i,3) desOlder(i,3); desYouth(i,4) desOlder(i,4)])
        ylabel('D%')
        sgtitle('Desynchronization Percentage Young vs Old')
end
%% Show desynchronization percentual decrese just in the needed powerbands
desYouth = abs(100*((bands1Imag(1:7,:) - bands1Rest)./bands1Rest));
desOlder = abs(100*((bands2Imag - bands2Rest)./bands2Rest));
figure
X = categorical({'\theta','\alpha'});
X = reordercats(X,{'\theta','\alpha'});
ch = {'C3','C1','Cz','C2','C4','CP3','CPz','CP4'};
for i = 1:8
    if i <= 5
        subplot(2,5,i)
    else
        subplot(2,5,i+1)
    end
    if i < 8
        bar(X,[desYouth(i,1) desOlder(i,1); desYouth(i,2) desOlder(i,2);])
        ylabel('D%')
    else
        bar(X,[desOlder(i,1); desOlder(i,2)])
        ylabel('D%')
    end
    title(sprintf('%s',ch{i}))
end
sgtitle('Desynchronization Percentage between Ages')
%% Now that we have the desynchronization percentage between ages, let's compute statitical differences using ttest
% DEACTIVATE FIELDTRIP TO RUN THIS SECTION
% Let's do a plot per channel, comparing bands between ages
% violinplot([desYouth(1,1) desOlder(1,1) desYouth(1,2) desOlder(1,2) desYouth(1,3) desOlder(1,3) desYouth(1,4) desOlder(1,4) desYouth(1,5) desOlder(1,5)])
info.sampFreq = 1; % This reffers to the "sample frequency" of the data in the frequency domain
info.freqs = [2 3 4 5]; % This is a vector concerning which powerbands (see the upper part) we want
bands1Rest = compute_POW_magntiude_bands(POW1Rest,info);
bands2Rest = compute_POW_magntiude_bands(POW2Rest,info);
bands1Imag = compute_POW_magntiude_bands(POW1Imag,info);
bands2Imag = compute_POW_magntiude_bands(POW2Imag,info);
desYouthUnAvg = abs(100*(bands1Imag - bands1Rest)./bands1Rest);
desOlderUnAvg = abs(100*(bands2Imag - bands2Rest)./bands2Rest);
% Make sure that both variables have the same dim
if size(desYouthUnAvg,1) > size(desOlderUnAvg,1)
    desYouthUnAvg(1:size(desYouthUnAvg,1) - size(desOlderUnAvg,1),:,:) = [];
elseif size(desYouthUnAvg,1) < size(desOlderUnAvg,1)
    desOlderUnAvg(1:size(desOlderUnAvg,1) - size(desYouthUnAvg,1),:,:) = [];
end
violinplot([desYouthUnAvg(:,1,1) desOlderUnAvg(:,1,1) desYouthUnAvg(:,1,2) desOlderUnAvg(:,1,2) desYouthUnAvg(:,1,3) desOlderUnAvg(:,1,3) desYouthUnAvg(:,1,4) desOlderUnAvg(:,1,4)])
%%
desYouthUnAvg = reshape(desYouthUnAvg,[24*length(info.type)*length(info.numM),0.3*info.pro,8,length(info.freqs)]);
desOlderUnAvg = reshape(desOlderUnAvg,[24*length(info.type)*length(info.numM),0.3*info.pro,8,length(info.freqs)]);
%%
band = 4; % Number of powerband (1:4)
bands_ = desOlderUnAvg; % Young or older
%bands_(:,[3 4 7 9 18 19 22 29],:,:) = []; % Deleted channels for young theta 0.1400
%bands_(:,[6 7 9 10 19 20 22 29],:,:) = []; % Deleted channels for young alpha 0.3103
%bands_(:,[7 9 12 14 20 22 25 26],:,:) = []; % Deleted channels for young low beta 0.0120
%bands_(:,[6 7 10 15 22 28],:,:) = []; % Deleted channels for young normal beta 0.0742
%bands_(:,[5 19 23 24],:,:) = []; % Deleted channels for elderly theta -0.0383
%bands_(:,[5 13 22 23 26 27],:,:) = []; % Deleted channels for elderly alpha 0.1316
%bands_(:,[5 8 13 15],:,:) = []; % Deleted channeld for elderly low beta -0.0598
%bands_(:,[5 8 12 13 19],:,:) = []; % Deleted channel for elderly normal beta 0.0200
for i = 7 % Number of channel
    figure(i), cla
    subplot(10,1,1:7)
    image(bands_(:,:,i,band)','CDataMapping','scaled')
    colorbar
    xlabel('Trials'); ylabel('Participant'); title(sprintf('Elderly Beta Desync Chan %s',EEG1Rest.label{i}))
    colormap('jet')
    clim([0 100])
    subplot(10,1,8:10)
    plot(mean(bands_(:,:,i,band),2),'LineWidth',2)
    hold on
    trendline(1:size(bands_,1),mean(bands_(:,:,i,band),2),'r')
    xlabel('Trials'); ylabel('AVG Participants'); %title(sprintf('Young Theta power Chan %s',EEG1Rest.label{i}))
end
%%
desYouthUnAvg_ = desYouthUnAvg; % Deleted channels for young 
desOlderUnAvg_ = desOlderUnAvg; % Deleted channels for elderly 
desYouthUnAvg_(:,[7 9 10 19 29],:,:) = [];
desOlderUnAvg_(:,[5 8 13 22 23],:,:) = [];
%
desYouthUnAvg_ = reshape(desYouthUnAvg_,[size(desYouthUnAvg_,1)*size(desYouthUnAvg_,2)*size(desYouthUnAvg_,3),4]);
desOlderUnAvg_ = reshape(desOlderUnAvg_,[size(desOlderUnAvg_,1)*size(desOlderUnAvg_,2)*size(desOlderUnAvg_,3),4]);
%
violinplot([desYouthUnAvg_(:,1)' desOlderUnAvg_(:,1)' desYouthUnAvg_(:,2)' desOlderUnAvg_(:,2)' desYouthUnAvg_(:,3)' desOlderUnAvg_(:,3)' desYouthUnAvg_(:,4)' desOlderUnAvg_(:,4)'])