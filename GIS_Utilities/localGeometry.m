function [surface,sides,V,ni,nimax,iproblem] =localGeometry(nn,DT,meanarea)

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

% Local area of each node
% Simple version that has issue with some border nodes that display
% unrealsitic large (and even infinite) areas as the voronoi diagram is
% unbounded. The solution chosen here is to detect nodes with infinite
% areas (on the convex hull) or with very large areas (near the convex
% hull) and to prescribe an average area for these nodes.
surface=zeros(nn,1);
for i = 1 : size(V.c ,1)
    ind = V.c{i}';
    surface(i) = polyarea( V.v(ind,1) , V.v(ind,2) );
end
iproblem=isnan(surface)==1 | surface>meanarea.*10;
surface(iproblem)=meanarea;

% Sort vertex of vornoi diagram and direct neighbors in trigonometric order
% and compute the length of voronoi sides
x=DT.Points(:,1);y=DT.Points(:,2);
sides=cell(1,numel(DT.Points(:,1)));
% % Commented because not used in this version
% for i=1:numel(x)
%     % Order direct neighbors in trigonometric order
%     [theta,~] = cart2pol(x(ni{i})-x(i),y(ni{i})-y(i));theta=theta+pi;
%     [~,ind] = sort(theta,'ascend');    ni{i}=ni{i}(ind);
%     % Order sides of the Vornoi diagram in trigonometric order
%     [theta,~] = cart2pol(V.v(V.c{i},1)-x(i),V.v(V.c{i},2)-y(i));theta=theta+pi;
%     [~,ind] = sort(theta,'ascend');    V.c{i}=V.c{i}(ind);
%     % Compute side length
%     l1=[1:numel(V.c{i})];l2=[2:numel(V.c{i}) 1];
%     sides{i}=sqrt(  ( V.v(V.c{i}(l2),1)-V.v(V.c{i}(l1),1) ).^2 + ( V.v(V.c{i}(l2),2)-V.v(V.c{i}(l1),2) ).^2  );
%     sides{i}(isinf(sides{i})) = 0;
%     sides{i}(sides{i}>meanarea./(2.*pi).*10 ) = meanarea./(2.*pi);
% end


