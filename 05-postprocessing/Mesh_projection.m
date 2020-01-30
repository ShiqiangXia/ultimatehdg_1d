function proj_num_sol = Mesh_projection(oldmesh,newmesh,num_sol,N_GQ,numerical_method_info)
% L2 projection from the old mesh to the new mesh 
% num_sol is the coefficients of qh and uh on oldmesh
% return proj_num_sol is the coefficients on newmesh
eof = 1e-13;
[~,old_N_ele] = size(num_sol);

if old_N_ele ~= oldmesh.N_elemets  
    error('ERROR: Data and the old mesh dont match!');  
end

new_N_ele = newmesh.N_elemets;

N_u = numerical_method_info.pk_u + 1;
N_q = numerical_method_info.pk_q + 1;
N_uhat = 2;
[r,w] = my_quadrature(N_GQ);
n = length(r);

old_hs = zeros(old_N_ele,1,numeric_t);
old_gq_pts_phy = zeros(n,old_N_ele,numeric_t);

proj_num_sol = zeros(N_u+N_q+N_uhat,new_N_ele,numeric_t);


%% step 1. compute GQ values on old mesh
    temp_q = my_vandermonde_q(r,N_q);
    temp_u = my_vandermonde_u(r,N_u);
    qh_old =temp_q* num_sol(1:N_q,:); % qh
    uh_old = temp_u * num_sol(N_q+1:N_q+N_u,:); % uh

%% step 2. compute all the GQ points on the phyical element
for ii = 1:old_N_ele
    nds = oldmesh.get_faces(ii);
    h = abs(nds(2)-nds(1));
    old_hs(ii) = h;
    mid = (nds(2)+nds(1))/numeric_t('2');
    old_gq_pts_phy(:,ii) = Ref_phy_map(r,h,mid);
       
end

%% step 3. figure out how old elements are contained in new elements

new_nodes = newmesh.all_nodes;

marker = (new_N_ele+1)* ones(old_N_ele,1,numeric_t);
old_nodes = oldmesh.all_nodes;
old_nodes = old_nodes(2:end);
for ii = 1:new_N_ele
    test_node = new_nodes(ii+1);
    idx = old_nodes<=test_node+eof;
    marker(idx) = marker(idx) -1;
end

%% step 4. For each new element, solve the projection
old_mesh_idx = 1:old_N_ele;

for ii = 1:new_N_ele
    n_nds = newmesh.get_faces(ii);
    n_halfh = (n_nds(2) - n_nds(1))/numeric_t('2');
    n_mid   = (n_nds(2)+n_nds(1))/numeric_t('2');
    idx = marker == ii;
    temp_old_idx= old_mesh_idx(idx);
    if length(temp_old_idx) == 1
        proj_num_sol(:,ii) = num_sol(:,temp_old_idx(1));
    else
        
        uh_old_pts = uh_old(:,idx);
        qh_old_pts = qh_old(:,idx);
        temp_old_h = old_hs(idx);
        temp_gq_old = old_gq_pts_phy(:,idx);
        temp_gq_old_ref = (temp_gq_old - n_mid)./n_halfh ;
    
        temp_A1 = volume_integral_u_u(N_u,N_GQ)*n_halfh;
        temp_A2 = volume_integral_q_q(N_q,N_GQ)*n_halfh;
        b1 = Subinterval_Integral(uh_old_pts,temp_gq_old_ref,temp_old_h,w,N_u,0);
        b2 = Subinterval_Integral(qh_old_pts,temp_gq_old_ref,temp_old_h,w,N_q,1);
    
        proj_num_sol(1:N_q,ii) = temp_A2\b2;
        proj_num_sol(N_q+1:N_q+N_u,ii) = temp_A1\b1;
    
    
    
    %% step 5 add the face values for new elements.
        proj_num_sol(end-1,ii) = num_sol(end-1,temp_old_idx(1));
        proj_num_sol(end,ii) = num_sol(end,temp_old_idx(end));
    end
    
end







end