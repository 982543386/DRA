clear all;
clc;

load('./mats/Users.mat');

figure();
%  xlim([0 7.91038059000074]);
%  ylim([0 4.13016126000011]);
xscal = 7.91038059000074;
yscal = 4.13016126000011;
set(gcf, 'Position', [200, 100, xscal*100, yscal*100]);

[trajCount, timeslot] = size(fulTrajs);


for i=1:timeslot
    X = [];
    Y = [];
    for j=1:trajCount
        if ~isempty(fulTrajs{j,i}) 
            X(end+1) = fulTrajs{j,i}(1);
            Y(end+1) = fulTrajs{j,i}(2);
        end
    end
    clf;
      
    reqUsersX = [];
    reqUsersY = [];
    for j=1:length(reqUsers{i})
        uID = reqUsers{i}(j);
        reqUsersX(end+1) = fulTrajs{uID,i}(1);
        reqUsersY(end+1) = fulTrajs{uID,i}(2);
    end
    
    plot(X, Y, 'o', 'linewidth', 2);
    hold on;
    plot(reqUsersX, reqUsersY, '*', 'color', 'red', 'linewidth', 2);    
    xlim([0 xscal]);
    ylim([0 yscal]);    
    timetxt = strcat("Current time: ", num2str(floor(i/60)), " : ", num2str(mod(i, 60)));
    usertxt = strcat("                 Current user count: ", num2str(length(X)));
    reqtxt  = strcat("                 Current request count: ", num2str(length(reqUsers{i})));
    title(strcat(timetxt, usertxt, reqtxt));
    pause(0.08);    
end



