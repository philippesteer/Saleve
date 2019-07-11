function [up,nup]=upstreamNodes(nn,rec,nstack,rstack)
% Find the list of the upstream nodes draining towards each node

%% Use cell - much faster than matrix here
nup=zeros(nn,1);up=cell(nn,1);
for k=1:numel(nstack)
    % For all nodes that are not outlet
    for ij=1:nstack{k}-1
        ijk = rstack{k}(ij); 
        r   = rec(ijk);          
        up{r} = [up{r}  ijk  up{ijk}];
        nup(r)  =  nup(r) + 1  + nup(ijk);
    end
    % For the outlet only add himself
    ij=nstack{k};
    ijk = rstack{k}(ij);
    r   = rec(ijk);
    up{r} = [up{r}  ijk];
    nup(r)  =  nup(r) + 1;
end

%% Matrix version - less efficient
%
% nup=ones(nn,1);up=zeros(nn,1);
% for k=1:numel(nstack)
%     % For all nodes that are not outlet
%     for ij=1:nstack{k}-1
%         ijk = rstack{k}(ij); 
%         r=rec(ijk);
%         nup(r)=nup(r)+1;  
%         up(r,nup(r))=ijk; 
%         n=nup(ijk);
%         if n>1           
%             up(r,nup(r)+1:nup(r)+n-1)=up(ijk,2:n);
%             nup(r)=nup(r)+n-1;
%         end
%     end
%     % For the outlet only add himself
%     ij=nstack{k};
%     ijk = rstack{k}(ij); 
%     r=rec(ijk);
%     nup(r)=nup(r)+1;
%     up(r,nup(r))=ijk;   
% end
% up(:,1)=[];
% nup=nup-1;