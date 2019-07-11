function [slope,rec]=greatestSlope(nn,x,y,z,DT,ni)
% Compute the greatest slope smax and the receiver node ismax

slope=zeros(nn,1);
rec=zeros(nn,1);
for i=1:numel(DT.Points(:,1))
    dx=x(i)-x(ni{i});
    dy=y(i)-y(ni{i});
    dz=z(i)-z(ni{i});
    s=dz./(dx.^2+dy.^2).^0.5;
    [slope(i),rec(i)]=max(s);
    rec(i)=ni{i}(rec(i));
end



