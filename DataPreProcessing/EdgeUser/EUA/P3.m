clear all;
clc;

% Note: discarded
% generate [1000:250:8500] test cases

load('./mats/EUA_Req_Position.mat');
load('./mats/ReqArrivalProp_P1.mat');

timeslots = 24 * 60;
X = [1000:250:8500];
for baseCount=X
    reqCount  = round(reqProp * baseCount);
    reqUsers = {};
    for i=1:timeslots
        reqUserID = randperm(length(U_positions), reqCount(i));
        reqUsers{end+1} = reqUserID;
    end
    save(strcat('./mats/', num2str(baseCount), '_Users.mat'), 'reqUsers');
end