function [area,discharge]=drainageArea(nn,rec,rstack,nstack,surface)

global parSPM

% Mutiply area by precipitation rate
area=surface;
discharge=surface.*parSPM.P;

% % Compute Drainage Area 
% for ij = 1:nn
%     ijk = rstack(ij);
%     if rec(ijk)~=ijk
%         area(rec(ijk))      = area(ijk)      + area(rec(ijk));
%         discharge(rec(ijk)) = discharge(ijk) + discharge(rec(ijk));       
%     end
% end

% Compute Drainage Area 
% for ij = 1:nn
%     ijk = rstack(ij);
%     area(rec(ijk))      = area(ijk)      + area(rec(ijk));
%     discharge(rec(ijk)) = discharge(ijk) + discharge(rec(ijk));
% end

% Compute Drainage Area 
for k=1:numel(nstack)
    for ij=1:nstack{k}
        ijk = rstack{k}(ij);
        area(rec(ijk))      = area(ijk)      + area(rec(ijk));
        discharge(rec(ijk)) = discharge(ijk) + discharge(rec(ijk));
    end
end
