clearvars; clearvars –global; close all;
addpath('GIS_Utilities','Viewing_Utilities')
global  parSPM;

% Model parameters
modelInput();

% % Make irregular grid
[x,y,z,DT,xlimit,ylimit,iborder,nn,meanarea]=makeGrid();
% Find direct neighbours and compute the local surface area bounded to each node (voronoiDiagram)
[surface,sides,V,ni,nimax,iproblem] =localGeometry(nn,DT,meanarea);
Uvec=ones(size(parSPM.t)+[0 1]).*mean(parSPM.U);
% River erosion
for it=1:parSPM.nt
    it
    % Determine greatest slope and receiver nodes
    [slope,rec] = greatestSlope(nn,x,y,z,DT,ni);
    % Order nodes using the fastscape algorithm
    [rec,donor,ndon,stack,rstack,nstack,idstack,label,ioutlet,ioutlet_logical]=orderNodes(nn,rec,nimax,slope,iborder,ni,x,y,z);
    % Compute drainage and discharge
    [area,discharge]=drainageArea(nn,rec,rstack,nstack,surface);
    % Compute upstream distance
    [updist,uptime]=upstreamDistance(nn,x,y,discharge,donor,nstack,stack);
    % Save elevation
    zold=z;    
    % Compute the "memory uplift " map (uplift at the time when each slope
    % patch was generated)   
    subuptime=uptime;subuptime(subuptime>parSPM.t(it))=parSPM.t(it); subuptime(discharge<parSPM.Qc)=parSPM.t(it); 
    Umem=ones(size(x)).*Uvec(it);
    for j=2:numel(Uvec(1:it))
        ind=find(subuptime>= -(parSPM.t(j)-parSPM.t(it)) & subuptime<-(parSPM.t(j-1)-parSPM.t(it)) );
        Umem(ind)=Uvec(j);
    end
    % River Erosion
    for k=1:numel(nstack)
        for ij=1:nstack{k}
            ijk = stack{k}(ij);
            zbase=z(rec(ijk));        
            z(ijk)=zbase+Umem(ijk).*(subuptime(ijk)-subuptime(rec(ijk)));
        end
    end
    % Ensure base level
    z(iborder)=0;
    % Compute erosion rate (m/d)
    e=(zold+Uvec(it).*parSPM.dt-z)./(parSPM.dt);
    zsave{it}=z;
    esave{it}=e;
    
    % Plot
    scatter(x,y,20,z,'fill');colorbar;xlabel('x (m)');ylabel('y (m)');title(['it=' num2str(it)]);axis square equal tight;
    drawnow;
end
