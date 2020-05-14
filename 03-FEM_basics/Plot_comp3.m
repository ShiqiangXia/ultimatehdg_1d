function Plot_comp3(hs,gq_pts_phy,exact_func,num_sol1_gq_pts,num_sol2_gq_pts,w)
% compare two numerical solution on the same mesh

[n_pts,N_ele] = size(gq_pts_phy);
nn = n_pts - 2; 

% difference at GQ points
gp_pts_global  = reshape( gq_pts_phy(1:end-2,:),[nn*N_ele,1]);

%{
exact_q_global = reshape( exact_func(gq_pts_phy(1:end-2,:),1),[nn*N_ele,1]);
exact_u_global = reshape( exact_func(gq_pts_phy(1:end-2,:),0),[nn*N_ele,1]);

qh_global1      = reshape( num_sol1_gq_pts(1:nn,:),[nn*N_ele,1]);
uh_global1      = reshape(num_sol1_gq_pts(nn+1:2*nn,:),[nn*N_ele,1]);

qh_global2      = reshape( num_sol2_gq_pts(1:nn,:),[nn*N_ele,1]);
uh_global2      = reshape(num_sol2_gq_pts(nn+1:2*nn,:),[nn*N_ele,1]);
%}

% element by element difference at GQ points
diff_q_mtrix1 = exact_func(gq_pts_phy(1:end-2,:),1) - num_sol1_gq_pts(1:nn,:);
diff_u_mtrix1 = exact_func(gq_pts_phy(1:end-2,:),0) - num_sol1_gq_pts(nn+1:2*nn,:);

diff_q_mtrix2 = exact_func(gq_pts_phy(1:end-2,:),1) - num_sol2_gq_pts(1:nn,:);
diff_u_mtrix2 = exact_func(gq_pts_phy(1:end-2,:),0) - num_sol2_gq_pts(nn+1:2*nn,:);

% L^2 error in each element
error_list_q1 = sqrt((w' * (diff_q_mtrix1.^2))'.* (hs./numeric_t('2')));
error_list_u1 = sqrt((w' * (diff_u_mtrix1.^2))'.* (hs./numeric_t('2')));

error_list_q2 = sqrt((w' * (diff_q_mtrix2.^2))'.* (hs./numeric_t('2')));
error_list_u2 = sqrt((w' * (diff_u_mtrix2.^2))'.* (hs./numeric_t('2')));

% plot
%{
%diff_q_global1 = exact_q_global - qh_global1;

%diff_u_global1 = exact_u_global - uh_global1;

%diff_q_global2 = exact_q_global - qh_global2;
%diff_u_global2 = exact_u_global - uh_global2;
%}

diff_u_global1 = reshape(diff_u_mtrix1,[nn*N_ele,1]);
diff_q_global1 = reshape(diff_q_mtrix1,[nn*N_ele,1]);
diff_q_global2 = reshape(diff_q_mtrix2,[nn*N_ele,1]);
diff_u_global2 = reshape(diff_u_mtrix2,[nn*N_ele,1]);

figure
plot(gp_pts_global,diff_u_global1,'*-');
hold on
plot(gp_pts_global,diff_u_global2,'x-');
legend('u-u_h1','u-u_h2')
title(['HDG: Error plot at GQ points with N = ',num2str(N_ele)])
hold off

figure
plot(gp_pts_global,diff_q_global1,'*-');
hold on
plot(gp_pts_global,diff_q_global2,'x-');
legend('q-q_h1','q-q_h2')
title(['HDG: Error plot at GQ points with N = ',num2str(N_ele)])
hold off

figure
plot(1:N_ele,error_list_u1,'*--');
hold on
plot(1:N_ele,error_list_u2,'x--');
legend('||u-u_h1||','||u-u_h2||')
title(['HDG: Error plot in each element with N = ',num2str(N_ele)])
hold off

figure
plot(1:N_ele,error_list_q1,'*--');
hold on
plot(1:N_ele,error_list_q2,'*--');
legend('||q-q_h1||','||q-q _h2||')
title(['HDG: Error plot in each element with N = ',num2str(N_ele)])
hold off

    



end