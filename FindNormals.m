function [n] = FindNormals(x,y)
    k = boundary(x(:),y(:),0.1);
    k = k(1:end-1);
    N = numel(k);
    n = zeros(N,2);
        
    for i=1:N
       %si = k(i); 
       if i==1
          sib = k(N);
          sia = k(2);
       elseif(i==N)
          sib = k(N-1);
          sia = k(1); 
       else
          sib = k(i-1);  
          sia = k(i+1);
       end
       
       Vab = [x(sib)-x(sia),y(sib)-y(sia)];
       oVab = [-Vab(2),Vab(1)]/norm(Vab);
       n(i,:) = oVab;   
    end
end