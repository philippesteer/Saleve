function [rec,donor,ndon,stack,rstack,nstack,idstack,label,ioutlet,ioutlet_logical]=orderNodes(nn,rec,nimax,slope,iborder,ni,x,y,z)
% function [rec,donor,ndon,stack,rstack,nstack,self,nself]=orderNodes(nn,rec,nimax,slope,iborder)

% Find outlet nodes (that drains outside the model)
ioutlet=find(slope<=0);
% Identify sinks (-1) from border nodes (1)
ioutlet_logical=ones(size(ioutlet)); [~,inegative]=setdiff(ioutlet,iborder);ioutlet_logical(inegative)=-1;
% Receiver nodes - outlets drain themself
rec(ioutlet)=ioutlet;

% Donors
ndon = zeros(nn,1); % number of donors
donor = zeros(nn,nimax); % donor list
for ij = 1:nn
    if rec(ij) ~= ij
        ijk = rec(ij);
        ndon(ijk) = ndon(ijk) + 1;
        donor(rec(ij),ndon(rec(ij))) = ij;
    end
end

% Build the stack
label=zeros(nn,1);
for k = 1:numel(ioutlet)
    nstack{k} = 0;
    stack{k} = [];
    ij=ioutlet(k);
    [stack{k},nstack{k}]=addtoStack(ij,ndon,donor,stack{k},nstack{k}); % recursive function
    label(stack{k})=ij.*ioutlet_logical(k); % identify if outlet is a sink (-) or a border (+)
end 

% Find outlets for sinks (endorheic catchments)
k=0;iok=1;
while iok>0
    % Increment the loop
    k=k+1;
    % If the index exceeds the number of outlets (or catchments) => restart
    if k>numel(ioutlet)
        k=1;
    end
    % Merge two catchments (one with a sink to one with no sink)
    if ioutlet_logical(k)<0 % if a catchment connected to a sink
        isink=ioutlet(k);
        neighb=vertcat(ni{stack{k}});
        ind=neighb(label(neighb)>0);
        if isempty(ind)==0
            % Find sill in nearby "positive" catchment (connected to a true outlet)
            % Choose minimum altitude
            [~,i]=min(z(ind));
%             % Or Choose maximum slope
%             s=(z(isink)-z(ind))./sqrt((x(isink)-x(ind)).^2+(y(isink)-y(ind)).^2);
%             [~,i]=min(s);
            
            isill=ind(i); % Node index of the sill
            lsill=label(isill); % Label index of the sill
            ksill=find(ioutlet==lsill); % Stack index of the sill in the outlet list
            jsill=find(stack{ksill}==isill); % 
            % Connect this local sink to this sill
            rec(ioutlet)=isill;
            ndon(isill)=ndon(isill)+1;
            donor(isill,ndon(isill))=ioutlet(k);
            % Update the stack
            nstack{ksill}=nstack{ksill}+nstack{k};
            if jsill==numel(stack{ksill})
                stack{ksill}=[stack{ksill} stack{k}];         
            else
                stack{ksill}=[stack{ksill}(1:jsill) stack{k} stack{ksill}(jsill+1:end)];
            end
            label(stack{k})=lsill;           
            % Remove this old stack (that has been connect to a "positive" catchment")
            if k<numel(ioutlet)
                stack(k:end-1)   = stack(k+1:end);
                nstack(k:end-1)  = nstack(k+1:end);
                ioutlet(k:end-1)   = ioutlet(k+1:end);
                ioutlet_logical(k:end-1) = ioutlet_logical(k+1:end);
            end
            stack(end)=[];
            nstack(end)=[];
            ioutlet(end)=[];
            ioutlet_logical(end)=[];
        end
    end
    iok=numel(find(ioutlet_logical==-1));
end    

% Reverse the stack 
for k = 1:numel(ioutlet)
    rec(ioutlet)=ioutlet;
    rstack{k}=fliplr(stack{k});     
end

% Stack number identifier
idstack=zeros(nn,1);
for k=1:numel(nstack)
    idstack(stack{k})=k;
end

end

