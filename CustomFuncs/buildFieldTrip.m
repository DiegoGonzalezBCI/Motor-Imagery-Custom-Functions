function [EEG1, EEG2] = buildFieldTrip(t100,t101,nuances)
% Codigo para construir las celdas de los trials:

Ntrials = nuances.Ntrials;
fsample = nuances.fsample;
timeSampled = nuances.timeSampled;
chan = nuances.chan;

% Ntrials = 5;
% fsample = 250;
% timeSampled = 30;
% chan = {'C3';'C1';'Cz';'C2';'C4';'CP3';'CPz';'CP4'};

for i=1:Ntrials

MyTrials4Fieldtrip100{i}(:,:) = t100(:,:,i);
MyTrials4Fieldtrip101{i}(:,:) = t101(:,:,i);

MyTime4Fieldtrip{i}       = 0:1/fsample:timeSampled-1/fsample;

end

% Estructura final de fieldtrip EEG1

EEG1          = [];

EEG1.fsample  = fsample;

%EEG1.label    = trainingData.channels(1:8);
EEG1.label    = chan;

EEG1.time     = MyTime4Fieldtrip;

EEG1.trial    = MyTrials4Fieldtrip100;

% Estructura final de fieldtrip EEG2

EEG2          = [];

EEG2.fsample  = fsample;

%EEG2.label    = trainingData.channels(1:8);
EEG2.label    = chan;

EEG2.time     = MyTime4Fieldtrip;

EEG2.trial    = MyTrials4Fieldtrip101;

end