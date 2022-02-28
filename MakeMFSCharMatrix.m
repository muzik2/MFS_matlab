function [G] = MakeMFSCharMatrix(x,y,xf,yf)
    arguments
        x (1,:) {mustBeNumeric, mustBeFinite} = [0,0.5,1,1,1,0.5,0,0];
        y (1,:) {mustBeNumeric, mustBeFinite} = [0,0,0,0.5,1,1,1,0.5];
        xf (1,:) {mustBeNumeric, mustBeFinite} = []
        yf (1,:) {mustBeNumeric, mustBeFinite} = []
    end
    mu = 1;
    if(isempty(xf) || isempty(yf))
        dd = max([max(x)-min(x),max(y)-min(y)]);
        [xf,yf] = FakeNodes(x,y,n,dd*0.2);
    end
    N = numel(x);
    G = zeros(2*N);
    
    for i=1:N
       xs = [x(i),y(i)];
       for j=1:N
          g = StLet2D(xs,[xf(j),yf(j)],mu); 
          G([i*2-1,i*2],[j*2-1,j*2]) = g;
       end
    end
end