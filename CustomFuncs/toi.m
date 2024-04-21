function [timeOfClassification] = toi(filename)
%% Intrucciones: 
% Ingresa el nombre del archivo de la Validación Online .ebr (la extensión incluida)
%% Output
% Regresa un vector cuya longitud es el número de trials y cuyo contenido
% es el tiempo de clasificación del algorítmo. 
structuredData = readBinaryEbrFile(filename);
rawData = structuredData.data;
rawData = permute(rawData,[1 3 2]);
time = ((0:1:structuredData.numberOfSamples-1) / structuredData.sampRate)';
rawData(:,9) = time;
[pks,locs] = findpeaks(rawData(:,10),rawData(:,9));
mark101 = [];
mark1001 = [];
for i = 1:length(locs)
    if pks(i) == 101
        mark101(end+1) = locs(i);
    elseif pks(i) == 1001
        mark1001(end+1) = locs(i);
    end
end
timeOfClassification = zeros(1,24);
if ~isempty(mark1001)
    flag = 0;
    for i = 1:24
        if i - flag <= length(mark1001)
            if mark1001(i - flag) - mark101(i) <= 15.1
                timeOfClassification(i) = mark1001(i - flag) - mark101(i);
            else
                flag = flag + 1;
                timeOfClassification(i) = inf;
            end
        else
            timeOfClassification(i) = inf;
        end
    end
else
    timeOfClassification(:) = 15*ones(1,24);
end
end