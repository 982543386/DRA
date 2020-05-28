clear all;
clc;

% read all trajectories in non-repeated data

load('./mats/feasibleTrajs_P1.mat');
count = length(feasibleTrajs);

Trajs = {};
Trajs_ll = {};  % Latitude and Longitude

for i=1:count
    rawdata   = importdata(strcat('./taxi/', num2str(feasibleTrajs(i)), '.txt'), ',');
    len       = length(rawdata.data);
    user.ID   = str2num(rawdata.textdata{1,1});
    user.time = zeros(len, 1);
    user.long = zeros(len, 1);
    user.lat  = zeros(len, 1);
    for j=1:len
        hh = str2num(rawdata.textdata{j,2}(12:13));
        mm = str2num(rawdata.textdata{j,2}(15:16));
        ss = str2num(rawdata.textdata{j,2}(18:19));
        user.time(j) = hh*60 + mm;
        user.long(j) = rawdata.data(j,1);
        user.lat(j)  = rawdata.data(j,2);
    end
    
    flag = 0;
    curtraj = {};
    curtraj_ll = {};
    for j=1:len
        la = user.lat(j); lo = user.long(j);
        % get the trajectories in the experiment filed
        % (31.2335796600 - 31.1963710000) * 111 = 4.13016126000011
        % (121.4945720000 - 121.4233073100) * 111 = 7.91038059000074
        if la > 31.1963710000 && la < 31.2335796600 && lo > 121.4233073100 && lo < 121.4945720000            
            flag = 1;
            la_p = (la - 31.1963710000) * 111;   % y
            lo_p = (lo - 121.4233073100) * 111;  % x
            if user.time(j) == 0
                user.time(j) = 1;
            end
            %                 time         latitude   longitude
            curtraj{end+1} = [user.time(j) lo_p       la_p];
            curtraj_ll{end+1} = [user.time(j) lo la];
        else
            if flag == 1
                Trajs{end+1} = curtraj;
                Trajs_ll{end+1} = curtraj_ll;
            end
            flag = 0;
            curtraj = {};
            curtraj_ll = {};
        end
    end
    if flag == 1
    	Trajs{end+1} = curtraj;
        Trajs_ll{end+1} = curtraj_ll;
    end    
end

save('./mats/Trajs_P2.mat', 'Trajs', 'Trajs_ll');