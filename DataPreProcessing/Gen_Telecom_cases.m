clear all;
clc;

% Generate Telcom test cases

load('./EdgeServer/Telecom/mats/ES_P1.mat');      % ES file
load('./User/Telecom/mats/fulTrajs_P3.mat');      % U  file
load('./EdgeServer/Telecom/mats/reqProp_P3.mat'); % U  file


N = 5;
timeslots        = 60 * 60 * 2;
signalRange      = 0.6;
[trajCount, t]   = size(fulTrajs);

ES_modes  = {'low', 'mid', 'high'};
% ES_modes  = {'mid'};

U_speed_low   = 0.005;
U_speed_mu    = 0.01;
U_speed_high  = 0.015;
U_speed_delta = 0.005;

U_tasksize_low   = 3;
U_tasksize_mu    = 5;
U_tasksize_high  = 7;
U_tasksize_delta = 1;

% config edge servers
l = 800;  % low
m = 1200;  % mu
h = 1600;  % high
d = 200;   % delta
keys   = ES_modes;
values = {};
ratio  = [0.75, 1, 1.25];
for i=1:length(keys)
    cfg.ES_capa_low   = l * ratio(i);
    cfg.ES_capa_mu    = m * ratio(i);
    cfg.ES_capa_high  = h * ratio(i);
    cfg.ES_capa_delta = d * ratio(i);
    values{end+1} = cfg;
end
ES_config = containers.Map(keys,values);

X = [10000:250:20000];

Telecom_datasets = {};
for nn = 1:N    
    keys    = {};
    values  = {};
    
    % generate a new user permutation for every cases
    base_Count    = 20000;
    base_reqCount = round(reqProp * base_Count);
    base_reqUsers = {};
    for i=1:timeslots
        allCurUsers = [];
        for j=1:trajCount
            ts = ceil(i/60)+480; % convert second to minute
            if ~isempty(fulTrajs{j,ts}) 
                allCurUsers(end+1) = j;
            end
        end

        if length(allCurUsers) > base_reqCount(i)    
            reqUserIDs = allCurUsers(randperm(numel(allCurUsers), base_reqCount(i)));
        else
            reqUserIDs = allCurUsers;
        end
        base_reqUsers{end+1} = reqUserIDs;
    end
    
    % The configuration of edge servers remain unchanged for each ES mode
    for k=1:length(ES_modes)
        % Edge Server Configuration
        ES_mode = ES_modes{k};
        ES_cfg  = ES_config(ES_mode);
        
        ES_count    = length(EdgeServers);
        ES_position = zeros(ES_count, 2);
        ES_speed    = zeros(ES_count, 1);
        ES_capacity = zeros(ES_count, 1);
        for i=1:ES_count
            ES_position(i,1) = EdgeServers(i,1);
            ES_position(i,2) = EdgeServers(i,2);
            ES_capacity(i)   = getRandn(ES_cfg.ES_capa_low, ES_cfg.ES_capa_high, ...
                ES_cfg.ES_capa_mu, ES_cfg.ES_capa_delta);
            ES_speed(i)      = ES_capacity(i) / timeslots;
        end
        
        U_tasksizes = zeros(1, base_Count);
        U_speeds    = zeros(1, base_Count);
        
        for i=1:base_Count
            U_tasksizes(i) = getRandn(U_tasksize_low, U_tasksize_high, ...
                        U_tasksize_mu, U_tasksize_delta);
            U_speeds(i)    = getRandn(U_speed_low, U_speed_high, ...
                        U_speed_mu, U_speed_delta);
        end

        for uc = X
            % Edge User Configuration
            t_reqCount = round(reqProp * uc);
            U_count    = sum(t_reqCount);
            reqUsers = {};            
            
            U_position = zeros(U_count, 2);
            U_tasksize = zeros(U_count, 1);
            U_speed    = zeros(U_count, 1);
            U_avaes    = {};
            U_id       = 0;
            for i=1:timeslots
                t_reqUsers = []; % users who sent offloading requests at current time point
                if t_reqCount(i) >= length(base_reqUsers{i})
                    t_reqUsers = base_reqUsers{i};
                else
                    t_reqUsers = base_reqUsers{i}(1:t_reqCount(i));
                end
                reqUsers{end+1} = t_reqUsers;
                
                for j=1:length(t_reqUsers)
                    U_id = U_id + 1;        % User No. in Experiment
                    U_ID = t_reqUsers(j);   % User No. in Trajecotires
                    ts = ceil(i/60)+480; % convert second to minute
                    U_position(U_id, 1) = fulTrajs{U_ID, ts}(1);
                    U_position(U_id, 2) = fulTrajs{U_ID, ts}(2);
                    U_tasksize(U_id)    = U_tasksizes(U_id);
                    U_speed(U_id)       = U_speeds(U_id);
                    avaEdgeServers      = [];
                    uP = [U_position(U_id, 1), U_position(U_id, 2)];
                    for kk=1:ES_count
                        eP = [ES_position(kk,1), ES_position(kk,2)];
                        if norm(uP-eP) <= signalRange
                            avaEdgeServers(end+1) = kk;
                        end
                    end                    
                    U_avaes{end+1} = avaEdgeServers;
                end
            end

            U_arriavaltime   = reqUsers;            
            data.xscal       = xscal;
            data.yscal       = yscal;
            data.timeslots   = timeslots;
            data.signalRange = signalRange;
            data.ES_count    = ES_count;
            data.ES_position = ES_position;
            data.ES_speed    = ES_speed;
            data.ES_capacity = ES_capacity;
            data.U_count     = U_id;
            data.U_position  = U_position;
            data.U_tasksize  = U_tasksize;
            data.U_speed     = U_speed;
            data.U_avaes     = U_avaes;
            data.U_arriavaltime = U_arriavaltime;
            dataname = strcat(num2str(uc), '_', ES_mode);
            keys{end+1} = dataname;
            values{end+1} = data;
            fprintf('Syn Telecom Dataset %d : %s has done \n', nn, dataname);
        end
    end
    Telecom_datasets{end+1} = containers.Map(keys,values);
end


save(strcat('./mats/Telecom_datasets_', num2str(N) , '.mat'), 'Telecom_datasets', 'X');


function r = getRandn(min, max, mu, delta)
    r = normrnd(mu, delta);
    while r < min || r > max
        r = normrnd(mu, delta);
    end
end
