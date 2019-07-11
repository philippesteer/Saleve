function [x,y,z,DT,xlimit,ylimit,iborder,nn,meanarea]=makeGrid()
% Generate an irregular grid

global parSPM

% Grid nodes
x=rand(parSPM.npt,1).*parSPM.L;xlimit=[0 parSPM.L];
y=rand(parSPM.npt,1).*parSPM.L;ylimit=[0 parSPM.L];
xmean=mean(x);ymean=mean(y);
z=zeros(size(x))+rand(parSPM.npt,1)./1e6;
% Boundary nodes (limiting model domain)
nborder=100;
xb1=[0:parSPM.L./nborder:parSPM.L];yb1=xb1.*0;      xb2=[0:parSPM.L./nborder:parSPM.L];yb2=xb2.*0+parSPM.L;      yb3=[0:parSPM.L./nborder:parSPM.L];xb3=yb3.*0;      yb4=[0:parSPM.L./nborder:parSPM.L];xb4=yb4.*0+parSPM.L;      
xb=[xb1 xb2 xb3 xb4];yb=[yb1 yb2 yb3 yb4];zb=zeros(size(xb));
Pos=[xb' yb' zb'];Pos=unique(Pos,'rows');xb=Pos(:,1);yb=Pos(:,2);zb=Pos(:,3);
% Merge grid and boundary nodes
x=vertcat(xb,x);y=vertcat(yb,y);z=vertcat(zb,z);Pos=unique([x y z],'rows','stable');
x=Pos(:,1);y=Pos(:,2);z=Pos(:,3);  
% Triangulation
DT = delaunayTriangulation(x,y);
% Find border nodes
iborder=find( x==xlimit(1) | x==xlimit(2) | y==ylimit(1) | y==ylimit(2) );
% Numel of nodes
nn=numel(x);
% Update mean node area
meanarea=(xlimit(2)-xlimit(1)).*(ylimit(2)-ylimit(1))./nn;

% Erodability map
parSPM.K=parSPM.K.*ones(nn,1);
%ind=find(x<xlimit(1)+(xlimit(2)-xlimit(1))/2); parSPM.K(ind)=parSPM.K(ind)./5;

% Precipitation map
parSPM.P=parSPM.P.*ones(nn,1);
%ind=find(x<xlimit(1)+(xlimit(2)-xlimit(1))/2); parSPM.P(ind)=parSPM.P(ind)./5;
%parSPM.P=parSPM.P.*2.*(x./(xlimit(2)-xlimit(1)));

% Uplift map
parSPM.U=parSPM.U.*ones(size(x));
% parSPM.U=2.*(x-min(x)).*parSPM.U./(max(x)-min(x));
