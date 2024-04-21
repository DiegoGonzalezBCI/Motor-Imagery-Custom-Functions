function [segmentatedData, trainingData] = sod(filename)
    trainingData = readBinaryEbrFile(filename);
    rawTraining = trainingData.data;
    rawTraining = permute(rawTraining,[1 3 2]);
    time_ = ((0:1:trainingData.numberOfSamples-1) / trainingData.sampRate)';
    rawTraining(:,9) = time_;
    trainingData.channels = {'C3';'C1';'Cz';'C2';'C4';'CP3';'CPz';'CP4';'TIMESTAMP';'MARK'};
    t100 = zeros(8,4*256,24);
    t101 = zeros(8,4*256,24);
    [pks_,locs_] = findpeaks(rawTraining(:,10),rawTraining(:,9));
    mark100_ = [];
    mark101_ = [];
    for i = 1:length(locs_)
        if pks_(i) == 100
            mark100_(end+1) = locs_(i);
        elseif pks_(i) == 101
            mark101_(end+1) = locs_(i);
        end
    end
    mark100_ = 256*mark100_;
    mark101_ = 256*mark101_;
    for i = 1:24
        t100(:,:,i) = rawTraining(mark100_(i)+256:mark100_(i)+5*256-1,1:8)';
        t101(:,:,i) = rawTraining(mark101_(i)+256:mark101_(i)+5*256-1,1:8)';
    end
    tpsd100 = zeros(8,4096,24);
    tpsd101 = zeros(8,4096,24);
    for i = 1:24
        [p100,f100] = pspectrum(t100(:,:,i)',256);
        [p101,f101] = pspectrum(t101(:,:,i)',256);
        tpsd100(:,:,i) = p100';
        tpsd101(:,:,i) = p101';
    end
    segmentatedData = cell(1,5);
    segmentatedData{1,1} = t100;
    segmentatedData{1,2} = t101;
    segmentatedData{1,3} = tpsd100;
    segmentatedData{1,4} = tpsd101;
    segmentatedData{1,5} = f100;
end