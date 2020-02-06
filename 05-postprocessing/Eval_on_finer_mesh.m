function lift_pts = Eval_on_finer_mesh(oldmesh,newmesh,mesh_relation,old_pts,GQ_points,new_gq_pts_phy,numerical_method_info)
% compute more quadrature point values on new mesh

N_u = numerical_method_info.pk_u + 1;
N_q = numerical_method_info.pk_q + 1;
N_uhat = 2;

N_u_star = 2*N_u;
N_q_star = 2*N_q;

n = length(GQ_points);



new_N_ele = newmesh.N_elemets;
old_N_ele = oldmesh.N_elemets;

lift_pts  = zeros(n+n+N_uhat,new_N_ele,numeric_t);


temp_q_mtrix = my_vandermonde_q(GQ_points,N_q_star);
V_q = temp_q_mtrix' * temp_q_mtrix; %A'A
temp_u_mtrix = my_vandermonde_u(GQ_points,N_u_star);
V_u = temp_u_mtrix' * temp_u_mtrix;


new_mesh_idx = 1:new_N_ele;

for ii = 1:old_N_ele
    idx = mesh_relation == ii;
    temp_new_idx= new_mesh_idx(idx);
    N_sub_ele = length(temp_new_idx) ;
    
    if N_sub_ele == 1
        
        lift_pts(:,temp_new_idx(1)) = old_pts(:,ii);
        
    else
        o_nds = oldmesh.get_faces(ii);
        o_halfh = (o_nds(2) - o_nds(1))/numeric_t('2');
        o_mid   = (o_nds(2)+o_nds(1))/numeric_t('2');
        %%% solve least square:Ax-b
        %%% same as A'Ax=A'b
        old_q_coeff = V_q\(temp_q_mtrix'* old_pts(1:n,ii));
        old_u_coeff = V_u\( temp_u_mtrix' * old_pts(n+1:2*n,ii));
        temp_gq_new = new_gq_pts_phy(:,idx);
        temp_gq_new_ref = (temp_gq_new - o_mid)./o_halfh ;
        
        for jj = 1:N_sub_ele
            temp_ptmtrix_q = my_vandermonde_q(temp_gq_new_ref(1:n,jj),N_q_star);
            temp_ptmtrix_u = my_vandermonde_u(temp_gq_new_ref(:,jj),N_u_star);
            lift_pts(1:n,temp_new_idx(jj)) = temp_ptmtrix_q*old_q_coeff;
            lift_pts(n+1:end,temp_new_idx(jj)) = temp_ptmtrix_u*old_u_coeff;
            
        end
        
        
        
    end
    
    
    
end





end