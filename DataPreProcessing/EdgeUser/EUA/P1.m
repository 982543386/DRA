clear all
clc;

% generate requst arrival distribution

load('./mats/Uber_ReqTime.mat');

reqTime = [];
for i=1:length(UberReqTime)
    hh = floor(UberReqTime(i));
    mm = (UberReqTime(i) - hh) * 100;
    reqTime(end+1) = hh*60 + mm;
end

reqTime = [reqTime';reqTime'];

N = length(reqTime);
num=100;         
[x,c]=hist(reqTime,num);
dc=24/num;        
x=x/N/dc;         
 
bar(c,x,1); hold on;  
xlabel('request arrival time(h)');
ylabel('request proportion');
time = ceil(sort(reqTime));

time = time + 1;
arrivalCount = zeros(24*60, 1);
for i=1:length(time)
    t = time(i);
    arrivalCount(t) = arrivalCount(t) + 1;
end

% reqProp = arrivalCount./sum(arrivalCount);
% save('./mats/ReqArrivalProp_P1.mat', 'reqProp')

arrivalCount = arrivalCount * 10;
experiment_duration_minutes = arrivalCount(481:600);
arrivalCount = zeros(2*60*60, 1);

for i=1:length(experiment_duration_minutes)
    for j=1:experiment_duration_minutes(i)
        second = ceil(rand*60);
        inx = (i-1)*60+second;
        arrivalCount(inx) = arrivalCount(inx) +1;
    end
end


reqProp = arrivalCount./sum(arrivalCount);
save('./mats/ReqArrivalProp_P1.mat', 'reqProp')