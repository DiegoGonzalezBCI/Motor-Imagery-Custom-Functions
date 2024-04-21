function [MPP, STD, SNR] = exclusion_criteria(EEG)
% EEG is a 8 (chan) x 256 (samples) x 24 (trials) tensor, which is analyzed
% samplewise, that is, each output is a 8 (chan) x 24 (trials) exclusion
% criteria matrix. 
MPP = zeros(8,24);
STD = zeros(8,24);
SNR = zeros(8,24);

for i = 1:24 % For each trial
    for j = 1:8 % For each channel
        v = EEG{i}(j,:);
        MPP(j,i) = abs(max(v) - min(v));
        STD(j,i) = std(v);
        SNR(j,i) = db2mag(snr(v));
    end
end

end