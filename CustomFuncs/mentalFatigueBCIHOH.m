%% This program aims to compute possible mental fatigue related with motor imagery 
info.fs = 256; % frequency rate of the data
info.at = 0; % seconds before the occurrance of the event
info.wt = 1; % seconds after the occurrance of the event MAKE SURE THAT 256*(wt + at) is an integer
info.cutoff = [4 30]; % cutoff frequency for the bandpass filter
info.type = 1:2; % Types of moments to partake (training == 1 & validation == 2) 
% ACHTUNG! If type = 1:2 specify in info.pivot BOTH pivots (they should
% match the same event, but they might be numerically different)
info.numM = 1:2; % Number of moments to partake (first T, first V, second T, second V) 1: only the first training and validation, 2: only the second training and validation; [1 2]: both
info.YvsO = 1:2; % Types of participants (young == 1) (old == 2) (young and old == [1 2])
info.pro = 100; % Percentage of the maximal popullation to partake in the study
info.pivot = [101 101]; % To specifically extract 1 sec from the imagination period
info.pow = 1;
% ACHTUNG! Training ALWAYS reffers to the first element in pivot
% whereas  Online Validation ALWAYS reffers to the second element in pivot
[EEG1,EEG2,POW1,POW2,POW1Avg,POW2Avg] = segmentationTrainingAgesBeep(info);
%% Output argument have the following dim:
% 8 (chan) x 256 (samples) x 2880 (trials)
% 2880 = 24 (inner-trials) x 2 (training and online validation) x 2 (times) x 30 (participants)
% Delta (0.1 - 4 Hz)  - 1
% Theta (4   - 8 Hz)  - 2
% Alpha (8   - 12 Hz) - 3
% Low Beta  (12  - 16 Hz) - 4
% Normal Beta (16 - 20 Hz) - 5
% High Beta (20 - 30 Hz) - 6
% Gamma (+ 30 Hz)     - 7

POW1 = importdata('POW1ImagDe.mat');
POW2 = importdata('POW2ImagDe.mat');

info_.sampFreq = 1; % This reffers to the "sample frequency" of the data in the frequency domain
info_.freqs = [2 3 4]; % This is a vector concerning which powerbands (see the upper part) we want
bandsYoung = squeeze(compute_POW_magntiude_bands(POW1,info_));
bandsOlder = squeeze(compute_POW_magntiude_bands(POW2,info_));

% Make sure that both variables have the same dim
% if size(bandsYoung,1) > size(bandsOlder,1)
%     bandsYoung(1:size(bandsYoung,1) - size(bandsOlder,1),:,:) = [];
% elseif size(bandsYoung,1) < size(bandsOlder,1)
%     bandsOlder(1:size(bandsOlder,1) - size(bandsYoung,1),:,:) = [];
% end

bandsYoung = reshape(bandsYoung,[24*length(info.type)*length(info.numM),size(bandsYoung,1)/(24*length(info.type)*length(info.numM)),8,length(info_.freqs)]);
bandsOlder = reshape(bandsOlder,[24*length(info.type)*length(info.numM),size(bandsOlder,1)/(24*length(info.type)*length(info.numM)),8,length(info_.freqs)]);
%%
band = 3; % Number of powerband
bands_ = bandsOlder; % Young or older

%bands_(:,[7 8 9 23 27],:,:) = []; % Deleted channels for young theta 0.0051
%bands_(:,[7 8 9 23 27],:,:) = []; % Deleted channels for young alpha 0.0199
%bands_(:,[5 7 8 9 13 22 23 27],:,:) = []; % Deleted channels for young low beta 0.0028

%bands_(:,[5 18 19],:,:) = []; % Deleted channels for older theta 0.0029
%bands_(:,[5 18 19],:,:) = []; % Deleted channels for older alpha 0.0120
%bands_(:,[5 13 18 19],:,:) = []; % Deleted channels for older low beta 0.0050

for i = 7 % Number of channel
    figure(i), cla
    subplot(10,1,1:7)
    image(bands_(:,:,i,band)','CDataMapping','scaled')
    colorbar
    %xlabel('Trials'); 
    ylabel('Participant','FontSize',15); title(sprintf('Elderly Low Beta power Channel %s',EEG1.label{i}),'FontSize',15)
    colormap('jet')
    clim([0 10])
    subplot(10,1,8:10)
    plot(mean(bands_(:,:,i,band),2),'LineWidth',2)
    hold on
    trendline(1:size(bands_,1),mean(bands_(:,:,i,band),2),'r')
    xlabel('Trials','FontSize',15); ylabel('AVG Power Participants','FontSize',15); %title(sprintf('Older Low Beta power Chan %s',EEG1.label{i}))
end
%% This method demonstrated useful to determine which participants noised the signal the most
% This is for the REST block
info_.sampFreq = 1; % This reffers to the "sample frequency" of the data in the frequency domain
info_.freqs = [2 3 4]; % This is a vector concerning which powerbands (see the upper part) we want
bandsYoung = squeeze(compute_POW_magntiude_bands(POW1Rest,info_));
bandsOlder = squeeze(compute_POW_magntiude_bands(POW2Rest,info_));
bandsYoung = reshape(bandsYoung,[24*length(info.type)*length(info.numM),0.3*info.pro,8,length(info_.freqs)]);
bandsOlder = reshape(bandsOlder,[24*length(info.type)*length(info.numM),0.3*info.pro,8,length(info_.freqs)]);

band = 3; % Number of powerband
bands_ = bandsOlder; % Young or older
%bands_(:,[1 5 7 8 13 23 27],:,:) = []; % Deleted channels for young theta 
%bands_(:,[1 7 12 23 27],:,:) = []; % Deleted channels for young alpha
%bands_(:,[1 5 7 13 23 27],:,:) = []; % Deleted channels for young low beta

%bands_(:,[12 18 22 28],:,:) = []; % Deleted channels for older theta
%bands_(:,[3 11 12 19],:,:) = []; % Deleted channels for older alpha (not that bad)
%bands_(:,[21 22],:,:) = []; % Deleted channels for older low beta (not that bad)
for i = 1:8 % Number of channel
    figure(i), cla
    subplot(10,1,1:7)
    image(bands_(:,:,i,band)','CDataMapping','scaled')
    colorbar
    ylabel('Participant','FontSize',15); title(sprintf('Young Theta power Channel %s',EEG1Rest.label{i}),'FontSize',15)
    colormap('jet')
    %clim([0 10])
    subplot(10,1,8:10)
    plot(mean(bands_(:,:,i,band),2),'LineWidth',2)
    hold on
    trendline(1:size(bands_,1),mean(bands_(:,:,i,band),2),'r')
    xlabel('Trials','FontSize',15); ylabel('AVG Power Participants','FontSize',15); %title(sprintf('Older Low Beta power Chan %s',EEG1.label{i}))
end

%% Let's denoise P300 data

% This is for the P300
info_.sampFreq = 1; % This reffers to the "sample frequency" of the data in the frequency domain
info_.freqs = [2 3 4]; % This is a vector concerning which powerbands (see the upper part) we want
bandsYoung = squeeze(compute_POW_magntiude_bands(POW1,info_));
bandsOlder = squeeze(compute_POW_magntiude_bands(POW2,info_));
bandsYoung = reshape(bandsYoung,[24*length(info.type)*length(info.numM),0.3*info.pro,8,length(info_.freqs)]);
bandsOlder = reshape(bandsOlder,[24*length(info.type)*length(info.numM),0.3*info.pro,8,length(info_.freqs)]);

band = 3; % Number of powerband
bands_ = bandsOlder; % Young or older
%bands_(:,[1 5 7 23 27],:,:) = []; % Deleted channels for young theta 
%bands_(:,[1 5 7 9 23 27],:,:) = []; % Deleted channels for young alpha
%bands_(:,[1 7 10 23 25 27],:,:) = []; % Deleted channels for young low beta

%bands_(:,[5 12 27],:,:) = []; % Deleted channels for older theta
%bands_(:,[12 28],:,:) = []; % Deleted channels for older alpha
%bands_(:,[11 13 18 22 23 28],:,:) = []; % Deleted channels for older low beta
for i = 1:8 % Number of channel
    figure(i), cla
    subplot(10,1,1:7)
    image(bands_(:,:,i,band)','CDataMapping','scaled')
    colorbar
    ylabel('Participant','FontSize',15); title(sprintf('Young Theta power Channel %s',EEG1.label{i}),'FontSize',15)
    colormap('jet')
    %clim([0 10])
    subplot(10,1,8:10)
    plot(mean(bands_(:,:,i,band),2),'LineWidth',2)
    hold on
    trendline(1:size(bands_,1),mean(bands_(:,:,i,band),2),'r')
    xlabel('Trials','FontSize',15); ylabel('AVG Power Participants','FontSize',15); %title(sprintf('Older Low Beta power Chan %s',EEG1.label{i}))
end
%% Create a graph such that all wavelenghts are seen and plot all points with their line
% For the data of imagination, which is related to the amount of tiredness
POW1 = importdata('POW1ImagDe.mat');
POW2 = importdata('POW2ImagDe.mat');

info_.sampFreq = 1; % This reffers to the "sample frequency" of the data in the frequency domain
info_.freqs = [2 3 4]; % This is a vector concerning which powerbands (see the upper part) we want
info.type = 1:2; info.numM = 1:2; info.pro = 100;
bandsYoung = squeeze(compute_POW_magntiude_bands(POW1,info_));
bandsOlder = squeeze(compute_POW_magntiude_bands(POW2,info_));
bandsYoung = reshape(bandsYoung,[24*length(info.type)*length(info.numM),size(bandsYoung,1)/(24*length(info.type)*length(info.numM)),8,length(info_.freqs)]);
bandsOlder = reshape(bandsOlder,[24*length(info.type)*length(info.numM),size(bandsOlder,1)/(24*length(info.type)*length(info.numM)),8,length(info_.freqs)]);
bandsYoung = squeeze(mean(bandsYoung,2));
bandsOlder = squeeze(mean(bandsOlder,2));

for i = 1:8 % Channels
    figure(i)
    grid on
    hold on
    scatter(1:96, bandsYoung(:,i,1),'Marker','o','Color','g','MarkerFaceColor','g')
    trendline(1:96, bandsYoung(:,i,1),'g--')
    scatter(1:96, bandsOlder(:,i,1),'Marker','d','Color','g','MarkerFaceColor','g')
    trendline(1:96, bandsOlder(:,i,1),'g:')
    scatter(1:96, bandsYoung(:,i,2),'Marker','o','Color','r','MarkerFaceColor','r')
    trendline(1:96, bandsYoung(:,i,2),'r--')
    scatter(1:96, bandsOlder(:,i,2),'Marker','d','Color','r','MarkerFaceColor','r')
    trendline(1:96, bandsOlder(:,i,2),'r:')
    scatter(1:96, bandsYoung(:,i,3),'Marker','o','Color','b','MarkerFaceColor','b')
    trendline(1:96, bandsYoung(:,i,3),'b--')
    scatter(1:96, bandsOlder(:,i,3),'Marker','d','Color','b','MarkerFaceColor','b')
    trendline(1:96, bandsOlder(:,i,3),'b:')
    legend('Young Theta','Young Theta Trend','Older Theta','Older Theta Trend','Young Alpha','Young Alpha Trend','Older Alpha','Older Alpha Trend','Young low beta','Young low beta trend','Older low beta','Older low beta trend','FontSize',15)
    title(sprintf('%s',POW1.label{i}),'FontSize',15)
    ylabel('Averaged Power (\muV)','FontSize',15)
    xlabel('Window trials','FontSize',15)
end
%% Segmentate per stages and show the overall
for i = 1:8 
    figure(i)
    grid on
    hold on
    subplot(2,4,1)
    scatter(1:24, bandsYoung(1:24,i,1),'Marker','o','Color','g','MarkerFaceColor','g')
    trendline(1:24, bandsYoung(1:24,i,1),'g--')
    scatter(1:24, bandsOlder(1:24,i,1),'Marker','d','Color','g','MarkerFaceColor','g')
    trendline(1:24, bandsOlder(1:24,i,1),'g:')
    scatter(1:24, bandsYoung(1:24,i,2),'Marker','o','Color','r','MarkerFaceColor','r')
    trendline(1:24, bandsYoung(1:24,i,2),'r--')
    scatter(1:24, bandsOlder(1:24,i,2),'Marker','d','Color','r','MarkerFaceColor','r')
    trendline(1:24, bandsOlder(1:24,i,2),'r:')
    scatter(1:24, bandsYoung(1:24,i,3),'Marker','o','Color','b','MarkerFaceColor','b')
    trendline(1:24, bandsYoung(1:24,i,3),'b--')
    scatter(1:24, bandsOlder(1:24,i,3),'Marker','d','Color','b','MarkerFaceColor','b')
    trendline(1:24, bandsOlder(1:24,i,3),'b:')
    title(sprintf('First Training - %s',POW1.label{i}))
    ylabel('Averaged Power (\muV)')
    xlabel('Window trials')
    
    subplot(2,4,2)
    scatter(25:48, bandsYoung(25:48,i,1),'Marker','o','Color','g','MarkerFaceColor','g')
    trendline(25:48, bandsYoung(25:48,i,1),'g--')
    scatter(25:48, bandsOlder(25:48,i,1),'Marker','d','Color','g','MarkerFaceColor','g')
    trendline(25:48, bandsOlder(25:48,i,1),'g:')
    scatter(25:48, bandsYoung(25:48,i,2),'Marker','o','Color','r','MarkerFaceColor','r')
    trendline(25:48, bandsYoung(25:48,i,2),'r--')
    scatter(25:48, bandsOlder(25:48,i,2),'Marker','d','Color','r','MarkerFaceColor','r')
    trendline(25:48, bandsOlder(25:48,i,2),'r:')
    scatter(25:48, bandsYoung(25:48,i,3),'Marker','o','Color','b','MarkerFaceColor','b')
    trendline(25:48, bandsYoung(25:48,i,3),'b--')
    scatter(25:48, bandsOlder(25:48,i,3),'Marker','d','Color','b','MarkerFaceColor','b')
    trendline(25:48, bandsOlder(25:48,i,3),'b:')
    title(sprintf('First Online validation - %s',POW1.label{i}))
    ylabel('Averaged Power (\muV)')
    xlabel('Window trials')

    subplot(2,4,3)
    scatter(49:72, bandsYoung(49:72,i,1),'Marker','o','Color','g','MarkerFaceColor','g')
    trendline(49:72, bandsYoung(49:72,i,1),'g--')
    scatter(49:72, bandsOlder(49:72,i,1),'Marker','d','Color','g','MarkerFaceColor','g')
    trendline(49:72, bandsOlder(49:72,i,1),'g:')
    scatter(49:72, bandsYoung(49:72,i,2),'Marker','o','Color','r','MarkerFaceColor','r')
    trendline(49:72, bandsYoung(49:72,i,2),'r--')
    scatter(49:72, bandsOlder(49:72,i,2),'Marker','d','Color','r','MarkerFaceColor','r')
    trendline(49:72, bandsOlder(49:72,i,2),'r:')
    scatter(49:72, bandsYoung(49:72,i,3),'Marker','o','Color','b','MarkerFaceColor','b')
    trendline(49:72, bandsYoung(49:72,i,3),'b--')
    scatter(49:72, bandsOlder(49:72,i,3),'Marker','d','Color','b','MarkerFaceColor','b')
    trendline(49:72, bandsOlder(49:72,i,3),'b:')
    title(sprintf('Second Training - %s',POW1.label{i}))
    ylabel('Averaged Power (\muV)')
    xlabel('Window trials')

    subplot(2,4,4)
    scatter(73:96, bandsYoung(73:end,i,1),'Marker','o','Color','g','MarkerFaceColor','g')
    trendline(73:96, bandsYoung(73:end,i,1),'g--')
    scatter(73:96, bandsOlder(73:end,i,1),'Marker','d','Color','g','MarkerFaceColor','g')
    trendline(73:96, bandsOlder(73:end,i,1),'g:')
    scatter(73:96, bandsYoung(73:end,i,2),'Marker','o','Color','r','MarkerFaceColor','r')
    trendline(73:96, bandsYoung(73:end,i,2),'r--')
    scatter(73:96, bandsOlder(73:end,i,2),'Marker','d','Color','r','MarkerFaceColor','r')
    trendline(73:96, bandsOlder(73:end,i,2),'r:')
    scatter(73:96, bandsYoung(73:end,i,3),'Marker','o','Color','b','MarkerFaceColor','b')
    trendline(73:96, bandsYoung(73:end,i,3),'b--')
    scatter(73:96, bandsOlder(73:end,i,3),'Marker','d','Color','b','MarkerFaceColor','b')
    trendline(73:96, bandsOlder(73:end,i,3),'b:')
    title(sprintf('Second Online validation - %s',POW1.label{i}))
    ylabel('Averaged Power (\muV)')
    xlabel('Window trials')
    
    subplot(2,4,5:8)
    scatter(1:96, bandsYoung(:,i,1),'Marker','o','Color','g','MarkerFaceColor','g')
    trendline(1:96, bandsYoung(:,i,1),'g--')
    scatter(1:96, bandsOlder(:,i,1),'Marker','d','Color','g','MarkerFaceColor','g')
    trendline(1:96, bandsOlder(:,i,1),'g:')
    scatter(1:96, bandsYoung(:,i,2),'Marker','o','Color','r','MarkerFaceColor','r')
    trendline(1:96, bandsYoung(:,i,2),'r--')
    scatter(1:96, bandsOlder(:,i,2),'Marker','d','Color','r','MarkerFaceColor','r')
    trendline(1:96, bandsOlder(:,i,2),'r:')
    scatter(1:96, bandsYoung(:,i,3),'Marker','o','Color','b','MarkerFaceColor','b')
    trendline(1:96, bandsYoung(:,i,3),'b--')
    scatter(1:96, bandsOlder(:,i,3),'Marker','d','Color','b','MarkerFaceColor','b')
    trendline(1:96, bandsOlder(:,i,3),'b:')
    %legend('Young Theta','Young Theta Trend','Older Theta','Older Theta Trend','Young Alpha','Young Alpha Trend','Older Alpha','Older Alpha Trend','Young low beta','Young low beta trend','Older low beta','Older low beta trend')
    title(sprintf('All stages - %s',POW1.label{i}))
    ylabel('Averaged Power (\muV)')
    xlabel('Window trials')
end
%% Segmentate per stages, don't show the overall
for i = 1:8 
    figure(i)
    grid on
    hold on
    subplot(1,4,1)
    scatter(1:24, bandsYoung(1:24,i,1),'Marker','o','Color','g','MarkerFaceColor','g')
    trendline(1:24, bandsYoung(1:24,i,1),'g--')
    scatter(1:24, bandsOlder(1:24,i,1),'Marker','d','Color','g','MarkerFaceColor','g')
    trendline(1:24, bandsOlder(1:24,i,1),'g:')
    scatter(1:24, bandsYoung(1:24,i,2),'Marker','o','Color','r','MarkerFaceColor','r')
    trendline(1:24, bandsYoung(1:24,i,2),'r--')
    scatter(1:24, bandsOlder(1:24,i,2),'Marker','d','Color','r','MarkerFaceColor','r')
    trendline(1:24, bandsOlder(1:24,i,2),'r:')
    scatter(1:24, bandsYoung(1:24,i,3),'Marker','o','Color','b','MarkerFaceColor','b')
    trendline(1:24, bandsYoung(1:24,i,3),'b--')
    scatter(1:24, bandsOlder(1:24,i,3),'Marker','d','Color','b','MarkerFaceColor','b')
    trendline(1:24, bandsOlder(1:24,i,3),'b:')
    title(sprintf('First Training - %s',POW1.label{i}),'FontSize',15)
    ylabel('Averaged Power (\muV)','FontSize',15)
    xlabel('Window trials','FontSize',15)
    
    subplot(1,4,2)
    scatter(25:48, bandsYoung(25:48,i,1),'Marker','o','Color','g','MarkerFaceColor','g')
    trendline(25:48, bandsYoung(25:48,i,1),'g--')
    scatter(25:48, bandsOlder(25:48,i,1),'Marker','d','Color','g','MarkerFaceColor','g')
    trendline(25:48, bandsOlder(25:48,i,1),'g:')
    scatter(25:48, bandsYoung(25:48,i,2),'Marker','o','Color','r','MarkerFaceColor','r')
    trendline(25:48, bandsYoung(25:48,i,2),'r--')
    scatter(25:48, bandsOlder(25:48,i,2),'Marker','d','Color','r','MarkerFaceColor','r')
    trendline(25:48, bandsOlder(25:48,i,2),'r:')
    scatter(25:48, bandsYoung(25:48,i,3),'Marker','o','Color','b','MarkerFaceColor','b')
    trendline(25:48, bandsYoung(25:48,i,3),'b--')
    scatter(25:48, bandsOlder(25:48,i,3),'Marker','d','Color','b','MarkerFaceColor','b')
    trendline(25:48, bandsOlder(25:48,i,3),'b:')
    title(sprintf('First Online validation - %s',POW1.label{i}),'FontSize',15)
    ylabel('Averaged Power (\muV)','FontSize',15)
    xlabel('Window trials','FontSize',15)

    subplot(1,4,3)
    scatter(49:72, bandsYoung(49:72,i,1),'Marker','o','Color','g','MarkerFaceColor','g')
    trendline(49:72, bandsYoung(49:72,i,1),'g--')
    scatter(49:72, bandsOlder(49:72,i,1),'Marker','d','Color','g','MarkerFaceColor','g')
    trendline(49:72, bandsOlder(49:72,i,1),'g:')
    scatter(49:72, bandsYoung(49:72,i,2),'Marker','o','Color','r','MarkerFaceColor','r')
    trendline(49:72, bandsYoung(49:72,i,2),'r--')
    scatter(49:72, bandsOlder(49:72,i,2),'Marker','d','Color','r','MarkerFaceColor','r')
    trendline(49:72, bandsOlder(49:72,i,2),'r:')
    scatter(49:72, bandsYoung(49:72,i,3),'Marker','o','Color','b','MarkerFaceColor','b')
    trendline(49:72, bandsYoung(49:72,i,3),'b--')
    scatter(49:72, bandsOlder(49:72,i,3),'Marker','d','Color','b','MarkerFaceColor','b')
    trendline(49:72, bandsOlder(49:72,i,3),'b:')
    title(sprintf('Second Training - %s',POW1.label{i}),'FontSize',15)
    ylabel('Averaged Power (\muV)','FontSize',15)
    xlabel('Window trials','FontSize',15)

    subplot(1,4,4)
    scatter(73:96, bandsYoung(73:end,i,1),'Marker','o','Color','g','MarkerFaceColor','g')
    trendline(73:96, bandsYoung(73:end,i,1),'g--')
    scatter(73:96, bandsOlder(73:end,i,1),'Marker','d','Color','g','MarkerFaceColor','g')
    trendline(73:96, bandsOlder(73:end,i,1),'g:')
    scatter(73:96, bandsYoung(73:end,i,2),'Marker','o','Color','r','MarkerFaceColor','r')
    trendline(73:96, bandsYoung(73:end,i,2),'r--')
    scatter(73:96, bandsOlder(73:end,i,2),'Marker','d','Color','r','MarkerFaceColor','r')
    trendline(73:96, bandsOlder(73:end,i,2),'r:')
    scatter(73:96, bandsYoung(73:end,i,3),'Marker','o','Color','b','MarkerFaceColor','b')
    trendline(73:96, bandsYoung(73:end,i,3),'b--')
    scatter(73:96, bandsOlder(73:end,i,3),'Marker','d','Color','b','MarkerFaceColor','b')
    trendline(73:96, bandsOlder(73:end,i,3),'b:')
    title(sprintf('Second Online validation - %s',POW1.label{i}),'FontSize',15)
    ylabel('Averaged Power (\muV)','FontSize',15)
    xlabel('Window trials','FontSize',15)
    
    %legend('Young Theta','Young Theta Trend','Older Theta','Older Theta Trend','Young Alpha','Young Alpha Trend','Older Alpha','Older Alpha Trend','Young low beta','Young low beta trend','Older low beta','Older low beta trend')
end
