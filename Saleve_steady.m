clearvars; clearvars –global; close all;
addpath('GIS_Utilities','Viewing_Utilities')
global  parSPM;

% Model parameters
modelInput();
% % Make irregular grid
[x,y,z,DT,xlimit,ylimit,iborder,nn,meanarea]=makeGrid();
% Find direct neighbours and compute the local surface area bounded to each node (voronoiDiagram)
[surface,sides,V,ni,nimax,iproblem] =localGeometry(nn,DT,meanarea);
% Determine greatest slope, receiver nodes and fill depressions (i.e. with negative slope)
for i=1:parSPM.Niter
[slope,rec] = greatestSlope(nn,x,y,z,DT,ni);
% Order nodes using the fastscape algorithm
[rec,donor,ndon,stack,rstack,nstack,idstack,label,ioutlet,ioutlet_logical]=orderNodes(nn,rec,nimax,slope,iborder,ni,x,y,z);
% Compute drainage and discharge
[area,discharge]=drainageArea(nn,rec,rstack,nstack,surface);
% Compute upstream distance
[updist,uptime]=upstreamDistance(nn,x,y,discharge,donor,nstack,stack);
% find contributive nodes
[up,nup]=upstreamNodes(nn,rec,nstack,rstack);
% Crest disequilibrium
[watershed]=computeWatershed(nn,nstack,stack);
[crest_n,crest_dtdiff]=crestDisequilibrium(nn,ni,uptime,watershed);
% Compute topography by stream power erosion
subuptime=uptime;subuptime(subuptime>parSPM.T)=parSPM.T;
% % Uniform uplift
% for k=1:numel(nstack)
%     zbase=z(stack{k}(1));
%     z(stack{k})=zbase+parSPM.U.*subuptime(stack{k});
% end
for k=1:numel(nstack)
    for ij=1:nstack{k}
        ijk = stack{k}(ij);
        zbase=z(rec(ijk));
        z(ijk)=zbase+parSPM.U(ijk).*(subuptime(ijk)-subuptime(rec(ijk)));
    end
end
% Ensure base level
z(iborder)=0;
% Compute erosion rates
e=parSPM.U.*parSPM.T-z;
disequilibrium(i)=sum(crest_dtdiff)./numel(crest_n>1);
zave{i}=z;
% Plot results
subplot(1,2,1);scatter(x,y,10,z,'fill');colorbar;xlabel('x (m)');ylabel('y (m)');title('z (m)');axis square equal tight;
subplot(1,2,2);plot(i,disequilibrium(i),'ob'); axis square; hold on;
drawnow
end
