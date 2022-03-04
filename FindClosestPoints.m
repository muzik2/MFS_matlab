function [inds] = FindClosestPoints(xs,ys,x,y)
    arguments
        xs (1,:) {mustBeNumeric, mustBeFinite} = 0;
        ys (1,:) {mustBeNumeric, mustBeFinite} = 0;
        x  (1,:) {mustBeNumeric, mustBeFinite} = [0,0.5,1];
        y  (1,:) {mustBeNumeric, mustBeFinite} = [0,0.5,1];
    end
    n = numel(xs);
    inds = zeros(1,n);
    for i=1:n
        r2 = ((xs(i)-x(:)).^2+(ys(i)-y(:)).^2);
        [~,mi] = min(r2);
        inds(i) = mi;
    end
end