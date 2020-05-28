clear all;
clc;

% dataset = 'EUA';
dataset = 'Telecom';
N       = 1;

load(strcat('./DataSet/mats/', dataset, '_datasets_', num2str(N), '.mat'));

ES_modes   = {'low', 'mid', 'high'};
% ES_modes   = {'low'};
% ES_modes   = {'mid'};
% ES_modes   = {'high'};

Algorithms = {'DLA', 'OLA', 'Static_optimal', 'MobMig', 'Greedy_capa'};
% Algorithms = {'OLA', 'BFD', 'Greedy_capa', 'Random'};
% Algorithms = {'BFD'};
% Algorithms = {'Greedy_capa'};
% Algorithms = {'OLA'};
% Algorithms = {'DLA'};
% Algorithms = {'Static_optimal'};
% Algorithms = {'Static_optimal_TimeEval'};
% Algorithms = {'Static_optimal', 'BFD', 'DLA'};

% case1 = EUA_datasets{3};
case1 = Telecom_datasets{1};

for i = 1:length(ES_modes)
    ES_mode  = ES_modes{i};
    for j = 1:length(Algorithms)
        Algo  = Algorithms{j};
        resps = [];
        utils = [];
        rejts = [];
        times = [];
        % for k = [6500]
        for k = X
            filename  = strcat( num2str(k), '_', ES_mode);
            data      = case1(filename);
            func      = str2func(Algo);
            [resp, util, rejt, time] = func(data);
            resps(end+1) = resp;    
            utils(end+1) = util;
            rejts(end+1) = rejt;
            times(end+1) = time;            
            fprintf('Telecom dataset:  %s has done\n', strcat(Algo, '_', filename))
        end
        save(strcat('./mats/', dataset, '_', Algo, '_', ES_mode, '.mat'), 'resps', 'utils', 'rejts', 'times', 'X');
    end
end





