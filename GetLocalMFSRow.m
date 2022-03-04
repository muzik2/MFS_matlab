function [Arow,rcols] = GetLocalMFSRow(xi,yi,x,y,xf,yf,u,v)
    arguments
        xi (1,1) {mustBeNumeric, mustBeFinite} = 0;
        yi (1,1) {mustBeNumeric, mustBeFinite} = 0;
        x  (1,:) {mustBeNumeric, mustBeFinite} = [-0.5,0,0.5,0.5,0.5,0,-0.5,-0.5];
        y  (1,:) {mustBeNumeric, mustBeFinite} = [-0.5,-0.5,-0.5,0,0.5,0.5,0.5,0];
        xf (1,:) {mustBeNumeric, mustBeFinite} = [-0.7,0,0.7,0.7,0.7,0,-0.7,-0.7];
        yf (1,:) {mustBeNumeric, mustBeFinite} = [-0.7,-0.7,-0.7,0,0.7,0.7,0.7,0];
        u  (1,:) {mustBeNumeric, mustBeFinite} = [-1,-1,-1,0,1,1,1,0];
        v  (1,:) {mustBeNumeric, mustBeFinite} = [0,0,0,-1,0,0,0,1]; 
    end
    %plot(x,y,'ro-',xf,yf,'k+');
    
    nf = numel(xf);
    nn = numel(x);
    A = zeros(2*nn,2*nf);
    b = zeros(2*nn,1);
    for i=1:nn
       xs = [x(i),y(i)];
       for j=1:nf
          g = StLet2D(xs,[xf(j),yf(j)],1); 
          A([i*2-1,i*2],[j*2-1,j*2]) = g; 
       end
       b([i*2-1,i*2]) = [u(i),v(i)];
    end
    
    alpha0 = A\b; 
    rcols = find(abs(alpha0)>1e-5);
    
    A = A(:,rcols);
    
    row = zeros(2,2*nf);
    for j=1:nf
       g = StLet2D([xi,yi],[xf(j),yf(j)],1); 
       row(:,[j*2-1,j*2]) = g; 
    end
    
    res = row*alpha0;
    UU = res(1);
    VV = res(2);
    
    Arow = row(:,rcols)/A;
    %Frow = zeros(2,2*nf);
    %Frow(:,rcols) = Arow;
end