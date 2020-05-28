clear all;
clc;


% investigate reqeust arrival time

[month, day, startTime, endTime, latitude, longitude, id] = textread('./Telecom/Telecom-1.txt','%f%f%f%f%f%f%s');

for i=1:length(startTime)
    startTime(i) = floor(startTime(i)) * 60 + (startTime(i)-floor(startTime(i)))*100;
    endTime(i) = floor(endTime(i)) * 60 + (endTime(i)-floor(endTime(i)))*100;
end

figure()
set(gcf,'Position',[400,100, 600, 400]);

timeInterval = 48;
% [y,c] = hist((startTime+endTime)./2, 1*timeInterval);
[y,c] = hist(startTime, 1*timeInterval);
x = [0:timeInterval-1];
%  c = uisetcolor([0.6 0.8 1])
% , 'FaceColor',[ 0.309803921568627         0.309803921568627         0.309803921568627])
b = bar(x, y, 0.8);
set(b,'FaceColor',[0.3922 0.6235 0.9882]);

xlabel("Time (o'clock)")
ylabel('User arrival strength')
% set(gca,'xtick',[0 3 6 9 12 15 18 21 24]);
% xlim([-0.8 24]);
grid on;