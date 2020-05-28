clear all;
clc;

% generate user request arrival data to plot request strength distribution graph

load('./mats/ReqArrivalProp_P1.mat');

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
        fprintf(fid,'EUA  %.2f \n', i/2);
    end
end

fclose(fid);