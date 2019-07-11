function [ni,nimax] =directNeighbours(DT)

% Compute Voronoi diagram
[V.v,V.c] = voronoiDiagram(DT);

% Direct neighbors
nimax=0;
TR = DT.ConnectivityList;
ti = vertexAttachments(DT);
ni=cell(1,numel(DT.Points(:,1)));
for i=1:numel(DT.Points(:,1))
    temp=TR(ti{i},1:3);
    temp=reshape(temp,numel(temp),1);
    temp=unique(temp);
    temp(temp==i)=[];
    ni{i}=temp; % list of direct neighbors
    nimax=max(nimax,numel(temp)); % maximum number of direct neighbors
end