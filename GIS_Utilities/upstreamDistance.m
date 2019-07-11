function [updist,uptime]=upstreamDistance(nn,x,y,discharge,donor,nstack,stack)
% Compute upstream distance to outlets

global parSPM

updist=zeros(nn,1);uptime=zeros(nn,1);
for k=1:numel(nstack)
    for ij=1:nstack{k}
        ijk = stack{k}(ij);
        d=donor(ijk,:);d(d==0)=[];
        length=sqrt((x(ijk)-x(d)).^2+(y(ijk)-y(d)).^2);
        %dtime=length./(parSPM.K(ijk).*discharge(ijk).^parSPM.m);
        dtime=length./(parSPM.K(d).*discharge(d).^parSPM.m);      
        updist(d)=updist(ijk)+length;
        uptime(d)=uptime(ijk)+dtime;
    end
end
% 
% updist=zeros(nn,1);uptime=zeros(nn,1);
% for k=1:numel(nstack)
%     for ij=1:nstack{k}
%         ijk = stack{k}(ij);
%         d=donor(ijk,:);d(d==0)=[];
%         length=sqrt((x(ijk)-x(d)).^2+(y(ijk)-y(d)).^2);
%         if discharge(ijk)>parSPM.Qc
%             dtime=length./(parSPM.K.*discharge(ijk).^parSPM.m);
%         else
%             dtime=length./parSPM.Kh;
%         end
%         updist(d)=updist(ijk)+length;
%         uptime(d)=uptime(ijk)+dtime;
%     end
% end

