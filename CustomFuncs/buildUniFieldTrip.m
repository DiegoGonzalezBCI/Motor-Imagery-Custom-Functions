function [EEG1, POW1, POW1Avg] = buildUniFieldTrip(tensor, PSD, nuances)
    % This function computes the PSD from the data stored in tensor
    % Tensor is a double with dim: (channels, samples, trials)
    % PSD is 1 or 0 depending if you want to compute PSD or just build the
    % data structure needed to use FieldTrip
    % Nuances has some details from the data
    Ntrials = nuances.Ntrials;
    fsample = nuances.fsample;
    timeSampled = nuances.timeSampled;
    chan = nuances.chan;
    maxfrec = nuances.maxfrec;

    for i=1:Ntrials

        MyTrials4Fieldtrip100{i}(:,:) = tensor(:,:,i);

        MyTime4Fieldtrip{i}       = 0:1/fsample:timeSampled-1/fsample;

    end

    EEG1          = [];

    EEG1.fsample  = fsample;

    EEG1.label    = chan;

    EEG1.time     = MyTime4Fieldtrip;

    EEG1.trial    = MyTrials4Fieldtrip100;

    if PSD == 1
        % Compute PSD
        cfg                       = [];
        cfg.keeptrials            = 'yes';
        cfg.output                = 'pow';
        cfg.method                = 'mtmfft';
        cfg.taper                 = 'dpss'; % ('dpss','hanning') ???
        cfg.foi                   = 0:0.25:maxfrec; % For the BCI+HOH this starts at 6 and end in 40
        cfg.tapsmofrq             = 2;
        POW1                      = ft_freqanalysis(cfg,EEG1);

        % ----------------------------------------------
        % Compute PSD average
        cfg                       = [];
        cfg.variance              = 'yes';
        POW1Avg                   = ft_freqdescriptives(cfg,POW1);

    end

end