function [] = TestMultipleLocalModels()
    eps = 1e-5;
    mu = 1;
    res = load('MFSxyuv_11.mat');
    N = numel(res.X);
    bb = [min(res.X(:)),max(res.X(:)),min(res.Y(:)),max(res.Y(:))];
    dds = max([res.X(2)-res.X(1),res.Y(2)-res.Y(1)])*1.0001;
    %dd = dds*9.5;
    %dd = 0.29;
    dd = 0.6;
    
    plot(res.X(:),res.Y(:),'r+');
    hold on
    Uloc = res.X*0;
    Vloc = res.X*0;
    Uloc0 = res.X*0;
    Vloc0 = res.X*0;
    
    Ag = eye(2*N);
    %Ag = zeros(2*N);
    bg = zeros(2*N,1);
    UVg = zeros(2*N,1);
    
    b = 0;
    for i=1:N
        x = res.X(i);
        y = res.Y(i);
        xr = x-dds;
        yr = y-dds;
        w = 2*dds;
        h = 2*dds;
        if(abs(x-bb(1))>eps && abs(x-bb(2))>eps && abs(y-bb(3))>eps && abs(y-bb(4))>eps)
            inds = SelectBoundaryByRectangle(xr,yr,w,h,res.X,res.Y);
            n = FindNormals(res.X(inds),res.Y(inds));
            [xf,yf] = FakeNodes(res.X(inds),res.Y(inds),n,dd);
                       
            G = MakeMFSCharMatrix(res.X(inds),res.Y(inds),xf,yf);
            N = numel(inds);

            b = zeros(2*N,1);
            b(1:2:end) = res.u(inds);
            b(2:2:end) = res.v(inds);

            alpha = G\b;
            
            [uL,vL] = RecoverMFSResults(alpha,x,y,xf,yf,mu);
            Uloc(i) = uL;
            Vloc(i) = vL;
            %quiver(x,y,uL,vL);
            
            Row = MakeCharRow(x,y,res.X(inds),res.Y(inds),xf,yf);
            
            minds = zeros(1,length(inds)*2);
            minds(1:2:end) = inds*2-1;
            minds(2:2:end) = inds*2;
            Ag(i*2-1:i*2,minds) = Ag(i*2-1:i*2,minds)-Row;
            %UVg(i*2-1:i*2) = [uL;vL];
            UVg(i*2-1:i*2) = [res.u(i);res.v(i)];

            
            [uvL] = Row*b; 
            Uloc0(i) = uvL(1);
            Vloc0(i) = uvL(2);
            
            fprintf('%d\tUor = %0.9f\tU = %0.9f\tU0 = %0.9f\n \tVor = %0.9f\tV = %0.9f\tV0 = %0.9f\n',...
                     i,res.u(i),uL,uvL(1),res.v(i),vL,uvL(2));
            if(i==109)
               %plot(res.X(inds),res.Y(inds),'sk:',xf,yf,'+g');
               %quiver(res.X(inds),res.Y(inds),n(:,1),n(:,2),'color','b')
            end
        else
            Uloc(i) = res.u(i);
            Vloc(i) = res.v(i);
            Uloc0(i) = res.u(i);
            Vloc0(i) = res.v(i);
        end
    end
    quiver(res.X,res.Y,Uloc,Vloc,'color','b');
    quiver(res.X,res.Y,res.u,res.v,'color','r');
    hold off
    daspect([1,1,1]);
    axis([-0.2,1.2,-0.2,1.2]);
    xx = res.X(6,:);
    yy = Vloc(6,:);
    %plot(xx,yy);
    
    NN=numel(res.X);
    Bg = Ag*UVg;
    B = Bg*0;
    for i=1:NN
        if abs(res.X(i))<1e-5 || abs(res.X(i)-1)<1e-5 || abs(res.Y(i))<1e-5 || abs(res.Y(i)-1)<1e-5
            B(i*2-1) = res.u(i);
            B(i*2) = res.v(i);
        end
    end    
    
    %plot(Bg-B);
    UV = Ag\B;
    UU = UV(1:2:end);
    VV = UV(2:2:end);
    plot([0,1,1,0,0],[0,0,1,1,0],'-r');
    hold on
    %quiver(res.X(:),res.Y(:),UU(:),VV(:),'color','b');
    quiver(res.X(:),res.Y(:),Bg(1:2:end),Bg(2:2:end),'color','b');
    daspect([1,1,1]);
    hold off
end