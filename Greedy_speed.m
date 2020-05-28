function [resp, util, rejt, time] = Greedy_speed(data)
    timeslots      = data.timeslots;
    ES_count       = data.ES_count;
    ES_speed       = data.ES_speed;
    ES_capacity    = data.ES_capacity;
    U_count        = data.U_count;
    U_tasksize     = data.U_tasksize;
    U_speed        = data.U_speed;
    U_avaes        = data.U_avaes;
    U_arriavaltime = data.U_arriavaltime;
    
    ori_ES_capacity = ES_capacity;
    time = [];


    ES_register = zeros(1, ES_count);
    acceptCount = 0;
    rejectCount = 0;
    totalResp   = 0;


    for i=1:timeslots
        Users = U_arriavaltime{i};
        for u_id = Users
            tic;
            t_ES_ids     = U_avaes{u_id};
            t_ES_avaids  = [];
            t_U_tasksize = U_tasksize(u_id);
            for j=1:length(t_ES_ids)
                e_id = t_ES_ids(j);
                if ES_capacity(e_id) >= t_U_tasksize
                    t_ES_avaids(end+1) = e_id;
                end
            end        
            if isempty(t_ES_avaids)
                rejectCount = rejectCount + 1;
                % execute task locally
                exectime  = t_U_tasksize / U_speed(u_id);
                totalResp = totalResp + exectime;
            else
                t_ES_rt = [];
                t_ES_speed = [];
                for e_id = t_ES_avaids
                    exectime = t_U_tasksize / ES_speed(e_id);
                    if ES_register(e_id) > i
                        exectime = exectime + ES_register(e_id) - i;
                    end
                    t_ES_rt(end+1) = exectime;
                    t_ES_speed(end+1) = ES_speed(e_id);
                end

                [xx indx]   = max(t_ES_speed);
                e_id        = t_ES_avaids(indx);
                rt          = t_ES_rt(indx);
                totalResp   = totalResp + rt;
                acceptCount = acceptCount + 1;
                ES_capacity(e_id) = ES_capacity(e_id) - t_U_tasksize;
                ES_register(e_id) = i + rt;                
            end
            time(end+1) = toc; 
        end
    end

    resp = totalResp / U_count;
    util = 1 - mean(ES_capacity./ori_ES_capacity);
    rejt = rejectCount / U_count;
    time = mean(time);
end