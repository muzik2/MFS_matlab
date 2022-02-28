function [x,y,xf,yf,n] = MakeModel(dd,nx,ny,x0,y0,w,h)
    arguments
       dd (1,1) {mustBeNumeric, mustBeFinite} = 0.3;
       nx (1,1) {mustBeNumeric, mustBeFinite} = 11;
       ny (1,1) {mustBeNumeric, mustBeFinite} = nx; 
       x0 (1,1) {mustBeNumeric, mustBeFinite} = 0;
       y0 (1,1) {mustBeNumeric, mustBeFinite} = 0;
       w (1,1) {mustBeNumeric, mustBeFinite} = 1;
       h (1,1) {mustBeNumeric, mustBeFinite} = 1; 
    end
    
    xx = linspace(x0,x0+w,nx);
    yy = linspace(y0,y0+h,ny);
    yy = yy(2:end-1);
    
    x = [xx,yy*0+(x0+w),fliplr(xx),yy*0+x0];
    y = [xx*0+y0,yy,xx*0+(y0+h),fliplr(yy)];
    n = FindNormals(x,y);
    [xf,yf] = FakeNodes(x,y,n,dd);
end