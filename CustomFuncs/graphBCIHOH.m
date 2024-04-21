%% This programms aims to graph important figures to be presented in the BCI+HOH experiment
EEG1 = importdata('EEG1Beep.mat');
EEG2 = importdata('EEG2Beep.mat');
%% See just 1 trial in time
%
%EEG1Beep = EEG1;
%EEG2Beep = EEG2;
%
trial = 85;
%trial = 1:1440;
each_independently = 0;
for l = trial
    if each_independently == 1
    for k = 1:2
        if k == 1
            EEG = EEG1;
            figure(1)
        else
            EEG = EEG2;
            figure(2)
        end
        for i = 1:8
            switch i
                case 1
                    subplot(2,5,i)
                case 2
                    subplot(2,5,i)
                case 3
                    subplot(2,5,i)
                case 4
                    subplot(2,5,i)
                case 5
                    subplot(2,5,i)
                case 6
                    subplot(2,5,i+1)
                case 7
                    subplot(2,5,i+1)
                case 8
                    subplot(2,5,i+1)
            end
            plot(EEG.time{1}-0.5,EEG.trial{l}(i,:)','LineWidth',2)
            title(EEG.label{i})
            xlabel('Time (s)'); ylabel('Amplitude \muV'); xline(0)
            grid on
        end
        if k == 1
            sgtitle(sprintf('ERP YOUNG BEEP %d',l))
        else
            sgtitle(sprintf('ERP OLD BEEP %d',l))
        end
    end
    end
    figure(3)
    hold off
    for i = 1:8
            switch i
                case 1
                    subplot(2,5,i)
                case 2
                    subplot(2,5,i)
                case 3
                    subplot(2,5,i)
                case 4
                    subplot(2,5,i)
                case 5
                    subplot(2,5,i)
                case 6
                    subplot(2,5,i+1)
                case 7
                    subplot(2,5,i+1)
                case 8
                    subplot(2,5,i+1)
            end
            plot(EEG1.time{1}-0.5,EEG1.trial{l}(i,:)','Color','b','LineWidth',2)
            hold on
            plot(EEG1.time{1}-0.5,EEG2.trial{l}(i,:)','Color','r','LineWidth',2)
            legend('Young','Old')
            title(EEG1.label{i})
            xlabel('Time (s)'); ylabel('Amplitude \muV'); xline(0)
            grid on
    end
    hold off
    sgtitle(sprintf('Compairson %d',l))
    pause(0.1)
end
%% See all trials averaged
cfg                  = [];
cfg.keeptrials       = 'no';
AVG1                 = ft_timelockanalysis(cfg, EEG1);
AVG2                 = ft_timelockanalysis(cfg, EEG2);
for k = 1:2
    if k == 1
        AVG = AVG1;
        figure(1)
    else
        AVG = AVG2;
        figure(2)
    end
for i = 1:8
    switch i
        case 1
            subplot(2,5,i)
        case 2
            subplot(2,5,i)
        case 3
            subplot(2,5,i)
        case 4
            subplot(2,5,i)
        case 5
            subplot(2,5,i)
        case 6
            subplot(2,5,i+1)
        case 7
            subplot(2,5,i+1)
        case 8
            subplot(2,5,i+1)
    end
    plot(AVG.time-0.5,AVG.avg(i,:)','LineWidth',2)
    title(AVG.label{i})
    xlabel('Time (s)'); ylabel('Amplitude \muV'); xline(0)
    grid on
end
if k == 1
    sgtitle('ERP YOUNG BEEP')
else
    sgtitle('ERP OLD BEEP')
end
end
%% Graph per 1 participant their PSD
trials = 100;
%trials = 1:1440;
for j = trials
    for k = 1:2
        if k == 1
            POW = POW1;
            figure(1)
        else
            POW = POW2;
            figure(2)
        end
        for i = 1:8
            switch i
        case 1
            subplot(2,5,i)
        case 2
            subplot(2,5,i)
        case 3
            subplot(2,5,i)
        case 4
            subplot(2,5,i)
        case 5
            subplot(2,5,i)
        case 6
            subplot(2,5,i+1)
        case 7
            subplot(2,5,i+1)
        case 8
            subplot(2,5,i+1)
            end
            plot(POW.freq,squeeze(POW.powspctrm(j,i,:))','LineWidth',2)
            title(AVG.label{i})
            xlabel('Time (s)'); ylabel('Amplitude \muV'); xline(0)
            grid on
        end
    end
end
%% Graph all participants AVG their PSD
fieldPSD(EEG1, EEG2, 1, 0)
%% Graph all participants AVG their PSD
POW1Rest = importdata('POW1Rest.mat');
POW2Rest = importdata('POW2Rest.mat');
POW1Imag = importdata('POW1Imag.mat');
POW2Imag = importdata('POW2Imag.mat');
prettier = 0;
denoise = 1;
noisy_participants = {[1 7 12 23 27],[7 8 9 23 27],[12 18 22 28],[5 13 18 19]};
if denoise == 1
    cfg                       = [];
    cfg.variance              = 'yes';
    for i = 1:4
        switch i
            case 1
                for j = length(noisy_participants{i}):-1:1
                POW1Rest.powspctrm(96*(noisy_participants{i}(j)-1)+1:96*noisy_participants{i}(j),:,:) = [];
                POW1Rest.cumsumcnt(96*(noisy_participants{i}(j)-1)+1:96*noisy_participants{i}(j),:,:) = [];
                end
            case 2
                for j = length(noisy_participants{i}):-1:1
                POW1Imag.powspctrm(96*(noisy_participants{i}(j)-1)+1:96*noisy_participants{i}(j),:,:) = [];
                POW1Imag.cumsumcnt(96*(noisy_participants{i}(j)-1)+1:96*noisy_participants{i}(j),:,:) = [];
                end
            case 3
                for j = length(noisy_participants{i}):-1:1
                POW2Rest.powspctrm(96*(noisy_participants{i}(j)-1)+1:96*noisy_participants{i}(j),:,:) = [];
                POW2Rest.cumsumcnt(96*(noisy_participants{i}(j)-1)+1:96*noisy_participants{i}(j),:,:) = [];
                end
            case 4
                for j = length(noisy_participants{i}):-1:1
                POW2Imag.powspctrm(96*(noisy_participants{i}(j)-1)+1:96*noisy_participants{i}(j),:,:) = [];
                POW2Imag.cumsumcnt(96*(noisy_participants{i}(j)-1)+1:96*noisy_participants{i}(j),:,:) = [];
                end
        end
    end
    POW1AvgRest       = ft_freqdescriptives(cfg,POW1Rest);
    POW1AvgImag       = ft_freqdescriptives(cfg,POW1Imag);
    POW2AvgRest       = ft_freqdescriptives(cfg,POW2Rest);
    POW2AvgImag       = ft_freqdescriptives(cfg,POW2Imag);
end
%%
POW1AvgRest = importdata('POW1AvgRestDe.mat');
POW2AvgRest = importdata('POW2AvgRestDe.mat');
POW1AvgImag = importdata('POW1AvgImagDe.mat');
POW2AvgImag = importdata('POW2AvgImagDe.mat');
clf,  hold on
if prettier == 1
    for i = [1 3 5 6 7 8]
        ichan = i;
        if i >= 3 && i < 5
            i = i - 1;
        elseif i >= 5
            i = i - 2;
        end
        figure(1)
        subplot(2,3,i)
        plot(POW1AvgRest.freq,POW1AvgRest.powspctrm(ichan,:),'LineWidth',2)
        hold on
        plot(POW1AvgImag.freq,POW1AvgImag.powspctrm(ichan,:),'LineWidth',2)
        xlabel('Frequency (Hz)')
        ylabel('Power (\muV^2/Hz)')
        title(POW1AvgRest.label(ichan))
        legend('Relaxation','Imagination','FontSize',5,'EdgeColor','None','Color','None','FontSize',15)
        grid on, box on
        set(gca,'FontSize',12)
        sgtitle('Young Participants','FontSize',15)
        figure(2)
        subplot(2,3,i)
        plot(POW2AvgRest.freq,POW2AvgRest.powspctrm(ichan,:),'LineWidth',2)
        hold on
        plot(POW2AvgImag.freq,POW2AvgImag.powspctrm(ichan,:),'LineWidth',2)
        xlabel('Frequency (Hz)')
        ylabel('Power (\muV^2/Hz)')
        title(POW2AvgRest.label(ichan))
        legend('Relaxation','Imagination','FontSize',5,'EdgeColor','None','Color','None','FontSize',15)
        grid on, box on
        set(gca,'FontSize',12)
        sgtitle('Elderly Participants','FontSize',15)
    end
else
for i = 1:8
    ichan = i;
    if i <= 5
        hold on
    else
        ichan = ichan + 1; hold on
    end
    figure(1)
    subplot(2,5,ichan)
    plot(POW1AvgRest.freq,POW1AvgRest.powspctrm(i,:),'LineWidth',2)
    hold on
    plot(POW1AvgImag.freq,POW1AvgImag.powspctrm(i,:),'LineWidth',2)
    xlabel('Frequency (Hz)')
    ylabel('Power (\muV^2/Hz)')
    title(POW1AvgRest.label(i))
    legend('Relaxation','Imagination','FontSize',5,'EdgeColor','None','Color','None','FontSize',12)
    grid on, box on
    set(gca,'FontSize',12)
    sgtitle('Young Participants','FontSize',15)
    figure(2)
    subplot(2,5,ichan)
    plot(POW2AvgRest.freq,POW2AvgRest.powspctrm(i,:),'LineWidth',2)
    hold on
    plot(POW2AvgImag.freq,POW2AvgImag.powspctrm(i,:),'LineWidth',2)
    xlabel('Frequency (Hz)')
    ylabel('Power (\muV^2/Hz)')
    title(POW2AvgRest.label(i))
    legend('Relaxation','Imagination','FontSize',5,'EdgeColor','None','Color','None','FontSize',12)
    grid on, box on
    set(gca,'FontSize',12)
    sgtitle('Elderly Participants','FontSize',15)
end
end
%%
AVG1P300 = importdata('AVG1P300.mat');
AVG2P300 = importdata('AVG2P300.mat');
clf,  hold on
if prettier == 1
    for i = [1 3 5 6 7 8]
        ichan = i;
        if i >= 3 && i < 5
            i = i - 1;
        elseif i >= 5
            i = i - 2;
        end
        figure(1)
        subplot(2,3,i)
        plot(AVG1P300.time,AVG1P300.avg(ichan,:),'LineWidth',2)
        hold on
        plot(AVG2P300.time,AVG2P300.avg(ichan,:),'LineWidth',2)
        xticks(0.1:0.2:1.5); xticklabels({'-0.4','-0.2','0','0.2','0.4','0.6','0.8','1'})
        xlabel('Time (s)')
        ylabel('Magnitude (\muV)')
        xline(0.5)
        [val,indx] = max(AVG1P300.avg(ichan,128:end));
        xline(indx/256+0.5,'Color','b','LineWidth',2,'LineStyle',':')
        [val,indx] = max(AVG2P300.avg(ichan,128:end));
        xline(indx/256+0.5,'Color','r','LineWidth',2,'LineStyle',':')
        title(AVG1P300.label(ichan))
        legend('Young','Elderly','FontSize',5,'EdgeColor','None','Color','None','FontSize',12)
        grid on, box on
        set(gca,'FontSize',12)
        sgtitle('P300 Response','FontSize',15)
    end
else
for i = 1:8
    ichan = i;
    if i <= 5
        hold on
    else
        ichan = ichan + 1; hold on
    end
    figure(1)
    subplot(2,5,ichan)
    plot(AVG1P300.time,AVG1P300.avg(i,:),'LineWidth',2)
    hold on
    plot(AVG2P300.time,AVG2P300.avg(i,:),'LineWidth',2)
    xticks(0.1:0.2:1.5); xticklabels({'-0.4','-0.2','0','0.2','0.4','0.6','0.8','1'})
    xlabel('Time (s)')
    ylabel('Magnitude (\muV)')
    xline(0.5)
    [val,indx] = max(AVG1P300.avg(i,128:end));
    xline(indx/256+0.5,'Color','b','LineWidth',2,'LineStyle',':')
    [val,indx] = max(AVG2P300.avg(i,128:end));
    xline(indx/256+0.5,'Color','r','LineWidth',2,'LineStyle',':')
    title(AVG1P300.label(i))
    legend('Young','Elderly','FontSize',5,'EdgeColor','None','Color','None','FontSize',12)
    grid on, box on
    set(gca,'FontSize',12)
    sgtitle('P300 Response','FontSize',15)
end
end
%% Compute wavelength decrease (desynchrnozation) for theta, alpha, and low beta between young and elderly
POW1Rest = importdata('POW1RestDe.mat');
POW2Rest = importdata('POW2RestDe.mat');
POW1Imag = importdata('POW1ImagDe.mat');
POW2Imag = importdata('POW2ImagDe.mat');

info.sampFreq = 1; % This reffers to the "sample frequency" of the data in the frequency domain
info.freqs = [2 3 4]; % This is a vector concerning which powerbands (see the upper part) we want
bands1Rest = squeeze(mean(compute_POW_magntiude_bands(POW1Rest,info)));
bands2Rest = squeeze(mean(compute_POW_magntiude_bands(POW2Rest,info)));
bands1Imag = squeeze(mean(compute_POW_magntiude_bands(POW1Imag,info)));
bands2Imag = squeeze(mean(compute_POW_magntiude_bands(POW2Imag,info)));

desYouth = abs(100*((bands1Imag - bands1Rest)./bands1Rest));
desOlder = abs(100*((bands2Imag - bands2Rest)./bands2Rest));

figure
X = categorical({'\theta','\alpha','Low \beta'});
X = reordercats(X,{'\theta','\alpha','Low \beta'});
if prettier == 0
for i = 1:8
    if i <= 5
        subplot(2,5,i)
    else
        subplot(2,5,i+1)
    end
        bar(X,[desYouth(i,1) desOlder(i,1); desYouth(i,2) desOlder(i,2); desYouth(i,3) desOlder(i,3)])
        set(gca,'FontSize',15)
        ylabel('D%','FontSize',15)
        legend('Young','Elderly','FontSize',10)
        title(sprintf('%s',POW1Rest.label{i}),'FontSize',12)
        sgtitle('Desynchronization Percentage','FontSize',18)
end
else
for i = [1 3 5 6 7 8]
        ichan = i;
        if i >= 3 && i < 5
            i = i - 1;
        elseif i >= 5
            i = i - 2;
        end
        subplot(2,3,i)
        bar(X,[desYouth(ichan,1) desOlder(ichan,1); desYouth(ichan,2) desOlder(ichan,2); desYouth(ichan,3) desOlder(ichan,3)])
        set(gca,'FontSize',15)
        ylabel('D%','FontSize',15)
        legend('Young','Elderly','FontSize',10)
        title(sprintf('%s',POW1Rest.label{ichan}),'FontSize',12)
        sgtitle('Desynchronization Percentage','FontSize',18)
end
end