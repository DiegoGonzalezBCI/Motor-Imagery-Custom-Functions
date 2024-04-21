function STAT2 = PermutationTestERP_BCIHOH(EEG1, EEG2)
%% Program to perform time-analysis for ERP
% Inputs are:
% - EEG1Rest_2 (cleaned and downsampled)
% - EEG2Rest_2 (cleaned and downsampled)
% - EEG1Imag_2 (cleaned and downsampled)
% - EEG2Imag_2 (cleaned and downsampled)
% - EEG1Beep_2 (cleaned and downsampled)
% - EEG2Beep_2 (cleaned and downsampled)

% Outputs are:
% Statistical Tests for each data based on:
% PERMUTATION TEST USING AS STATISTIC THE INDEPENDENT SAMPLES (2B)
% Plots for each data
% Code rescued from P23_ERP_CompareConditions, from javiermao git
load MyLayout.mat
layout = MyLayout;
TimePeaksC1 = [0.2 0.5 1.1]';

% Compute average
cfg                  = [];
cfg.keeptrials       = 'no';
AVG1                 = ft_timelockanalysis(cfg, EEG1);
AVG2                 = ft_timelockanalysis(cfg, EEG2);

cfg                  = [];
STAT2                = Compute_EEG1vsEEG2significantdifferences(cfg, EEG1, EEG2); 

% ---------------------------------------------
% Plot significant differences between the two conditions
cfg                  = [];
cfg.LineWidth        = 2;
cfg.alpha            = 0.005;
cfg.bonferroni       = 'no';
cfg.ichan            = 3;
cfg.Legend1          = 'Q1';
cfg.Legend2          = 'Q2';
cfg.layout           = layout;
cfg.time2plot        = TimePeaksC1(1);
Compute_EEG1vsEEG2significantdifferencesPlot(cfg, AVG1, AVG2, STAT2)

end