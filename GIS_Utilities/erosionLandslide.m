function [z,landslide]=erosionLandslide(nn,x,y,z,ni,surface,mask)

global parSPM

% Compute the Culmann height for each node
for i=1:nn
    nd=ni{i};
    H=z(nd)-z(i);
    Sd=atand((z(nd)-z(i))./sqrt((x(nd)-x(i)).^2+(y(nd)-y(i)).^2));
    Hc=4.*parSPM.c./(parSPM.rho.*parSPM.g).*(sind(Sd).*cosd(parSPM.phi))./(1-cosd(Sd-parSPM.phi));
    % Keep only the unstable points 1) with positive height 2) with slope above phi and 3) inside the mask
    Hr=H./Hc;Hr(H<=0 | Sd<parSPM.phi | mask(i)==0)=0;
    [Hratio(i),j]=max(Hr);
    Sdmax(i)=Sd(j);
end

% Find unstable points
i_unstable=find(Hratio>1);Hratio_unstable=Hratio(i_unstable);

% Sample only the seeked number of unstable points
n_tosample=min(numel(i_unstable),parSPM.nl);
%i_unstable=datasample(i_unstable,n_tosample,'Replace',false,'Weights',Hratio_unstable);
i_unstable=datasample(i_unstable,n_tosample,'Replace',false);

i=1;k=0;landslide=[];
while isempty(i_unstable)==0
    k=k+1;
    zold=z;
    % Determine the rupture initiation
    i_ini=i_unstable(i);
    x_ini=x(i_ini);
    y_ini=y(i_ini);
    z_ini=z(i_ini);
    s_ini=Sdmax(i_ini);
    % Determine the rupture angle
    bisangle=(s_ini+parSPM.phi)./2;
    % List of nodes belonging to this landslide
    i_list=i_ini;
    % List of nodes on the landslide front (that is reccursively updated)
    i_last=i_ini;
    % While the landslide front has some new nodes
    while isempty(i_last)==0
        i_lastnew=[];    
        % Loop on the nodes of the landslide front
        for j=1:numel(i_last)
            % Determine direct neighbours of the nodes belonging to the
            % front
            i_nn=ni{i_last(j)};
            x_nn=x(i_nn);
            y_nn=y(i_nn);
            z_nn=z(i_nn);
            d_nn=sqrt((x_nn-x_ini).^2+(y_nn-y_ini).^2);
            Hc_nn=d_nn.*tand(bisangle);
            H_nn=z_nn-z_ini;
            % Determine unstable points among the direct neighbours
            i_new=i_nn(H_nn>Hc_nn);
            [i_new,~]=setdiff(i_new,i_list);
            % Add these unstable points to the landslide list          
            i_list=[i_list i_new'];
            % The landsldie front is updated
            if isempty(i_lastnew) && size(i_lastnew,2)>1; i_lastnew=[];end           
            i_lastnew=[i_lastnew i_new'];
        end  
        i_last=i_lastnew;
    end
    % Erode the nodes of the landslide list
    d_list=sqrt((x(i_list)-x_ini).^2+(y(i_list)-y_ini).^2);
    Hc_list=d_list.*tand(bisangle);
    z(i_list)=Hc_list+z_ini;
    landslide.A(k)=sum(surface(i_list));
    landslide.V(k)=sum((zold(i_list)-z(i_list)).*surface(i_list));
    landslide.n{k}=i_list;
    landslide.h{k}=zold(i_list)-z(i_list);
    % Remove from the unstable point list the already failed points
    i_unstable=setdiff(i_unstable,i_list);
end