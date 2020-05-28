clear all;
clc;


% get all trajectories which length greater than 60 time slots (799 total)
% generate the position matrix (time and position mapping matrix) during a day
% use interpolation method to fix some missing coordinates 


load('./mats/Trajs_P2.mat');
avaTrajs = {};
avaTrajs_ll = {};
for i=1:length(Trajs)
    if length(Trajs{i}) > 60
        avaTrajs{end+1} = Trajs{i};
        avaTrajs_ll{end+1} = Trajs_ll{i};
    end
end

fulTrajs = cell(length(avaTrajs), 60*24);
fulTrajs_ll = cell(length(avaTrajs), 60*24);


% for i=1:length(avaTrajs)
for i=1:length(avaTrajs)
    startTime = avaTrajs{i}{1}(1);
    endTime = avaTrajs{i}{end}(1);
    
    preX = 0;
    preY = 0;
    cur  = 1;
    j=startTime;
    while j <= endTime
        if j > avaTrajs{i}{cur}(1)
            cur  = cur + 1;
            continue;
        end
        if j == avaTrajs{i}{cur}(1)
            preX = avaTrajs{i}{cur}(2);
            preY = avaTrajs{i}{cur}(3);
            preX_ll = avaTrajs_ll{i}{cur}(2);
            preY_ll = avaTrajs_ll{i}{cur}(3);
            cur  = cur + 1;
        end
        fulTrajs{i,j} = [preX, preY];
        fulTrajs_ll{i,j} = [preX_ll, preY_ll];
        j=j+1;
    end
end

save('./mats/fulTrajs_P3.mat', 'fulTrajs', 'fulTrajs_ll');