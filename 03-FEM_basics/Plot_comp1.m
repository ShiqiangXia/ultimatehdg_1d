function Plot_comp1(hs,gq_pts_phy,exact_func,num_sol_gq_pts,w)

[n_pts,N_ele] = size(gq_pts_phy);
nn = n_pts - 2; 
%{
N_ele = my_mesh.N_elemets();
nn = length(r);

gq_pts_ref = zeros(nn+2,N_ele,numeric_t);

hs = zeros(N_ele,1,numeric_t);

r1 = [r;numeric_t('-1');numeric_t('1')];



%% Compute Gauss Quadrature points at physical elements
for ii = 1:N_ele
    nds = my_mesh.get_faces(ii);
    h = abs(nds(2)-nds(1));
    hs(ii) = h;
    mid = (nds(2)+nds(1))/numeric_t('2');
    gq_pts_ref(:,ii) = Ref_phy_map(r1,h,mid);
end
%}
% difference at GQ points
gp_pts_global  = reshape( gq_pts_phy(1:end-2,:),[nn*N_ele,1]);
exact_q_global = reshape( exact_func(gq_pts_phy(1:end-2,:),1),[nn*N_ele,1]);
exact_u_global = reshape( exact_func(gq_pts_phy(1:end-2,:),0),[nn*N_ele,1]);

qh_global      = reshape( num_sol_gq_pts(1:nn,:),[nn*N_ele,1]);
uh_global      = reshape(num_sol_gq_pts(nn+1:2*nn,:),[nn*N_ele,1]);

diff_q_mtrix = exact_func(gq_pts_phy(1:end-2,:),1) - num_sol_gq_pts(1:nn,:);
diff_u_mtrix = exact_func(gq_pts_phy(1:end-2,:),0) - num_sol_gq_pts(nn+1:2*nn,:);

% L^2 error in each element
error_list_q = sqrt((w' * (diff_q_mtrix.^2))'.* (hs./numeric_t('2')));
error_list_u = sqrt((w' * (diff_u_mtrix.^2))'.* (hs./numeric_t('2')));

% plot


diff_q_global = exact_q_global - qh_global;
diff_u_global = exact_u_global - uh_global;

%gp_pts_global = gq_pts_ref(1:end-2,:);
%{
figure
plot(gp_pts_global,exact_u_global);
hold on
plot(gp_pts_global,uh_global);
legend('exact u', 'u_h')
title(['HDG: comp u_h with exact sol with N = ',num2str(N_ele)])
hold off

figure
plot(gp_pts_global,exact_q_global);
hold on
plot(gp_pts_global,qh_global);
legend('exact q', 'q_h')
title(['HDG: comp q_h with exact sol with N = ',num2str(N_ele)])
hold off
%}

figure
plot(gp_pts_global,diff_u_global,'--');
hold on
plot(gp_pts_global,diff_q_global);
legend('u-u_h','q-q_h')
title(['HDG: Error plot at GQ points with N = ',num2str(N_ele)])
hold off

figure
plot(1:N_ele,error_list_u);
hold on
plot(1:N_ele,error_list_q);
legend('||u-u_h||','||q-q_h||')
title(['HDG: Error plot in each element with N = ',num2str(N_ele)])
hold off

    



end