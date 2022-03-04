function [] = main()
    resolution = 11;
    dd = 0.2;
    [x,y,xf,yf,n] = MakeModel(dd,resolution);
    bb = [min(x(:)),max(x(:)),min(y(:)),max(y(:))];
    %{
    plot(x,y,'ro:',xf,yf,'+k');
    hold on
    quiver(x(:),y(:),n(:,1),n(:,2),'b');
    hold off
    daspect([1,1,1]);
    %}
    G = MakeMFSCharMatrix(x,y,xf,yf);
    N = numel(x);
    % najdi hornu stranu -> LID, ktory sa hybe
    %inds = find(abs(y-bb(4))<1e-5 & abs(x-bb(1))>1e-5 & abs(x-bb(2))>1e-5);
    inds = find(abs(y-bb(4))<1e-5);
    b = zeros(2*N,1);
    b(inds*2-1) = 1;
    %{
    for i=1:N
        b(i*2-1) = y(i)^2;
        b(i*2) = -x(i)^2;
    end
    %}
    alpha = G\b;
    
    
    [X,Y] = meshgrid(linspace(bb(1),bb(2),11),linspace(bb(3),bb(4),11));
    %disp(alpha);
    [u,v] = RecoverMFSResults(alpha,X,Y,xf,yf);
    
    %subplot(2,1,1);
    plot(x,y,'ro:',xf,yf,'+k');
    hold on
    %quiver(X(:),Y(:),u(:),v(:),'b','AutoScaleFactor',1.5);
    hold off
    daspect([1,1,1]);
    
    %fprintf('MaxV(y = 0.5) = %0.9f\n',max(yp));
    
    %{
    % Middle profile 
    ym = (bb(4)+bb(3))/2;
    [~,im] = min(abs(ym-Y(:)));
    pinds = find(abs(Y(:)-Y(im))<1e-5);
    
    xp = X(pinds);
    yp = v(pinds);
    subplot(2,1,2);
    plot(xp,yp);
    
    %filename = sprintf('MFSxyuv_%d.mat',resolution);
    %save(filename,'X','Y','u','v','dd','resolution','xf','yf');
    %}
    ti = 4*11-5;
    ddx = 1.003/(resolution-1);
    inds = SelectBoundaryByRectangle(X(ti)-ddx,Y(ti)-ddx,ddx*2,ddx*2,X(:),Y(:));
    finds = FindClosestPoints(X(inds),Y(inds),xf,yf);
    fac = 1;
    hold on
    plot(X(inds),Y(inds),'sk:');
    quiver(X(inds),Y(inds),u(inds)*fac,v(inds)*fac,'b','AutoScale','off');
    quiver(X(ti),Y(ti),u(ti)*fac,v(ti)*fac,'g','AutoScale','off');
    %plot(xf(finds),yf(finds),'sr');
    hold off
    
    fi = [3,4,5,16,27,28,35,36];
    nf = numel(fi);
    nn = numel(inds);
    A = zeros(2*nn,2*nf);
    b = zeros(2*nn,1);
    for i=1:nn
       xs = [X(inds(i)),Y(inds(i))];
       for j=1:nf
          g = StLet2D(xs,[xf(fi(j)),yf(fi(j))],1); 
          A([i*2-1,i*2],[j*2-1,j*2]) = g; 
       end
       b([i*2-1,i*2]) = [u(inds(i)),v(inds(i))];
    end
    
    alpha = A\b; 
    
    Xm = [X(ti),Y(ti)];
    row = zeros(2,2*nn);
    for j=1:nf
       g = StLet2D(Xm,[xf(fi(j)),yf(fi(j))],1); 
       row(:,[j*2-1,j*2]) = g; 
    end
    res = row*alpha;
    arow = row;%(:,ctx);
    ares = arow*alpha;
    
    Lrow = arow/A;
    res0 = Lrow*b;
    
    Um = res(1);
    Vm = res(2);
    fprintf('Uor = %0.9f\tU = %0.9f\tU0 = %0.9f\nVor = %0.9f\tV = %0.9f\tV0 = %0.9f\n',...
            u(ti),Um,res0(1),Vm,v(ti),res0(2));
end











