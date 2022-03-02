function [Row] = MakeCharRow(x0,y0,x,y,xf,yf)
    arguments
        x0 (1,1) {mustBeNumeric, mustBeFinite} = 0.5;
        y0 (1,1) {mustBeNumeric, mustBeFinite} = 0.5;
        x (1,:) {mustBeNumeric, mustBeFinite} = [0,0.5,1,1,1,0.5,0,0];
        y (1,:) {mustBeNumeric, mustBeFinite} = [0,0,0,0.5,1,1,1,0.5];
        xf (1,:) {mustBeNumeric, mustBeFinite} = []
        yf (1,:) {mustBeNumeric, mustBeFinite} = []
    end
    mu = 1;
    G = MakeMFSCharMatrix(x,y,xf,yf);
    Nf = numel(xf);
    row = zeros(2,Nf);
    xs = [x0,y0];
    for i=1:Nf
        g = StLet2D(xs,[xf(i),yf(i)],mu); 
        row(:,i*2-1:i*2) = g;
    end
    Row = row/G;
end