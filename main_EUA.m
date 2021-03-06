clear all;
clc;

N = 5;
load(strcat('./DataPreProcessing/mats/EUA_datasets_', num2str(N), '.mat'));

ES_modes   = {'low', 'mid', 'high'};
% Algorithms = {'DLA', 'OLA', 'Static_optimal', 'BFD', 'Greedy_capa', 'Random'};
Algorithms = {'DLA', 'OLA', 'Static_optimal', 'MobMig', 'Greedy_capa'};

EUA_Results = {};
for nn = 1:N
	EUA_dataset = EUA_datasets{nn};
	keys        = {};
    values      = {};
	for i = 1:length(ES_modes)
	    ES_mode  = ES_modes{i};
	    for j = 1:length(Algorithms)
	        Algo  = Algorithms{j};
	        resps = [];
	        utils = [];
	        rejts = [];
	        times = [];
	        for k = X
	            dataname  = strcat(num2str(k), '_', ES_mode);
	        	data      = EUA_dataset(dataname);
	            func      = str2func(Algo);
	            [resp, util, rejt, time] = func(data);
	            resps(end+1) = resp;    
	            utils(end+1) = util;
	            rejts(end+1) = rejt;
	            times(end+1) = time;
	        end
	        result.resps = resps;
	        result.utils = utils;
	        result.rejts = rejts;
	        result.times = times;
	        keys{end+1} = strcat(Algo, '_', ES_mode);
	        values{end+1} = result;
            fprintf('EUA %d %s %s has done\n', nn, ES_mode, Algo);
	    end	    
	end
	EUA_Results{end+1} = containers.Map(keys,values);
end

save('./mats/EUA_Results.mat', 'EUA_Results', 'X');





