clear all;
clc;


load('./mats/fulTrajs_P3.mat');
load('../../EdgeServer/Telecom/mats/reqProp_P3.mat');

% Discard
% P4 generate [5000:500:20000] test cases

[trajCount, timeslots] = size(fulTrajs);
% X = [5000:500:20000];
X = [20000];
for baseCount=X
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
    save(strcat('./mats/', num2str(baseCount), '_Users.mat'), 'reqUsers');
end

