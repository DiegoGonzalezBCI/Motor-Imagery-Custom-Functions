function powerbands = compute_POW_magntiude_bands(POW,info)
%% This function computes the powerbands of any given EEG data structure.
sampFreq = info.sampFreq;
freqs = info.freqs;
powerbands = zeros(size(POW.powspctrm,1),size(POW.powspctrm,2),length(freqs));
for i = 1:size(POW.powspctrm,1)
    for j = 1:size(POW.powspctrm,2)
        flag = 0;
        for k = freqs
            flag = flag + 1;
            switch k
                case 1
                    powerbands(i,j,flag) = sampFreq*trapz(POW.powspctrm(i,j,1:4*sampFreq+1));
                case 2
                    powerbands(i,j,flag) = sampFreq*trapz(POW.powspctrm(i,j,4*sampFreq+1:8*sampFreq+1));
                case 3
                    powerbands(i,j,flag) = sampFreq*trapz(POW.powspctrm(i,j,8*sampFreq+1:12*sampFreq+1));
                case 4
                    powerbands(i,j,flag) = sampFreq*trapz(POW.powspctrm(i,j,12*sampFreq+1:16*sampFreq+1));
                case 5
                    powerbands(i,j,flag) = sampFreq*trapz(POW.powspctrm(i,j,16*sampFreq+1:20*sampFreq+1));
                case 6
                    powerbands(i,j,flag) = sampFreq*trapz(POW.powspctrm(i,j,20*sampFreq+1:30*sampFreq+1));
                case 7
                    powerbands(i,j,flag) = sampFreq*trapz(POW.powspctrm(i,j,30*sampFreq+1:40*sampFreq+1));
            end
        end
    end
end
end