function cheap_scatter2d(x,y,siz,h,cmap,hmin,hmax)

% Born values
h(h<hmin)=hmin;
h(h>hmax)=hmax;

% Define the bin
cdivs=size(cmap,1);
[~, edges] = hist(h,cdivs-1);
edges = [-Inf edges Inf]; % to include all points
[~, bink] = histc(h,edges);

% Compute and plot values 
hold on;
for i=1:cdivs
    idx = bink==i;
    plot(x(idx),y(idx),'.','MarkerSize',siz,'Color',cmap(i,:));
end
