clear all;
clc;

load('EdgeServers.mat');
xscal = 7.91038059000074;
yscal = 4.13016126000011;

eX = [];
eY = [];
eP = [];
for i=1:length(EdgeServers)
    eX(end+1) = EdgeServers{i}(1);
    eY(end+1) = EdgeServers{i}(2);
    eP(end+1) = abs(normrnd(10, 5));
end

save('./mats/pre_ES.mat', 'xscal', 'yscal', 'eX', 'eY', 'eP');
