clear all;
clc;

% Total file count:4316
% delete some junk data file (repeated data)

trajCount     = 4316;
feasibleTrajs = [];

for i=1:trajCount
    rawdata   = importdata(strcat('./taxi/', num2str(i), '.txt'), ',');
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
    if std(user.lat) > 0.001 && std(user.long) > 0.001
        i
        feasibleTrajs(end+1) = i;
    end
end

% wm = webmap('World Imagery');
% s = geoshape(user.lat, user.long);
% wmline(s,'Color', 'red', 'Width', 3);
save('./mats/feasibleTrajs_P1.mat', 'feasibleTrajs');






