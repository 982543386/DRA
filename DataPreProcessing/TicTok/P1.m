clear all;
clc;

% uid, user_city, item_id, author_id, item_city, channel, finish, like, music_id, device, time, duration_time
load('data_1.txt');
time = data_1(:, 11);
time_str = {};

max_t = max(time);
min_t = min(time);
mean_t = mean(time);
std_t = std(time);

time2 = [];
for i=1:length(time)
    if time(i) < (mean_t - std_t) || time(i) > (mean_t + std_t) 
        continue;
    else
        time2(end+1) = time(i) - mean_t;
    end
    % time_str{end+1} = ConvertDate(time(i));
end


figure()
set(gcf,'Position',[400,100, 600, 400]);

timeInterval = 24;
[y,c] = hist(time2, 1*timeInterval);
x = [0:timeInterval-1];
b = bar(x, y, 0.8);
set(b,'FaceColor',[0.3922 0.6235 0.9882]);

xlabel("Time (o'clock)")
ylabel('User arrival strength')
grid on;



function [date] = ConvertDate(x)
    date = datestr((x+28800000)/86400000 + datenum(1970,1,1),31);
end