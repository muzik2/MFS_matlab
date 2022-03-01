function [] = SelectorTest()
    [x,y] = meshgrid(linspace(0,1,21));
    dd = max(abs([x(2)-x(1),y(2)-y(1)]))*1.001; % slightly larger
    
    ii = round(numel(x)/5);
    
    ss = 3;
    xr = x(ii)-ss*dd;
    yr = y(ii)-ss*dd;
    w = 2*ss*dd;
    h = 2*ss*dd;
    
    %inds = SelectByRectangle(xr,yr,w,h,x,y);
    inds = SelectBoundaryByRectangle(xr,yr,w,h,x,y);
    
    plot(x(:),y(:),'+k',x(inds),y(inds),'or:',x(ii),y(ii),'sb');
    daspect([1,1,1]);
    axis([-0.2,1.2,-0.2,1.2]);
    
end

function [inds] = SelectByRectangle(xr,yr,w,h,x,y)
    arguments
        xr (1,1) {mustBeNumeric, mustBeFinite} = 0;
        yr (1,1) {mustBeNumeric, mustBeFinite} = 0;
        w  (1,1) {mustBeNumeric, mustBeFinite} = 0;
        h  (1,1) {mustBeNumeric, mustBeFinite} = 0;
        x  (:,:) {mustBeNumeric, mustBeFinite} = [0,0.5,1];
        y  (:,:) {mustBeNumeric, mustBeFinite} = [0,0.5,1];
    end
    inds = find(x>=xr & y>=yr & x<=(xr+w) & y<=(yr+h));
end