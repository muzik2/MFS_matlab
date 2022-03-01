function [inds] = SelectBoundaryByRectangle(xr,yr,w,h,x,y)
    arguments
        xr (1,1) {mustBeNumeric, mustBeFinite} = 0;
        yr (1,1) {mustBeNumeric, mustBeFinite} = 0;
        w  (1,1) {mustBeNumeric, mustBeFinite} = 0;
        h  (1,1) {mustBeNumeric, mustBeFinite} = 0;
        x  (:,:) {mustBeNumeric, mustBeFinite} = [0,0.5,1];
        y  (:,:) {mustBeNumeric, mustBeFinite} = [0,0.5,1];
    end
    inds = find(x>=xr & y>=yr & x<=(xr+w) & y<=(yr+h));
    k = boundary(x(inds),y(inds),0.3);
    inds = inds(k(1:end-1));
end