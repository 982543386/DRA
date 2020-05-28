function [resp, util, rejt, time] = OLA(data)
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

    eps = 0.1;
    Record_count = ceil(U_count * eps);
    R_c = 0;
    R_f = 0;

    n = Record_count;
    m = ES_count;
    C = zeros(1, n);
    A = zeros(m, n);
    t_ES_capacity = ES_capacity * (1-eps) * n / U_count;
    b = [t_ES_capacity' ones(1, n)]';
        
    breakpoint = 0;   


    for i=1:timeslots
        if R_f == 1
            break;
        end  
        Users = U_arriavaltime{i};
        for u_id = Users  
            tic;
            if R_c == Record_count
                R_f = 1;                 
                breakpoint = i;
                break;
            end        
            R_c = R_c + 1;
            t_ES_ids     = U_avaes{u_id};
            t_ES_avaids  = [];
            t_U_tasksize = U_tasksize(u_id);
            for j=1:length(t_ES_ids)
                e_id = t_ES_ids(j);
                if t_ES_capacity(e_id) >= t_U_tasksize
                   t_ES_avaids(end+1) = e_id;
                end
                t_ES_avaids(end+1) = e_id;
            end        
            if isempty(t_ES_avaids)
                rejectCount = rejectCount + 1;
            else
                t_ES_score = [];
                for e_id = t_ES_avaids
                    exectime = t_U_tasksize / ES_speed(e_id);
                    if ES_register(e_id) > i
                        exectime = exectime + ES_register(e_id) - i;
                    end
                    t_ES_score(end+1) = exectime;
                end

                target_ES_indx    = ceil(rand*length(t_ES_avaids));
                rt                = t_ES_score(target_ES_indx);
                e_id              = t_ES_avaids(target_ES_indx);        
                totalResp         = totalResp + rt;
                acceptCount       = acceptCount + 1;
                ES_capacity(e_id) = ES_capacity(e_id) - t_U_tasksize;
                ES_register(e_id) = i + rt;

                C(R_c) = rt;
                A(e_id, R_c) = t_U_tasksize;
            end
            time(end+1) = toc;
        end
    end

    % acceptCount
    % rejectCount
    % meanResp = totalResp / acceptCount
    

    C_min   = 0;
    C_max   = max(C);
    C_scale = 10;
    for i=1:length(C)
        C(i) = C_scale - (C(i)-C_min)/(C_max-C_min) * C_scale;
    end

    A = [A; eye(n)];
    lb = zeros(m+n,1);
    options = optimoptions('linprog','Display','none');
    [beta, res, flag] = linprog(b', -A', -C, [],[],lb,[], options);

    beta = beta(1:m);
    % beta = zeros(1,m);



    % ES_register = zeros(1, ES_count);
    % acceptCount = 0;
    % rejectCount = 0;
    % totalResp   = 0;


    for i=breakpoint:timeslots
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
                t_ES_score = [];
                t_ES_rt = [];
                for e_id = t_ES_avaids
                    exectime = t_U_tasksize / ES_speed(e_id);
                    if ES_register(e_id) > i
                        exectime = exectime + ES_register(e_id) - i;
                    end
                    t_ES_rt(end+1) = exectime;
                    bscore = C_scale - (exectime-C_min)/(C_max-C_min) * C_scale;
                    t_ES_score(end+1) = bscore - beta(e_id) * U_tasksize(u_id);
                end

                scount = 0;
                for sc = t_ES_score
                    if sc <= 0
                        scount = scount + 1;
                    end
                end
                if scount == length(t_ES_score)
                    rejectCount = rejectCount + 1;                    
                    % execute task locally
                    exectime  = t_U_tasksize / U_speed(u_id);
                    totalResp = totalResp + exectime;
                else        
                    [xxx indx]  = max(t_ES_score);
                    e_id        = t_ES_avaids(indx);
                    rt          = t_ES_rt(indx);
                    totalResp   = totalResp + rt;
                    acceptCount = acceptCount + 1;
                    ES_capacity(e_id) = ES_capacity(e_id) - t_U_tasksize;
                    ES_register(e_id) = i + rt;
                end
            end
            time(end+1) = toc;
        end
    end

    resp = totalResp / U_count;
    util = 1 - mean(ES_capacity./ori_ES_capacity);
    rejt = rejectCount / U_count;
    time = mean(time);
end