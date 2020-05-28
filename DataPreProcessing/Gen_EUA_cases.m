clear all;
clc;


% Generate EUA test cases

load('./EdgeServer/EUA/mats/ES_P1.mat');      % ES file
load('./User/EUA/mats/ReqArrivalProp_P1.mat');    % U  file
load('./User/EUA/mats/EUA_Req_Position.mat'); % U  file

N = 5;
% timeslots        = 60 * 24;
timeslots        = 60 * 60 * 2;
signalRange      = 0.3;

ES_modes  = {'low', 'mid', 'high'};
% ES_modes  = {'mid'};

U_speed_low   = 0.003;
U_speed_mu    = 0.005;
U_speed_high  = 0.010;
U_speed_delta = 0.005;

U_tasksize_low   = 3;
U_tasksize_mu    = 5;
U_tasksize_high  = 7;
U_tasksize_delta = 1;

% config edge servers
l = 170;  % low
m = 225;  % mu
h = 280;  % high
d = 30;   % delta
keys   = ES_modes;
values = {};
ratio  = [0.8, 0.9, 1];
for i=1:length(keys)
    cfg.ES_capa_low   = l * ratio(i);
    cfg.ES_capa_mu    = m * ratio(i);
    cfg.ES_capa_high  = h * ratio(i);
    cfg.ES_capa_delta = d * ratio(i);
    values{end+1} = cfg;
end
ES_config = containers.Map(keys,values);


X = [4000:100:8000];
EUA_datasets = {};
for nn = 1:N    
    keys    = {};
    values  = {};
    
    % generate a new user permutation for every cases
    base_Count    = 10000;
    base_reqCount = round(reqProp * base_Count);
    base_reqUsers = {};
    for i=1:timeslots
        reqUserID = randperm(length(U_positions), base_reqCount(i));
        base_reqUsers{end+1} = reqUserID;
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
        
        U_tasksizes = zeros(1, base_Count+1000); % add another 1000 user in case of overflow
        U_speeds    = zeros(1, base_Count+1000);
        
        for i=1:length(U_tasksizes)
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
                    U_position(U_id, 1) = U_positions(U_ID, 1);
                    U_position(U_id, 2) = U_positions(U_ID, 2);
                    U_tasksize(U_id)    = U_tasksizes(U_id);
                    U_speed(U_id)       = U_speeds(U_id);
                    avaEdgeServers      = [];
                    uP = [U_position(U_id, 1), U_position(U_id, 2)];
                    for k=1:ES_count
                        eP = [ES_position(k,1), ES_position(k,2)];
                        if norm(uP-eP) <= signalRange
                            avaEdgeServers(end+1) = k;
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
            fprintf('Syn EUA Dataset %d : %s has done \n', nn, dataname);
        end
    end
    EUA_datasets{end+1} = containers.Map(keys,values);
end


save(strcat('./mats/EUA_datasets_', num2str(N) , '.mat'), 'EUA_datasets', 'X');


function r = getRandn(min, max, mu, delta)
    r = normrnd(mu, delta);
    while r < min || r > max
        r = normrnd(mu, delta);
    end
end