clear all;
clc;


% investigate reqeust arrival time

[month, day, startTime, endTime, latitude, longitude, id] = textread('./Telecom/Telecom-1.txt','%f%f%f%f%f%f%s');

for i=1:length(startTime)
    startTime(i) = floor(startTime(i)) * 60 + (startTime(i)-floor(startTime(i)))*100;
    endTime(i) = floor(endTime(i)) * 60 + (endTime(i)-floor(endTime(i)))*100;
end

% fix outlier
timeInterval = 1440;
[y,c] = hist(startTime, 1*timeInterval);
y(421) = 20;
y(422) = 20;
y(423) = 20;
y(424) = 20;
y(1381) = 20;
y(1382) = 20;
y(1383) = 20;
y(1384) = 20;
plot(y)

arrivalCount = y;

experiment_duration_minutes = arrivalCount(481:600);
arrivalCount = zeros(2*60*60, 1);

for i=1:length(experiment_duration_minutes)
    for j=1:experiment_duration_minutes(i)
        second = ceil(rand*60);
        inx = (i-1)*60+second;
        arrivalCount(inx) = arrivalCount(inx) +1;
    end
end

% request proportion per minute
reqProp = arrivalCount./sum(arrivalCount);
save('./mats/reqProp_P3.mat', 'reqProp');