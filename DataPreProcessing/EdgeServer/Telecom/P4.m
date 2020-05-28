clear all;
clc;

% generate edge users' request arrival strength for plot

load('./mats/reqProp_P3.mat');

baseCount = 5000;
reqCounts = baseCount * reqProp;

reqCounts_hours = [];
for i=1:30:length(reqCounts)
    reqCounts_hours(end+1) = round(sum(reqCounts(i:i+29)));    
end


filename = 'density_data.txt';
fid = fopen(filename, 'w');
for i=1:length(reqCounts_hours)
    for j=1:reqCounts_hours(i)
        fprintf(fid,'Telecom  %.2f \n', i/2);
    end
end

fclose(fid);