function [resp, util, rejt, time] = Greedy_capa(data)
    xscal = data.xscal;
    yscal = data.yscal;
    timeslots = data.timeslots;
    signalRange = data.signalRange;
    ES_count = data.ES_count;
    ES_position = data.ES_position;
    ES_speed = data.ES_speed;
    ES_capacity = data.ES_capacity;
    U_count = data.U_count;
    U_position = data.U_position;
    U_tasksize = data.U_tasksize;
    U_speed = data.U_speed;
    U_avaes = data.U_avaes;
    U_arriavaltime = data.U_arriavaltime;
    
    ori_ES_capacity = ES_capacity;
    time = [];

    ES_register = zeros(1, ES_count);
    acceptCount = 0;
    rejectCount = 0;
    totalResp   = 0;

    % delay = 0.5;
    % delay = 1;
    % delay = 2.5;
    delay = 30;
    % for i=1:timeslots
    % for i=1:2:timeslots
    % for i=1:5:timeslots
    for i=1:60:timeslots
        tic;
        % Users  = [U_arriavaltime{i} U_arriavaltime{i+1} U_arriavaltime{i+3} U_arriavaltime{i+4}]; % 当前时间段内所有到达的用户
        % Users  = [U_arriavaltime{i} U_arriavaltime{i+1} U_arriavaltime{i+3} U_arriavaltime{i+4} ...
        %     U_arriavaltime{i+5} U_arriavaltime{i+6} U_arriavaltime{i+7} U_arriavaltime{i+8} U_arriavaltime{i+9}] ;       % 当前时间段内所有到达的用户
        
        Users = U_arriavaltime{i};
        for batch_ind = 1:59
            Users = [Users U_arriavaltime{i+batch_ind}];
        end

        if isempty(Users)
            continue;
        end
        
        for j=1:length(Users)
            %  for xxx=1:20
                u_id         = Users(j);
                t_ES_ids     = U_avaes{u_id};
                t_U_tasksize = U_tasksize(u_id);
                Res(j)       = t_U_tasksize;

                % 本地执行耗时
                % resonse time of locally executing
                exectime_l  = t_U_tasksize / U_speed(u_id);

                if isempty(t_ES_ids)   % have to be executed locally
                   	rt = exectime_l;
                    % add delay time is to compensate the expected waiting time
                    totalResp = totalResp + rt + delay;
                    rejectCount = rejectCount + 1;
                else
                    t_ES_rt = [];
                    for e_id = t_ES_ids
                        exectime = t_U_tasksize / ES_speed(e_id);
                        if ES_register(e_id) > i
                            exectime = exectime + ES_register(e_id) - i;
                        end
                        t_ES_rt(end+1) = exectime;
                    end

                    [exectime_e indx]   = min(t_ES_rt); % response time of executing at edge
                    e_id        = t_ES_ids(indx);                    
                    rt          = exectime_e;
                    totalResp         = totalResp + rt + delay;
                    acceptCount       = acceptCount + 1;
                    ES_capacity(e_id) = ES_capacity(e_id) - Res(j);
                    ES_register(e_id) = i + rt;
                end
        end
           
        time(end+1) = toc;
    end

    resp = totalResp / U_count;
    util = 1 - mean(ES_capacity./ori_ES_capacity);
    rejt = rejectCount / U_count;
    time = mean(time);
end