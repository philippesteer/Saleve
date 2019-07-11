function [z]=priorityFlood(z,ni,iborder)
% Compute the greatest slope smax and the receiver node ismax

% Initiate
Closed=false(size(z));
% Edges
c=iborder;
[~,isort]=sort(z(c),'ascend');
Open.n=c(isort);
Open.z=z(c(isort));
Closed(c)=true;
% While loop
while isempty(Open.n)==0 % | k<10400
    % Pop Open
    c=Open.n(1);Open.n(1)=[];Open.z(1)=[];
    nic=ni{c};
    for i=1:numel(nic)
        n=nic(i);
        if Closed(n)
        else
            z(n)=max(z(n),z(c));
            Closed(n)=true;
            [Open.z,isort]=sort(vertcat(Open.z,z(n)),'ascend');
            Open.n=vertcat(Open.n,n);Open.n=Open.n(isort);
        end
    end
end



