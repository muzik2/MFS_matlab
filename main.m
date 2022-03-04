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
    
    %{
    subplot(2,1,1);
    %}
    plot(x,y,'ro:',xf,yf,'+k');
    for i=1:numel(xf)
       text(xf(i),yf(i),sprintf(' %d',i));
    end
    hold on
    %quiver(X(:),Y(:),u(:),v(:),'b','AutoScaleFactor',1.5);
    hold off
    daspect([1,1,1]);
   
    
    % LOCAL PART
    eps = 1e-5;
    N = numel(X);
    Al = eye(2*N);
    bl = zeros(2*N,1);
    uv = zeros(2*N,1);
    uv(1:2:end) = u;
    uv(2:2:end) = v;
    for i=1:N
        %ti = 8*11-2;
        %i = 91;
        if(X(i)>eps && X(i)<1-eps && Y(i)>eps && Y(i)<1-eps)
            ddx = 1.003/(resolution-1);
            inds = SelectBoundaryByRectangle(X(i)-ddx,Y(i)-ddx,ddx*2,ddx*2,X(:),Y(:));
            
            if i==13 || true
                [r,c] = ind2sub(size(X),i);
                %fii = [c-1,c,c+1,10+r,31-c,32-c,33-c,42-r];
                %fii = [2,16,17,18,30,34,35,36];
                %[row0,Rcols] = GetLocalMFSRow(X(i),Y(i),X(inds),Y(inds),xf(fii),yf(fii),u(inds),v(inds));
                [row0,Rcols] = GetLocalMFSRow(X(i),Y(i),X(inds),Y(inds),xf,yf,u(inds),v(inds));
                finds=unique(floor((Rcols+1)/2));
                
                fac = 1;
                hold on
                plot(X(inds),Y(inds),'sk:');
                quiver(X(inds),Y(inds),u(inds)*fac,v(inds)*fac,'b','AutoScale','off');
                quiver(X(i),Y(i),u(i)*fac,v(i)*fac,'g','AutoScale','off');
                plot(xf(finds),yf(finds),'sr');
                hold off
                
                fprintf('(%d, %d)\n',r,c);
                pp = 1; 
            else
                [row0,Rcols] = GetLocalMFSRow(X(i),Y(i),X(inds),Y(inds),xf,yf,u(inds),v(inds));
                finds=unique(floor((Rcols+1)/2));
            end
            
            
            
            nn = numel(inds);
            b = zeros(2*nn,1);
            b(1:2:end) = u(inds);
            b(2:2:end) = v(inds);
            ii = zeros(2*nn,1);
            ii(1:2:end) = inds*2-1;
            ii(2:2:end) = inds*2;
            res0 = row0*b;
            
            Al([i*2-1,i*2],ii) = -row0;
            fprintf('%d\tUor = % .7f\tVor = % .7f\n \tU   = % .7f\tV   = % .7f\n',i,u(i),v(i),res0(1),res0(2));
        else
            bl(i*2-1) = u(i);
            bl(i*2) = v(i);
            fprintf('%d\tUor = % .7f\tVor = % .7f\n',i,u(i),v(i));
        end
    end
    res = Al*uv-bl;
    %res = Al\bl;
    
    Ul = res(1:2:end);
    Vl = res(2:2:end);
    
    plot(x,y,'ro:',xf,yf,'+k');
    hold on
    quiver(X(:),Y(:),Ul(:),Vl(:),'b','AutoScaleFactor',1.5);
    hold off
    daspect([1,1,1]);
    
    %plot(res);
    pp = 1;
end











