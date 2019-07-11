function [areal,V]=localArea(nn,DT,xlimit,ylimit,meanarea)

% Simple version that has issue with some border nodes that display
% unrealsitic large (and even infinite) areas as the voronoi diagram is
% unbounded
% The solution chosen here is to detect nodes with infinite areas (on the convex
% hull) or with very large areas (near the convex hull) and to prescribe an
% average area for theses nodes.
% 

% Local area of each node
areal=zeros(nn,1);
[V.v,V.c] = voronoiDiagram(DT);
for i = 1 : size(V.c ,1)
    ind = V.c{i}';
    areal(i) = polyarea( V.v(ind,1) , V.v(ind,2) );
end
areal(isnan(areal)==1 | areal>meanarea.*10)=meanarea;

% % Version that bound problematic vornoi polygon to the model limit
% % Not perfect however
% % Local area of each node
% areal=zeros(nn,1);
% [v,c] = voronoiDiagram(DT);
% for i = 1 : size(c ,1)
%     ind = c{i}';
%     areal(i) = polyarea( v(ind,1) , v(ind,2) );
% end
% % Detect problematic area
% isingular=find(isnan(areal)==1 | areal>median(areal,'omitnan')+21*std(areal,'omitnan'));
% pboundary=polyshape([xlimit(1) xlimit(2) xlimit(2) xlimit(1) ],[ylimit(1) ylimit(1) ylimit(2) ylimit(2)]);
% for i = 1 : numel(isingular)
%     %isingular(i)
%     ind = c{isingular(i)}';
%     xv=v(ind,1); yv=v(ind,2);
%     % Remove infinite values
%     if isinf(xv(1))==1
%         xv(1)=[];yv(1)=[];
%     end
%     % If less than 3 vertex add one (the node itself)
%     if numel(xv)<3
%         xv(end+1)=DT.Points(isingular(i),1);yv(end+1)=DT.Points(isingular(i),2);
%     end
%     % Generate voronoi polygon
%     pvoronoi = polyshape(xv,yv);
%     % Keep only the part of the polygon that is inside the model boundaries
%     polyout = intersect(pvoronoi,pboundary);
%     % Compute area
%     areal(isingular(i)) = polyarea( polyout.Vertices(:,1) , polyout.Vertices(:,2) );
% end
% areal(isnan(areal))=median(areal,'omitnan');


