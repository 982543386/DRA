function circle(x, y, r, txt)
    %x and y are the coordinates of the center of the circle
    %r is the radius of the circle
    %0.01 is the angle step, bigger values will draw the circle faster but
    %you might notice imperfections (not very smooth)
    % color uisetcolor
    ang=0:0.01:2*pi; 
    xp=r*cos(ang);
    yp=r*sin(ang);
    plot(x+xp,y+yp, '-', 'linewidth', 1, 'color', [0.968627450980392         0.454901960784314         0.454901960784314]);
    if length(txt) ~= 0
        text(x-0.05, y-0.03, txt);
    end
end

