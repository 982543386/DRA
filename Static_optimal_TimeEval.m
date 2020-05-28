function [resp, util, rejt, time] = Static_optimal_TimeEval(data)
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


    for i=1:timeslots
        tic;
        Users  = U_arriavaltime{i};       
        Scores = zeros(1, length(Users)); 
        ESs    = zeros(1, length(Users)); 
        Res    = zeros(1, length(Users)); 
        Caps   = zeros(1, length(Users)); 
        Rts_e  = zeros(1, length(Users)); 
        Rts_l  = zeros(1, length(Users)); 

        if isempty(Users)
            continue;
        end
        
        for j=1:length(Users)
            for xxx=1:20
                u_id         = Users(j);
                t_ES_ids     = U_avaes{u_id};
                t_U_tasksize = U_tasksize(u_id);
                Res(j)       = t_U_tasksize;

              
                exectime_l  = t_U_tasksize / U_speed(u_id);

                if isempty(t_ES_ids)   
                    Scores(j) = 1000;    
                    ESs(j)    = 0;
                    Rts_e(j)  = 0;
                    Rts_l(j)  = exectime_l;
                    Caps(j)   = 1;
                else
                    t_ES_rt = [];
                    for e_id = t_ES_ids
                        exectime = t_U_tasksize / ES_speed(e_id);
                        if ES_register(e_id) > i
                            exectime = exectime + ES_register(e_id) - i;
                        end
                        t_ES_rt(end+1) = exectime;
                    end

                    [exectime_e indx]   = min(t_ES_rt);
                    e_id        = t_ES_ids(indx);
                    Scores(j)   = exectime_e - exectime_l;
                    Rts_e(j)    = exectime_e;
                    Rts_l(j)    = exectime_l;
                    ESs(j)      = e_id;
                    Caps(j)     = ES_capacity(e_id);
                end
            end

            C = Scores;
            n = length(Users);
            x = [1:n];            
            A = zeros(n,n);
            b = Caps;

            for ii=1:n
                for jj=1:n
                    if ii==jj
                        A(ii,jj) = Res(ii);
                    end
                end
            end
            
            if n > 2
                comb = nchoosek(1:n,2);
            else
                comb = [];
            end
            [comb_len, xxxx] = size(comb);

            for ii=1:comb_len
                ind_1 = comb(ii, 1);
                ind_2 = comb(ii, 2);
                if ESs(ind_1) == ESs(ind_2)
                    A(ind_1, ind_2) = A(ind_2, ind_2);
                    A(ind_2, ind_1) = A(ind_1, ind_1);
                end
            end

            lb = zeros(n,1);
            ub = ones(n,1);
            options = optimoptions('intlinprog','Display','none');        
        
            [xx, res, flag] = intlinprog(C, x, A, b, [],[],lb,ub,options);
        end
        x = xx;

        for j=1:length(Users)
            if isempty(x)
                rt = Rts_l(j);
                totalResp = totalResp + rt + 0.5;
                rejectCount = rejectCount + 1;
                continue;
            end
            
            if x(j) == 1
                e_id              = ESs(j);
                rt                = Rts_e(j);
                totalResp         = totalResp + rt;
                acceptCount       = acceptCount + 1;
                ES_capacity(e_id) = ES_capacity(e_id) - Res(j);
                ES_register(e_id) = i + rt;
            else
                rt = Rts_l(j);
                totalResp = totalResp + rt + 0.5;
                rejectCount = rejectCount + 1;
            end
        end
        time(end+1) = toc;
    end

    resp = totalResp / U_count;
    util = 1 - mean(ES_capacity./ori_ES_capacity);
    rejt = rejectCount / U_count;
    time = mean(time);
end