function [crest_n,crest_dtdiff]=crestDisequilibrium(nn,ni,uptime,watershed)


% Find crest nodes
crest_n=zeros(nn,1);crest_dtdiff=zeros(nn,1);
for i=1:nn
    wi=watershed(i);
    ninode=ni{i};
    wni=watershed(ni{i});
    ninode(wni==wi)=[];
    crest_n(i)=numel(ninode);
    if isempty(ninode)==1
        crest_dtdiff(i)=0; 
    else
        crest_dtdiff(i)=max(abs(uptime(i)-uptime(ninode)));
    end
end