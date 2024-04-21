function [POW1Avg, POW2Avg, POW1, POW2] = fieldPSD(EEG1, EEG2, graph, prettier)

% Compute PSD
cfg                       = [];
cfg.keeptrials            = 'yes';
cfg.output                = 'pow';
cfg.method                = 'mtmfft';
cfg.taper                 = 'dpss'; % ('dpss','hanning')
cfg.foi                   = 0:0.25:40; % For the BCI+HOH this starts at 6
cfg.tapsmofrq             = 2;
POW1                      = ft_freqanalysis(cfg,EEG1);
POW2                      = ft_freqanalysis(cfg,EEG2);

% ----------------------------------------------
% Compute PSD average
cfg                       = [];
cfg.variance              = 'yes';
POW1Avg                   = ft_freqdescriptives(cfg,POW1);
POW2Avg                   = ft_freqdescriptives(cfg,POW2);

%% %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLOT PSD AVERAGE OF ONE CHANNEL IN THE TWO CONDITIONS

% ----------------------------------------------
% Select a channel
% ichan = 7;
% 
% % ----------------------------------------------
% % Plot PSD of the selected channel in the two conditions
% figure, clf,  hold on
% plot(POW1Avg.freq,POW1Avg.powspctrm(ichan,:),'LineWidth',2)
% plot(POW2Avg.freq,POW2Avg.powspctrm(ichan,:),'LineWidth',2)
% xlabel('Frequency (Hz)')
% ylabel('Power (\muV^2/Hz)')
% title(POW1Avg.label(ichan))
% legend('Relax','MI','EdgeColor','None','Color','None')
% grid on, box on
% set(gca,'FontSize',12)
 
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLOT PSD AVERAGE OF ALL CHANNELS IN THE TWO CONDITIONS
% AVERAGE ACROSS TRIALS
% ----------------------------------------------
% 
if graph == 1
figure, clf,  hold on
if prettier == 1
    for i = [1 3 5 6 7 8]
        ichan = i;
        if i >= 3 && i < 5
            i = i - 1;
        elseif i >= 5
            i = i - 2;
        end
        subplot(2,3,i), hold on
        plot(POW1Avg.freq,POW1Avg.powspctrm(ichan,:),'LineWidth',2)
        plot(POW2Avg.freq,POW2Avg.powspctrm(ichan,:),'LineWidth',2)
        xlabel('Frequency (Hz)')
        ylabel('Power (\muV^2/Hz)')
        title(POW1Avg.label(ichan))
        legend('Relajación','Imaginación','FontSize',5,'EdgeColor','None','Color','None')
        grid on, box on
        set(gca,'FontSize',12)
    end
else
for i = 1:8
    ichan = i;
    if i <= 5
        subplot(2,5,i), hold on
    else
        subplot(2,5,i+1), hold on
    end
    if size(POW1Avg.powspctrm,1) >= i
    plot(POW1Avg.freq,POW1Avg.powspctrm(ichan,:),'LineWidth',2)
    end
    if size(POW2Avg.powspctrm,1) >= i
    plot(POW2Avg.freq,POW2Avg.powspctrm(ichan,:),'LineWidth',2)
    end
    xlabel('Frequency (Hz)')
    ylabel('Power (\muV^2/Hz)')
    title(POW2Avg.label(ichan))
    legend('Rest','MI','FontSize',5,'EdgeColor','None','Color','None')
    grid on, box on
    set(gca,'FontSize',12)
end
end
end

end