function [EEG1,EEG2,POW1,POW2,POW1Avg,POW2Avg] = segmentationTrainingAgesBeep(info)
%% This code segmentates the data of the TRAINING in separte ages (1-30 young) and (31-60) old
% and chooses a predermined window time of -0.5 secs before the BEEP and 1
% sec after the beep. This program aims to extract these time series to
% analyze P300 paradigm in both time and frequency domains and carry on
% further studies. 

fs = info.fs;
wt = info.wt;
at = info.at;
cutoff = info.cutoff;
type = info.type;
numM = info.numM;
YvsO = info.YvsO;
pivot = info.pivot;
pro = info.pro;
par = info.par;
pow = info.pow;
chan = info.chan;

ages_list = importdata("Horarios BCI+HoH y Resultados.xlsx");
[ages_list, idx] = sort(ages_list.data(:,17));
if pro == 0
    [youngIdx, olderIdx] = divideVectorByThreshold(par, 30);
end

eegY = zeros(8,fs*(wt+at),24,length(type),length(numM),round(pro*0.3));
eegO = zeros(8,fs*(wt+at),24,length(type),length(numM),round(pro*0.3));
for age = YvsO
    if and(age == 1, pro ~= 0)
        good = idx(1:round(pro*0.3))';
    elseif and(age == 2, pro ~= 0)
        good = idx(61-round(pro*0.3):60)';
    elseif and(age == 1, pro == 0)
        good = youngIdx;
    elseif and(age == 2, pro == 0)
        good = olderIdx;
    end
    cont_p = 0; 
    for p = good 
        cont_p = cont_p + 1;
        cont_i = 0;
        for i = numM 
            cont_i = cont_i + 1;
            cont_t = 0;
            for t = type 
                cont_t = cont_t + 1;
                if p <= 30
                    if     t == 1 && i == 1
                        structuredData = readBinaryEbrFile(sprintf('%d_%s%s%d.ebr',p,'j','e',i));
                    elseif t == 2 && i == 1
                        structuredData = readBinaryEbrFile(sprintf('%d_%s%s%d.ebr',p,'j','v',i));
                    elseif t == 1 && i == 2
                        structuredData = readBinaryEbrFile(sprintf('%d_%s%s%d.ebr',p,'j','e',i));
                    elseif t == 2 && i == 2
                        structuredData = readBinaryEbrFile(sprintf('%d_%s%s%d.ebr',p,'j','v',i));
                    end
                else
                    if     t == 1 && i == 1
                        structuredData = readBinaryEbrFile(sprintf('%d_%s%s%d.ebr',p,'m','e',i));
                    elseif t == 2 && i == 1
                        structuredData = readBinaryEbrFile(sprintf('%d_%s%s%d.ebr',p,'m','v',i));
                    elseif t == 1 && i == 2
                        structuredData = readBinaryEbrFile(sprintf('%d_%s%s%d.ebr',p,'m','e',i));
                    elseif t == 2 && i == 2
                        structuredData = readBinaryEbrFile(sprintf('%d_%s%s%d.ebr',p,'m','v',i));
                    end
                end
                raw = structuredData.data;
                raw = permute(raw,[1 3 2]);
                time = ((0:1:structuredData.numberOfSamples-1) / structuredData.sampRate)';
                raw(:,9) = time;
                if not(isempty(cutoff))
                    raw(:,1:8) = ft_preproc_bandpassfilter(raw(:,1:8)', fs, cutoff)';
                end
                tensor = zeros(8,(wt+at)*fs,24);
                [pks,locs] = findpeaks(raw(:,10),raw(:,9));
                mark = []; 
                for l = 1:length(locs)
                    if pks(l) == pivot(t) 
                        mark(end+1) = locs(l);
                    end
                end
                mark = fs*mark;
                for l = 1:24
                    tensor(:,:,l) = raw(mark(l)-fs*at:mark(l)+wt*fs-1,1:8)';
                end
                if age == 1
                    eegY(:,:,:,cont_t,cont_i,cont_p) = tensor; 
                elseif age == 2
                    eegO(:,:,:,cont_t,cont_i,cont_p) = tensor; 
                end
            end
        end
    end
end

eegY = reshape(eegY,[size(eegY,1), size(eegY,2), size(eegY,3)*size(eegY,4)*size(eegY,5)*size(eegY,6)]); % YOUNG
eegO = reshape(eegO,[size(eegO,1), size(eegO,2), size(eegO,3)*size(eegO,4)*size(eegO,5)*size(eegO,6)]); % old
eegY = eegY(chan,:,:);
eegO = eegO(chan,:,:);

PSD = 1;
chan_names = {'C3';'C1';'Cz';'C2';'C4';'CP3';'CPz';'CP4'};
nuances.fsample = 256;
nuances.timeSampled = wt + at;
nuances.chan = chan_names(chan);
nuances.maxfrec = 40;
EEG1 = []; EEG2 = []; POW1 = []; POW2 = []; POW1Avg = []; POW2Avg = [];

if pow == 1
    if prod(YvsO == 1)
        nuances.Ntrials = size(eegY,3);
        [EEG1, POW1, POW1Avg] = buildUniFieldTrip(eegY, PSD, nuances);
    elseif prod(YvsO == 2)
        nuances.Ntrials = size(eegO,3);
        [EEG2, POW2, POW2Avg] = buildUniFieldTrip(eegO, PSD, nuances);
    else
        nuances.Ntrials = size(eegY,3);
        [EEG1, POW1, POW1Avg] = buildUniFieldTrip(eegY, PSD, nuances);
        nuances.Ntrials = size(eegO,3);
        [EEG2, POW2, POW2Avg] = buildUniFieldTrip(eegO, PSD, nuances);
    end
else
    PSD = 0;
    if prod(YvsO == 1)
        nuances.Ntrials = size(eegY,3);
        EEG1 = buildUniFieldTrip(eegY, PSD, nuances);
    elseif prod(YvsO == 2)
        nuances.Ntrials = size(eegO,3);
        EEG2 = buildUniFieldTrip(eegO, PSD, nuances);
    else
        nuances.Ntrials = size(eegY,3);
        EEG1 = buildUniFieldTrip(eegY, PSD, nuances);
        nuances.Ntrials = size(eegO,3);
        EEG2 = buildUniFieldTrip(eegO, PSD, nuances);
    end
end
end