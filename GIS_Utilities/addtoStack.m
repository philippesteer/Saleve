function [stack,nstack]=addtoStack(ij,ndon,donor,stack,nstack)
% This is the core of the fastscape algorithm. This recursive function add
% to the stack the donors of an outlet, and then the donors of theses
% donors and etc until a entire catchment is added to the stack

nstack=nstack+1; % Number of nodes in this stack
stack(nstack)=ij; % Stack nodes

if ndon(ij)~=0 % If at least one donor exist
    for kk=1:ndon(ij) % then find them and add them to the stack
        [stack,nstack]=addtoStack(donor(ij,kk),ndon,donor,stack,nstack);
    end
end
