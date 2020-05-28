clear all;
clc;

% investigate base station count and their signal coverage
% xscal = 7.91038059000074;    km
% yscal = 4.13016126000011;    km

[month1, day1, startTime1, endTime1, latitude1, longitude1, id1] = textread('./Telecom/Telecom-1.txt','%f%f%f%f%f%f%s');
[month2, day2, startTime2, endTime2, latitude2, longitude2, id2] = textread('./Telecom/Telecom-2.txt','%f%f%f%f%f%f%s');
[month3, day3, startTime3, endTime3, latitude3, longitude3, id3] = textread('./Telecom/Telecom-3.txt','%f%f%f%f%f%f%s');
[month3, day3, startTime3, endTime4, latitude4, longitude4, id3] = textread('./Telecom/Telecom-4.txt','%f%f%f%f%f%f%s');
[month3, day3, startTime3, endTime5, latitude5, longitude5, id3] = textread('./Telecom/Telecom-5.txt','%f%f%f%f%f%f%s');
[month3, day3, startTime3, endTime5, latitude6, longitude6, id3] = textread('./Telecom/Telecom-6.txt','%f%f%f%f%f%f%s');
[month3, day3, startTime3, endTime5, latitude7, longitude7, id3] = textread('./Telecom/Telecom-7.txt','%f%f%f%f%f%f%s');
[month3, day3, startTime3, endTime5, latitude8, longitude8, id3] = textread('./Telecom/Telecom-8.txt','%f%f%f%f%f%f%s');
[month3, day3, startTime3, endTime5, latitude9, longitude9, id3] = textread('./Telecom/Telecom-9.txt','%f%f%f%f%f%f%s');
[month3, day3, startTime3, endTime5, latitude10, longitude10, id3] = textread('./Telecom/Telecom-10.txt','%f%f%f%f%f%f%s');

[month1, day1, startTime1, endTime1, latitude11, longitude11, id1] = textread('./Telecom/Telecom-1.txt','%f%f%f%f%f%f%s');
[month2, day2, startTime2, endTime2, latitude12, longitude12, id2] = textread('./Telecom/Telecom-2.txt','%f%f%f%f%f%f%s');
[month3, day3, startTime3, endTime3, latitude13, longitude13, id3] = textread('./Telecom/Telecom-3.txt','%f%f%f%f%f%f%s');
[month3, day3, startTime3, endTime4, latitude14, longitude14, id3] = textread('./Telecom/Telecom-4.txt','%f%f%f%f%f%f%s');
[month3, day3, startTime3, endTime5, latitude15, longitude15, id3] = textread('./Telecom/Telecom-5.txt','%f%f%f%f%f%f%s');
[month3, day3, startTime3, endTime5, latitude16, longitude16, id3] = textread('./Telecom/Telecom-6.txt','%f%f%f%f%f%f%s');
[month3, day3, startTime3, endTime5, latitude17, longitude17, id3] = textread('./Telecom/Telecom-7.txt','%f%f%f%f%f%f%s');
[month3, day3, startTime3, endTime5, latitude18, longitude18, id3] = textread('./Telecom/Telecom-8.txt','%f%f%f%f%f%f%s');
[month3, day3, startTime3, endTime5, latitude19, longitude19, id3] = textread('./Telecom/Telecom-9.txt','%f%f%f%f%f%f%s');
[month3, day3, startTime3, endTime5, latitude20, longitude20, id3] = textread('./Telecom/Telecom-10.txt','%f%f%f%f%f%f%s');

latitude = [latitude1' latitude2' latitude3' latitude4' latitude5' latitude6' latitude7' latitude8' latitude9' latitude10' ...
    latitude11' latitude12' latitude13' latitude14' latitude15' latitude16' latitude17' latitude18' latitude19' latitude20'];
longitude = [longitude1' longitude2' longitude3' longitude4' longitude5' longitude6' longitude7' longitude8' longitude9' longitude10' ... 
    longitude11' longitude12' longitude13' longitude14' longitude15' longitude16' longitude17' longitude18' longitude19' longitude20'];

EdgeServers = {};
for i=1:length(latitude)
    la = latitude(i);   % latitude  1 = 111km
    lo = longitude(i);  % longitude 1 = 111km
    % Upper-left: 31.2335796600,121.4233073100
    % Lower_right: 31.1963710000,121.4945720000
    % (31.2335796600 - 31.1963710000) * 111 = 4.13016126000011
    % (121.4945720000 - 121.4233073100) * 111 = 7.91038059000074
    
    % [longitude, latitude]
    % [121.4945720000, 31.1963710000]
    % [121.4233073100, 31.2335796600]
    
    if la > 31.1963710000 && la < 31.2335796600 && lo > 121.4233073100 && lo < 121.4945720000
        la = (la - 31.1963710000) * 111;
        lo = (lo - 121.4233073100) * 111;
        flag = 1;
        for j=1:length(EdgeServers)
            if EdgeServers{j}(1) == lo && EdgeServers{j}(2) == la
                flag = 0;
                break;
            end
        end
        if flag == 1
            EdgeServers{end+1} = [lo la];
        end
    end
end

ES = zeros(length(EdgeServers), 2);
for i=1:length(EdgeServers)
    ES(i,1) = EdgeServers{i}(1);
    ES(i,2) = EdgeServers{i}(2);
end

EdgeServers = ES;
xscal = 7.91038059000074;
yscal = 4.13016126000011;

save('./mats/ES_P1.mat', 'EdgeServers', 'xscal', 'yscal');

