clear all;
clc;

% transform longitude and latitude to fixed position (Km)
load('./mats/EUA_Req_Position_ori.mat');
U_positions = UPosition / 1000;
save('./mats/EUA_Req_Position.mat', 'U_positions');

