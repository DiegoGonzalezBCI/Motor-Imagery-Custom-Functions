%% This is an example of the usage of the segmentation of trials using marks information
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