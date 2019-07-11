function [x,y,z]=moveNodes(nn,x,y,z,iborder)

global parSPM

% Generate logical array of border nodes
iborder_logical=zeros(nn,1);iborder_logical(iborder)=1;

% Uplift nodes outside the border
z(~iborder_logical)=z(~iborder_logical)+parSPM.U.*parSPM.dt; 



% 
% 
% xc=parSPM.L/2;yc=parSPM.L/2;
% dist=sqrt((x-xc).^2+(y-yc).^2);
% ind=find(dist<parSPM.L./2.1);
% % Vertical uplift
% z=z+parSPM.U./2.*parSPM.dt;
% z(ind)=z(ind)+parSPM.U./2.*parSPM.dt;
% % Radial rotation
% Vr=parSPM.U.*2.*parSPM.dt;
% [theta,rho1] = cart2pol(x-xc,y-yc);
% Vx=sin(theta).*Vr;
% Vy=-cos(theta).*Vr;
% x(ind)=x(ind)+Vx(ind);
% y(ind)=y(ind)+Vy(ind);
% [theta,rho2] = cart2pol(x-xc,y-yc);
% 
% % rho2 should be equal to rho 1
% ind=find(rho2~=rho1);
% d=(rho2(ind)-rho1(ind));
% x(ind)=x(ind)-d.*cos(theta(ind));
% y(ind)=y(ind)-d.*sin(theta(ind));






