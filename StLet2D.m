function [G] = StLet2D(xs,xr,mu)
    dx = xs(1)-xr(1);
    dy = xs(2)-xr(2);
    r2 = dx^2+dy^2;
    r = sqrt(r2);
    g = log(1/r);
    un = [dx^2, dx*dy; dy*dx, dy^2]/r2;
    us = [g,0;0,g];
    G = -1/4/pi/mu*(us+un);
end