init__ = "main__";

if init__ == "main__"
    x = input("To clean data enter 1\nTo downsample data enter 2\nTo perform ERP analysis enter 3\n");
    % 1: To clean data
    % 2: To downsample data
    % 3: To perform Time-domain analysis of ERP
    
    if x == 1
        info.fs             = 256; % frequency rate of the data
        info.type           = 1:2; % Types of moments to partake (training == 1 & validation == 2)
        info.numM           = 1:2; % Number of moments to partake (first T, first V, second T, second V) 1: only the first training and validation, 2: only the second training and validation; [1 2]: both
        info.YvsO           = 1:2; % Types of participants (young == 1) (old == 2) (young and old == [1 2])
        info.pro            = 0; % Percentage of the maximal popullation to partake in the study (if 0, then number of participants specified in the list "par" is used, mind types of participants "YvsO" (Y € [1 30], O € [31 60])
        info.par            = 1:60; % Number of participants to partake in the study
        info.pow            = 0;
        info.chan           = 1:8;
        info.at             = 0; % seconds before the occurrance of the event
        info.wt             = 1; % seconds after the occurrance of the event MAKE SURE THAT 256*(wt + at) is an integer
        info.cutoff         = [1 30]; % cutoff frequency for the bandpass filter
        info.pivot          = [100 201]; % To specifically find Fixation Cross
        [EEG1Rest,EEG2Rest] = segmentationTrainingAgesBeep(info);
        cfg.umbralVpp       = 200;
        cfg.umbralVstd      = 50;
        cfg.doplot          = 0;
        EEG1Rest_clean      = Compute_NoisyTrialsRemove(cfg,EEG1Rest);
        EEG2Rest_clean      = Compute_NoisyTrialsRemove(cfg,EEG2Rest);

        info.pivot          = [101 101]; % To specifically find Test Time
        [EEG1Imag,EEG2Imag] = segmentationTrainingAgesBeep(info);
        EEG1Imag_clean      = Compute_NoisyTrialsRemove(cfg,EEG1Imag);
        EEG2Imag_clean      = Compute_NoisyTrialsRemove(cfg,EEG2Imag);

        info.at             = 0.5; % seconds before the occurrance of the event
        info.wt             = 1; % seconds after the occurrance of the event MAKE SURE THAT 256*(wt + at) is an integer
        info.cutoff         = [1 30]; % cutoff frequency for the bandpass filter
        info.pivot          = [203 203]; % To specifically find Preparation (beep)
        [EEG1Beep, EEG2Beep]= segmentationTrainingAgesBeep(info);
        EEG1Beep_clean      = Compute_NoisyTrialsRemove(cfg,EEG1Beep);
        EEG2Beep_clean      = Compute_NoisyTrialsRemove(cfg,EEG2Beep);

        save('/Users/gabygoga/Desktop/Programming/MyToolbox2/NewStoredData/EEG1Rest_1','EEG1Rest_clean');
        save('/Users/gabygoga/Desktop/Programming/MyToolbox2/NewStoredData/EEG2Rest_1','EEG2Rest_clean');
        save('/Users/gabygoga/Desktop/Programming/MyToolbox2/NewStoredData/EEG1Imag_1','EEG1Imag_clean');
        save('/Users/gabygoga/Desktop/Programming/MyToolbox2/NewStoredData/EEG2Imag_1','EEG2Imag_clean');
        save('/Users/gabygoga/Desktop/Programming/MyToolbox2/NewStoredData/EEG1Beep_1','EEG1Beep_clean');
        save('/Users/gabygoga/Desktop/Programming/MyToolbox2/NewStoredData/EEG2Beep_1','EEG2Beep_clean');
    end
    if x == 2
        load EEG1Rest_1
        load EEG2Rest_1
        load EEG1Imag_1
        load EEG2Imag_1
        load EEG1Beep_1
        load EEG2Beep_1
        
        EEGData             = {EEG1Rest_clean, EEG2Rest_clean, EEG1Imag_clean, EEG2Imag_clean, EEG1Beep_clean, EEG2Beep_clean};
        
        for i = 1 : length(EEGData)
            EEG             = EEGData{i};
            for j = 1 : length(EEG.trial)
                trial       = EEG.trial{j}';
                time        = EEG.time{j}';
                trial       = downsample(trial,4)';
                time        = downsample(time,4)';
                EEG.trial{j}= trial;
                EEG.time{j} = time;
                EEG.fsample = 64;
            end
            EEGData{i}      = EEG;
        end
        [EEG1Rest_down, EEG2Rest_down, EEG1Imag_down, EEG2Imag_down, EEG1Beep_down, EEG2Beep_down] = deal(EEGData{1}, EEGData{2}, EEGData{3}, EEGData{4}, EEGData{5}, EEGData{6});

        save('/Users/gabygoga/Desktop/Programming/MyToolbox2/NewStoredData/EEG1Rest_2','EEG1Rest_down');
        save('/Users/gabygoga/Desktop/Programming/MyToolbox2/NewStoredData/EEG2Rest_2','EEG2Rest_down');
        save('/Users/gabygoga/Desktop/Programming/MyToolbox2/NewStoredData/EEG1Imag_2','EEG1Imag_down');
        save('/Users/gabygoga/Desktop/Programming/MyToolbox2/NewStoredData/EEG2Imag_2','EEG2Imag_down');
        save('/Users/gabygoga/Desktop/Programming/MyToolbox2/NewStoredData/EEG1Beep_2','EEG1Beep_down');
        save('/Users/gabygoga/Desktop/Programming/MyToolbox2/NewStoredData/EEG2Beep_2','EEG2Beep_down');
    end
    if x == 3
        load EEG1Beep_2
        load EEG2Beep_2

        STAT2 = PermutationTestERP_BCIHOH(EEG1Beep_down, EEG2Beep_down);
    end
end