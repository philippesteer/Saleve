function [down,ndown,ddown]=downstreamNodes(nn,x,y,rec,nstack,stack)
% Find the list of the upstream nodes draining towards each node

ndown=zeros(nn,1);ddown=zeros(nn,1);down=cell(nn,1);
for k=1:numel(nstack)
    for ij=1:nstack{k}
        ijk = stack{k}(ij);
        r=rec(ijk,:);
        down{ijk} = [down{r}  ijk];
        ndown(ijk)  =  ndown(r) + 1;
        ddown(ijk)  =  ddown(r) + sqrt( (x(r)-x(ijk)).^2+ (y(r)-y(ijk)).^2 );
    end
end