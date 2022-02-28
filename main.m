function [] = main()
    [x,y,xf,yf,n] = MakeModel(0.05,91);
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
    
    alpha = G\b;
    
    
    [X,Y] = meshgrid(linspace(bb(1),bb(2),21),linspace(bb(3),bb(4),21));
    %disp(alpha);
    [u,v] = RecoverMFSResults(alpha,X,Y,xf,yf);
    
    subplot(2,1,1);
    plot(x,y,'ro:',xf,yf,'+k');
    hold on
    quiver(X(:),Y(:),u(:),v(:),'b','AutoScaleFactor',1.5);
    hold off
    daspect([1,1,1]);
    
    % Middle profile 
    ym = (bb(4)+bb(3))/2;
    [~,im] = min(abs(ym-Y(:)));
    pinds = find(abs(Y(:)-Y(im))<1e-5);
    
    xp = X(pinds);
    yp = v(pinds);
    subplot(2,1,2);
    plot(xp,yp);
    fprintf('MaxV(y = 0.5) = %0.9f\n',max(yp));
end