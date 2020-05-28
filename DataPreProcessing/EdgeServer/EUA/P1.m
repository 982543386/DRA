clear all
clc

% EUA_Basestations_ori.mat (longitude and latitude) => EUA_BaseStations.mat (meters)


% Lower-left reference point: -37.82117612446662, 144.9549965367283
% Upper-left reference point: -37.81313439053935, 144.9513187173424
% Lower-right reference point: -37.81524024624075, 144.9748200238013

% Upper-left: (-37.813134, 144.951319)
% Lower-right: (-37.815240, 144.974820)

P_0 = [144.9549965367283, -37.82117612446662];   % Lower-left reference point
P_1 = [144.9513187173424, -37.81313439053935];   % Upper-left reference point
P_2 = [144.9748200238013, -37.81524024624075];   % Lower-right reference point

V_1 = P_1 - P_0;
V_2 = P_2 - P_0;


[k1, b1] = getKandB(P_0(1), P_0(2), P_1(1), P_1(2));
[k2, b2] = getKandB(P_0(1), P_0(2), P_2(1), P_2(2));
A1 = k1; B1 = -1; C1 = b1;
A2 = k2; B2 = -1; C2 = b2;

load('./mats/EUA_Basestations_ori.mat');

xscal_ori = P_2(1) - P_0(1);
yscal_ori = P_1(2) - P_0(2);

xscal = (P_2(1) - P_0(1)) * 111;   % 1880
yscal = (P_1(2) - P_0(2)) * 111;   % 968


BSPosition = [];
for i=1:length(BasestationPosition)
    Px = [BasestationPosition(i, 2), BasestationPosition(i, 1)];
    dx = abs(A1*Px(1) + B1*Px(2) + C1) / sqrt(A1*A1 + B1*B1);
    dy = abs(A2*Px(1) + B2*Px(2) + C2) / sqrt(A2*A2 + B2*B2);
    BSPosition(i, :) = [dx/xscal_ori*xscal, dy/yscal_ori*yscal];
end


figure();
set(gcf, 'Position', [200, 200, 600, 300]);
for i=1:length(BasestationPosition)
  plot(BSPosition(i,1), BSPosition(i,2), '*')  
  hold on
end


EdgeServers = BSPosition;
save('./mats/ES_P1.mat', 'EdgeServers', 'xscal', 'yscal');


function [k,b] = getKandB(x1, y1, x2, y2)
    k = (y1-y2) / (x1-x2);
    b1 = y1-k*x1;
    b2 = y2-k*x2;
    b = (b1+b2)/2;
end




