function [error_q,error_u,error_uhat]=Error_cal(my_mesh,exact_func,num_sol_gq_pts,N_GQ,numerical_method_info)
% num_sol_gq_pts is a matrix, each column is the GQ quadrature point values
% of q_h, u_h and end point values of u_hat;

[r,w] = my_quadrature(N_GQ);
N_ele = my_mesh.N_elemets();
N_u = numerical_method_info.pk_u + 1;
N_q = numerical_method_info.pk_q + 1;
N_uhat = 2;
nn = length(r);

gq_pts_ref = zeros(nn+2,N_ele,numeric_t);

hs = zeros(N_ele,1,numeric_t);

r1 = [r;numeric_t('-1');numeric_t('1')];


error_list_u = zeros(N_ele,1,numeric_t);
error_list_q = zeros(N_ele,1,numeric_t);
error_list_uhat = zeros(N_ele+1,1,numeric_t);

for ii = 1:N_ele
    nds = my_mesh.get_faces(ii);
    h = abs(nds(2)-nds(1));
    hs(ii) = h;
    mid = (nds(2)+nds(1))/numeric_t('2');
    gq_pts_ref(:,ii) = Ref_phy_map(r1,h,mid);
       
end

diff_q_mtrix = exact_func(gq_pts_ref(1:end-2,:),1) - num_sol_gq_pts(1:nn,:);
diff_u_mtrix = exact_func(gq_pts_ref(1:end-2,:),0) - num_sol_gq_pts(nn+1:2*nn,:);

error_list_q = (w' * (diff_q_mtrix.^2))'.* (hs./numeric_t('2'));
error_list_u = (w' * (diff_u_mtrix.^2))'.* (hs./numeric_t('2'));

error_list_uhat =( exact_func(my_mesh.all_nodes(),0) - [num_sol_gq_pts(end-1,:),num_sol_gq_pts(end,end)] )';


error_q = sum(error_list_q);
error_u = sum(error_list_u);
error_uhat =sum(error_list_uhat);


end