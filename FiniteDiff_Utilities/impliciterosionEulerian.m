function [z,e,c]=impliciterosionEulerian(x,y,z,discharge,stack,nstack,rec)

global parSPM


zsave=z;c=zeros(size(z));
% Compute migration rate
for k=1:numel(nstack)
    if nstack{k}>1  
        c(stack{k}(1))=NaN;
        for i=2:nstack{k} 
            % Skip the first node of a stack that should always be a
            % self-receiver (and therefore no erosion) - this prevents from
            % having a if condition inside the node loop
            s=stack{k}(i);
            r=rec(s);
            dl=sqrt((x(s)-x(r)).^2+(y(s)-y(r)).^2);
            c(s)=parSPM.K(s).*discharge(s).^parSPM.m.*parSPM.dt./dl;
            z(s)=( z(s) + c(s).*z(rec(s)) )./(1+c(s));
        end
    end
end
e=z-zsave;