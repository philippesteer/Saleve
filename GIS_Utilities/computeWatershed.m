function [watershed]=computeWatershed(nn,nstack,stack)

% Create watersheds
watershed=zeros(nn,1);
for k=1:numel(nstack)
    watershed(stack{k})=k;
end
