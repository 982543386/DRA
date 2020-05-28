clear all;
clc;

% P6 generate 1500 requests to plot reqeust density heatmap

load('./mats/fulTrajs_P3.mat');
load('../../EdgeServer/Telecom/mats/reqProp_P3.mat');

[trajCount, timeslots] = size(fulTrajs);
baseCount = 5000;

reqCount  = round(reqProp * baseCount);
reqUsers = {};

for i=1:timeslots
	allCurUsers = [];
	for j=1:trajCount
        if ~isempty(fulTrajs{j,i}) 
            allCurUsers(end+1) = j;
        end
    end

	if length(allCurUsers) > reqCount(i)    
        reqUserIDs = allCurUsers(randperm(numel(allCurUsers), reqCount(i)));
    else
        reqUserIDs = allCurUsers;
    end
	reqUsers{end+1} = reqUserIDs;
end


reqHistories = {};
for i=1:timeslots
    if isempty(reqUsers{i})
        continue;
    end
    
    for j=1:length(reqUsers{i})
        u_id = reqUsers{i}(j);
        reqHistories{end+1} = fulTrajs_ll{u_id, i};
    end
end

filename = 'heatmap_data.txt';
fid = fopen(filename,'w');
for i=1:length(reqHistories)
	fprintf(fid,'new google.maps.LatLng(%f,%f), \n', reqHistories{i}(2),reqHistories{i}(1));
end
fclose(fid);

    