function [] = FindIIT(x,y)
    arguments
       x (1,:) {mustBeNumeric, mustBeFinite} = [0,0.5,1,1,1,0.5,0,0]; 
       y (1,:) {mustBeNumeric, mustBeFinite} = [0,0,0,0.5,1,1,1,0.5];
    end
    
    nx = 16;
    nnodes = (nx-1)*4;
    nsq = ceil(sqrt(nnodes));
    
    px = linspace(0,1,nx);
    py = px(2:end-1);
    x = [px,py*0+1,fliplr(px),py*0];
    y = [px*0,py,px*0+1,fliplr(py)];
    
    
    N = numel(x);
    bb = [min(x),max(x),min(y),max(y)];
    dd = 0.2;
    
    xn = (1-2*dd)*(x-bb(1))/(bb(2)-bb(1));
    yn = (1-2*dd)*(y-bb(3))/(bb(4)-bb(3));
    A = zeros(2*N+2);
    
    b = zeros(2*N+2,1);
    xi = bb(1)+(bb(2)-bb(1))*dd+xn*(bb(2)-bb(1));
    yi = bb(3)+(bb(4)-bb(3))*dd+yn*(bb(4)-bb(3));
    
    dx = 1/nsq;
    [Xi,Yi] = meshgrid(dx/2:dx:1);
    xi = Xi(1:nnodes)';
    yi = Yi(1:nnodes)';
    
    for i=1:N
        xs = [xi(i),yi(i)];
        b([i*2-1,i*2]) = [yi(i)^2,-xi(i)^2];
        for j=1:N
            g = StLet2D(xs,[x(j),y(j)]); 
            A([i*2-1,i*2],[j*2-1,j*2]) = g; 
        end
        A(end-1:end,i*2-1:i*2)=eye(2);
        A(i*2-1:i*2,end-1:end)=eye(2);
    end
    
    gama = A\b;
    
    G = zeros(2,2*N);
    for i=1:N
        xs = [x(i),y(i)];
        R = zeros(2,2*N);
        for j=1:N
           if(i~=j)
              g = StLet2D(xs,[x(j),y(j)]);
              R(:,[j*2-1,j*2]) = g;
           end
        end
        p = R*gama(1:end-2);
        c = gama(end-1:end);
        v = [y(i)^2;-x(i)^2];
        L = v-c-p;
        gx = gama(i*2-1);
        gy = gama(i*2);
        AA = [gx,gy;gy,gx];
        U = AA\L;
        U11 = L(1)/gx;
        U22 = L(2)/gy;
        g0 = [U(1),U(2);U(2),U(1)];
        g0 = [U11,0;0,U22];
        G(:,i*2-1:i*2) = g0;
    end
    
    plot(x,y,'ro-',xi,yi,'+k');
    daspect([1,1,1]);
    axis([-0.2,1.2,-0.2,1.2]);
    
    % skusim kavitu
    A = zeros(2*N);
    b = zeros(2*N,1);
    
    for i=1:N
        xs = [x(i),y(i)];
        for j=1:N
           if(i~=j)
              g = StLet2D(xs,[x(j),y(j)]);
              A([i*2-1,i*2],[j*2-1,j*2]) = g;
           else
              A([i*2-1,i*2],[i*2-1,i*2]) = G(:,i*2-1:i*2);
           end
        end
        if(abs(y(i)-1)<1e-5)
            %b([i*2-1,i*2]) = [xs(2)^2,-xs(1)^2];
            b(i*2-1) = 1;
        end
    end
    alpha = A\b;
    
    [xx,yy] = meshgrid(linspace(0.1,0.9,9));
    uu = xx*0;
    vv = xx*0;
    uua = xx*0;
    vva = xx*0;
    NN = numel(xx);
    R = zeros(2,2*N);
    for i=1:NN
        xs = [xx(i),yy(i)];
        for j=1:N
            g = StLet2D(xs,[x(j),y(j)]);
            R(:,[j*2-1,j*2]) = g;
        end
        res = R*alpha;
        uu(i) = res(1);
        vv(i) = res(2);
        uua(i) = xs(2)^2;
        vva(i) = -xs(1)^2;
    end
    
    subplot(1,2,1);
    q = quiver(xx(:),yy(:),uu(:),vv(:),1);
    
    hold on
    q = quiver(x(:),y(:),y(:).^2,-x(:).^2,1);
    
    plot([0,1,1,0,0],[0,0,1,1,0],'r-');
    hold off
    daspect([1,1,1]);
    
    subplot(1,2,2);
    quiver(xx(:),yy(:),uua(:),vva(:),1);
    hold on
    quiver(x(:),y(:),y(:).^2,-x(:).^2,1);
    plot([0,1,1,0,0],[0,0,1,1,0],'r-');
    hold off
    daspect([1,1,1]);
end





