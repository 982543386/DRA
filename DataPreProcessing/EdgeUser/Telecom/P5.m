clear all;
clc;

% Discard

load('./mats/fulTrajs_P3.mat');
load('./mats/20000Users_P4.mat');
load('../../EdgeServer/Telecom/mats/reqProp_P3.mat');

[trajCount, timeslot] = size(fulTrajs);

reqUsers_20000 = reqUsers;

X = [5000:500:20000];
for j = X
    baseCount = j;
    reqCount = round(reqProp * baseCount);
    reqUsers = {};
    for i=1:timeslot
        if reqCount(i) >= length(reqUsers_20000{i})
            reqUsers{i} = reqUsers_20000{i};
        else
            reqUsers{i} = reqUsers_20000{i}(1:reqCount(i));
        end    
    end
    save(strcat('./mats/', num2str(baseCount), '_Users.mat'), 'reqUsers');
end