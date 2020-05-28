clear all;
clc;

load('./mats/ES_P1.mat');

figure();
xscal = 7.91038059000074;
yscal = 4.13016126000011;
set(gcf, 'Position', [200, 100, xscal*100, yscal*100]);

for i=1:length(EdgeServers)
    circle(EdgeServers{i}(1), EdgeServers{i}(2), 0.8, num2str(i));
    hold on;
end

xlim([0 xscal]);
ylim([0 yscal]);