function [xf,yf] = FakeNodes(x,y,n,dd)
    arguments
        x(:,1)  {mustBeNumeric,mustBeReal}
        y(:,1)  {mustBeNumeric,mustBeReal}
        n(:,2)  {mustBeNumeric,mustBeReal}
        dd(1,1) {mustBeNumeric,mustBeReal} = 0.1
    end
    xf = x+n(:,1)*dd;
    yf = y+n(:,2)*dd;
end