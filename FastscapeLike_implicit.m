clearvars; clearvars –global; close all;
addpath('GIS_Utilities','FiniteDiff_Utilities');
global  parSPM;

% Model parameters
modelInput();
% Make irregular grid
[x,y,z,DT,xlimit,ylimit,iborder,nn,meanarea]=makeGrid();
% Compute river profile evolution
for it=1:parSPM.nt
    it
    nn=numel(x);
    % Update precipitation vector
    P=parSPM.P.*ones(nn,1);
    % Triangulation
    DT = delaunayTriangulation(x,y);
    % Find indices of border nodes
    iborder=find( x==xlimit(1) | x==xlimit(2) | y==ylimit(1) | y==ylimit(2) );
    % Find direct neighbours and compute the local surface area bounded to each node (voronoiDiagram)
    [surface,sides,V,ni,nimax,iproblem] =localGeometry(nn,DT,meanarea);
    % Determine greatest slope, receiver nodes and fill depressions (i.e. with negative slope)
    [slope,rec] = greatestSlope(nn,x,y,z,DT,ni);
    % Order nodes using the fastscape algorithm  
    [rec,donor,ndon,stack,rstack,nstack,label,ioutlet,ioutlet_logical]=orderNodes(nn,rec,nimax,slope,iborder,ni,x,y,z);     
    % Compute drainage and discharge
    [area,discharge]=drainageArea(nn,rec,rstack,nstack,surface);
    % Generate logical array of border nodes
    iborder_logical=zeros(nn,1);iborder_logical(iborder)=1;
    % Uplift
    z(~iborder_logical)=z(~iborder_logical)+parSPM.U(~iborder_logical).*parSPM.dt;
    % River erosion
    % [z,e]=expliciterosionEulerian(z,area,discharge,slope); % Explicit solution
    [z,e_r,cfl_r]=impliciterosionEulerian(x,y,z,discharge,stack,nstack,rec); % Implicit solution    
    % Compute erosion rate (m/d)
    zsave{it}=z;
    esave{it}=-e_r./(parSPM.dt);
    % Plot
    scatter(x,y,10,z,'fill');colorbar;title(['it=' num2str(it) '     t=' num2str(parSPM.t(it)./365) ' yr     nn=' num2str(nn) '     CFL_{max}=' num2str(max(cfl_r))]);drawnow;    
end
Uvec=ones(size(parSPM.t)).*parSPM.U;
