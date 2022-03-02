function [] = FindIIT(x,y)
    arguments
       x (1,:) {mustBeNumeric, mustBeFinite} = 1+[0,0.5,1,1,1,0.5,0,0]*1; 
       y (1,:) {mustBeNumeric, mustBeFinite} = 10+[0,0,0,0.5,1,1,1,0.5]*1;
    end
    N = numel(x);
    bb = [min(x),max(x),min(y),max(y)];
    dd = 0.25;
    
    xn = (1-2*dd)*(x-bb(1))/(bb(2)-bb(1));
    yn = (1-2*dd)*(y-bb(3))/(bb(4)-bb(3));
    A = ones(2*N+1);
    A(end,end) = 0;
    b = zeros(2*N+1,1);
    xi = bb(1)+(bb(2)-bb(1))*dd+xn*(bb(2)-bb(1));
    yi = bb(3)+(bb(4)-bb(3))*dd+yn*(bb(4)-bb(3));
    
    for i=1:N
        xs = [xi(i),yi(i)];
        b([i*2-1,i*2]) = [yi(i)^2,-xi(i)^2];
        for j=1:N
            g = StLet2D(xs,[x(j),y(j)]); 
            A([i*2-1,i*2],[j*2-1,j*2]) = g; 
        end
    end
    
    gama = A\b;
    
    
    for i=1:N
        xs = [x(i),y(i)];
        R = zeros(2,2*N);
        for j=1:N
           if(i~=j)
              g = StLet2D(xs,[x(j),y(j)]);
              R(:,[j*2-1,j*2]) = g;
           end
        end
        p = R*gama(1:end-1);
        q = [y(i)^2;-x(i)^2]-gama(end)-p;
        q=q;
    end
    
    plot(x,y,'ro-',xi,yi,'+k');
    daspect([1,1,1]);
    %axis([-0.2,1.2,-0.2,1.2]);
end