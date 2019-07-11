function [downdist]=downstreamDistance(nn,x,y,rec,nstack,rstack)
% Compute maximum downstream to the crests

global parSPM

downdist=zeros(nn,1);
for k=1:numel(nstack)
    for ij=1:nstack{k}
        ijk = rstack{k}(ij);
        d=rec(ijk,:);d(d==0)=[];
        length=sqrt((x(ijk)-x(d)).^2+(y(ijk)-y(d)).^2);
        downdist(d)=max(downdist(d),downdist(ijk)+length);
    end
end

