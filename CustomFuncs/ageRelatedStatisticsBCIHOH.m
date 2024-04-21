%% This program aims to compute age-related statistics for the BCI+HOH Neuroexperiment

ages_list = importdata("Horarios BCI+HoH y Resultados.xlsx");
[ages_list, idx] = sort(ages_list.data(:,17));

YoungAVG = mean(ages_list(1:30));
YoungSTD = std(ages_list(1:30));

OlderAVG = mean(ages_list(31:60));
OlderSTD = std(ages_list(31:60));