function [u,v] = RecoverMFSResults(alpha,x,y,xf,yf,mu)
    arguments
        alpha (:,1) {mustBeNumeric, mustBeFinite} = ones(1,5);
        x (:,:) {mustBeNumeric, mustBeFinite} = zeros(5,5);
        y (:,:) {mustBeNumeric, mustBeFinite} = zeros(5,5);
        xf (:,1) {mustBeNumeric, mustBeFinite} = ones(1,5);
        yf (:,1) {mustBeNumeric, mustBeFinite} = ones(1,5);
        mu (1,1) {mustBeNumeric, mustBeFinite} = 1;
    end
    
    N = numel(x);
    Nf = numel(xf);
    
    row = zeros(2,Nf);
    u = x*0;
    v = x*0;
    for i=1:N
        xs = [x(i),y(i)];
        for j=1:Nf
           g = StLet2D(xs,[xf(j),yf(j)],mu); 
           row(:,j*2-1:j*2) = g;
        end
        res = row*alpha;
        u(i) = res(1);
        v(i) = res(2);
    end
end