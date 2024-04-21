%% TIME-FREQUENCY ANALYSIS (SPECTROGRAM WITH FIELDTRIP)
% This program aims to compute time-frequency feature extraction from the
% database "BCI+HOH". The EEG data was acquired at Tec de Monterrey campus
% Guadalajara in the academic period 2022-23 from 30 young healthy adults
% and 30 older healthy adults while performing the motor imagery paradigm
% for the movement of a robotic orthesis in real time. 

POW1 = importdata('POW1ImagDe.mat');
POW2 = importdata('POW2ImagDe.mat');

