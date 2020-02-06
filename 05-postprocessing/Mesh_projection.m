function [proj_num_sol,marker] = Mesh_projection(oldmesh,newmesh,old_num_sol,old_num_sol_0,old_hs,old_gq_pts_phy,GQ_weights,numerical_method_info)
% L2 projection from the old mesh to the new mesh 
%
% Solve 
% (u_new, basis) = sum_{sub interval}:(u_old, basis)
%
% old_num_sol is the coefficients of qh and uh on oldmesh
% old_num_sol_0 is the GQ points values of qh and uh in each element on oldmesh
% old_hs: h of each element in oldmesh
% old_gq_pts_phy: physical GQ points in each element on oldmesh
% return proj_num_sol is the coefficients on newmesh

%% step 0: set up 

[Num_GQ,old_N_ele] = size(old_gq_pts_phy);
N_GQ = Num_GQ-1;

if old_N_ele ~= oldmesh.N_elemets  
    error('ERROR: Data and the old mesh dont match!');  
end

new_N_ele = newmesh.N_elemets;

N_u = numerical_method_info.pk_u + 1;
N_q = numerical_method_info.pk_q + 1;
N_uhat = 2;

proj_num_sol = zeros(N_u+N_q+N_uhat,new_N_ele,numeric_t);


%% step 1. GQ values on old mesh
    
    qh_old = old_num_sol_0(1:Num_GQ,:); % qh
    uh_old = old_num_sol_0(Num_GQ+1:2*Num_GQ,:); % uh

%% step 2. compute all the GQ points on the phyical element

% already here old_gq_pts_phy

%% step 3. figure out how old elements are contained in new elements

marker = Mesh_relation(oldmesh,newmesh);



%% step 4. For each new element, solve the projection

old_mesh_idx = 1:old_N_ele;

for ii = 1:new_N_ele
    n_nds = newmesh.get_faces(ii);
    n_halfh = (n_nds(2) - n_nds(1))/numeric_t('2');
    n_mid   = (n_nds(2)+n_nds(1))/numeric_t('2');
    idx = marker == ii;
    temp_old_idx= old_mesh_idx(idx);
    if length(temp_old_idx) == 1
        proj_num_sol(:,ii) = old_num_sol(:,temp_old_idx(1));
    else
        
        uh_old_pts = uh_old(:,idx);
        qh_old_pts = qh_old(:,idx);
        temp_old_h = old_hs(idx);
        temp_gq_old = old_gq_pts_phy(:,idx);
        temp_gq_old_ref = (temp_gq_old - n_mid)./n_halfh ;
    
        temp_A1 = volume_integral_u_u(N_u,N_GQ)*n_halfh;
        temp_A2 = volume_integral_q_q(N_q,N_GQ)*n_halfh;
        b1 = Subinterval_Integral(uh_old_pts,temp_gq_old_ref,temp_old_h,GQ_weights,N_u,0);
        b2 = Subinterval_Integral(qh_old_pts,temp_gq_old_ref,temp_old_h,GQ_weights,N_q,1);
    
        proj_num_sol(1:N_q,ii) = temp_A2\b2;
        proj_num_sol(N_q+1:N_q+N_u,ii) = temp_A1\b1;
    
    
    
    %% step 5 add the face values for new elements.
        proj_num_sol(end-1,ii) = old_num_sol(end-1,temp_old_idx(1));
        proj_num_sol(end,ii) = old_num_sol(end,temp_old_idx(end));
    end
    
end







end