function [] = TestMultipleLocalModels()
    eps = 1e-5;
    mu = 1;
    res = load('MFSxyuv_171.mat');
    N = numel(res.X);
    bb = [min(res.X(:)),max(res.X(:)),min(res.Y(:)),max(res.Y(:))];
    dds = max([res.X(2)-res.X(1),res.Y(2)-res.Y(1)])*1.0001;
    %dd = dds*0.2;
    dd = 0.01;
    
    plot(res.X(:),res.Y(:),'r+');
    hold on
    Uloc = res.X*0;
    Vloc = res.X*0;
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
            fprintf('Uor = %0.9f\tU = %0.9f\nVor = %0.9f\tV = %0.9f\n',res.u(i),uL,res.v(i),vL);
        else
            Uloc(i) = res.u(i);
            Vloc(i) = res.v(i);
        end
    end
    quiver(res.X,res.Y,Uloc,Vloc);
    hold off
    daspect([1,1,1]);
    axis([-0.2,1.2,-0.2,1.2]);
end