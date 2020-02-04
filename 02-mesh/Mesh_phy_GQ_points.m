function [hs,gq_pts_phy]=Mesh_phy_GQ_points(my_mesh,GQ_points)

N_ele = my_mesh.N_elemets();
nn = length(GQ_points);

gq_pts_phy = zeros(nn+2,N_ele,numeric_t);
hs = zeros(N_ele,1,numeric_t);

r1 = [GQ_points;numeric_t('-1');numeric_t('1')];

%% Compute Gauss Quadrature points at physical elements
for ii = 1:N_ele
    nds = my_mesh.get_faces(ii);
    h = abs(nds(2)-nds(1));
    hs(ii) = h;
    mid = (nds(2)+nds(1))/numeric_t('2');
    gq_pts_phy(:,ii) = Ref_phy_map(r1,h,mid);
       
end

end