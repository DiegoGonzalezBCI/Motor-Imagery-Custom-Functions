function [EEG1,EEG2,POW1,POW2,POW1Avg,POW2Avg] = divisionBCIHOH(info)

% Declare some infos to extract data (Do not change)
info.fs = 256; % Sampling Frequency
info.cutoff = [4 30]; % Bandpass filter
info.pow = 0; % Compute power: 1: Yes, 0: No

% Divide the study into a series of different compairson approaches
info.YvsO = 1:2; % 1: Young Group, 2: Older Group
info.chan = 1:8; % 1: C3, 2: C1 3: Cz, 4: C2, 5: C4, 6: CP3, 7: CPz, 8: CP4

% info.event = 1; % 1: Rest, 2: Imagination, 3: Beep (mutually exclusive variable)
% info.type = 1; % 1: Training, 2: Online Validation
% info.numM = 1; % 1: First moment, 2: Second moment

% Declare which participants should partake in the analysis
info.pro = 0; % Percentage of the maximal popullation to partake in the study (people with more or less age); if let 0 then specified number of participant in info.par

% info.par = 1; % exact number of the participant(s) to inspectionate, info.pro must be 0 for this option to be able

if info.event == 1
    info.at = -1; % Seconds before (negative numbers refers to positive time shifting)
    info.wt = 2; % Seconds after, be aware that 256*(1+0.5) must be an integer
    if sum(info.type) == 1
        info.pivot = [100 0]; % This refers to the marks of each stage, in case that info.type = 1:2 is, two numbers must be specified for each stage
    elseif sum(info.type) == 2
        info.pivot = [0 201]; % This refers to the marks of each stage, in case that info.type = 1:2 is, two numbers must be specified for each stage
    elseif sum(info.type) == 3
        info.pivot = [100 201]; % This refers to the marks of each stage, in case that info.type = 1:2 is, two numbers must be specified for each stage
    end
elseif info.event == 2
    info.at = 0; % Seconds before (negative numbers refers to positive time shifting)
    info.wt = 1; % Seconds after, be aware that 256*(1+0.5) must be an integer
    if sum(info.type) == 1
        info.pivot = [101 0]; % This refers to the marks of each stage, in case that info.type = 1:2 is, two numbers must be specified for each stage
    elseif sum(info.type) == 2
        info.pivot = [0 101]; % This refers to the marks of each stage, in case that info.type = 1:2 is, two numbers must be specified for each stage
    elseif sum(info.type) == 3
        info.pivot = [101 101]; % This refers to the marks of each stage, in case that info.type = 1:2 is, two numbers must be specified for each stage
    end
elseif info.event == 3
    info.at = 0.5; % Seconds before (negative numbers refers to positive time shifting)
    info.wt = 1; % Seconds after, be aware that 256*(1+0.5) must be an integer
    if sum(info.type) == 1
        info.pivot = [203 0]; % This refers to the marks of each stage, in case that info.type = 1:2 is, two numbers must be specified for each stage
    elseif sum(info.type) == 2
        info.pivot = [0 203]; % This refers to the marks of each stage, in case that info.type = 1:2 is, two numbers must be specified for each stage
    elseif sum(info.type) == 3
        info.pivot = [203 203]; % This refers to the marks of each stage, in case that info.type = 1:2 is, two numbers must be specified for each stage
    end
end

if sum(info.YvsO) == 1
    [EEG1,EEG2,POW1,POW2,POW1Avg,POW2Avg] = segmentationTrainingAgesBeep(info);
elseif sum(info.YvsO) == 2
    [EEG1,EEG2,POW1,POW2,POW1Avg,POW2Avg] = segmentationTrainingAgesBeep(info);
elseif sum(info.YvsO) == 3
    [EEG1,EEG2,POW1,POW2,POW1Avg,POW2Avg] = segmentationTrainingAgesBeep(info);
end

end