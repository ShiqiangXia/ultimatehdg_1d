function Plot_comp4(hs,gq_pts_phy,exact_func,num_sol1_gq_pts,num_sol2_gq_pts,w,hs3,gq_pts_phy3,num_sol3_gq_pts)
% compare two numerical solution on the same mesh

[n_pts,N_ele] = size(gq_pts_phy);
nn = n_pts - 2; 

% difference at GQ points
gp_pts_global  = reshape( gq_pts_phy(1:end-2,:),[nn*N_ele,1]);

[n_pts3,N_ele3] = size(gq_pts_phy3);
nn3 = n_pts3 - 2; 
gp_pts_global3  = reshape( gq_pts_phy3(1:end-2,:),[nn3*N_ele3,1]);


% element by element difference at GQ points

% Solution on uniform mesh
diff_q_mtrix1 = exact_func(gq_pts_phy(1:end-2,:),1) - num_sol1_gq_pts(1:nn,:);
diff_u_mtrix1 = exact_func(gq_pts_phy(1:end-2,:),0) - num_sol1_gq_pts(nn+1:2*nn,:);

% Non-uniform solution projected to uniform mesh
diff_q_mtrix2 = exact_func(gq_pts_phy(1:end-2,:),1) - num_sol2_gq_pts(1:nn,:);
diff_u_mtrix2 = exact_func(gq_pts_phy(1:end-2,:),0) - num_sol2_gq_pts(nn+1:2*nn,:);

% Non-uniform solution
diff_q_mtrix3 = exact_func(gq_pts_phy3(1:end-2,:),1) - num_sol3_gq_pts(1:nn3,:);
diff_u_mtrix3 = exact_func(gq_pts_phy3(1:end-2,:),0) - num_sol3_gq_pts(nn3+1:2*nn3,:);

% L^2 error in each element
error_list_q1 = sqrt((w' * (diff_q_mtrix1.^2))'.* (hs./numeric_t('2')));
error_list_u1 = sqrt((w' * (diff_u_mtrix1.^2))'.* (hs./numeric_t('2')));

error_list_q2 = sqrt((w' * (diff_q_mtrix2.^2))'.* (hs./numeric_t('2')));
error_list_u2 = sqrt((w' * (diff_u_mtrix2.^2))'.* (hs./numeric_t('2')));

error_list_q3 = sqrt((w' * (diff_q_mtrix3.^2))'.* (hs3./numeric_t('2')));
error_list_u3 = sqrt((w' * (diff_u_mtrix3.^2))'.* (hs3./numeric_t('2')));

% plot

diff_u_global1 = reshape(diff_u_mtrix1,[nn*N_ele,1]);
diff_q_global1 = reshape(diff_q_mtrix1,[nn*N_ele,1]);
diff_q_global2 = reshape(diff_q_mtrix2,[nn*N_ele,1]);
diff_u_global2 = reshape(diff_u_mtrix2,[nn*N_ele,1]);

diff_q_global3 = reshape(diff_q_mtrix3,[nn3*N_ele3,1]);
diff_u_global3 = reshape(diff_u_mtrix3,[nn3*N_ele3,1]);

close all

%%%% lable of legend is NON-RELATED to the variable name, just the order

figure
plot(gp_pts_global,diff_u_global1,'*-');
hold on
plot(gp_pts_global3,diff_u_global3,'x-');
hold on
plot(gp_pts_global,diff_u_global2,'o-');
legend('Uniform: u-u_h1','Non-uni: u-uh_2','Non-uni+L^2Proj: u-u_h3')
title(['HDG: Error plot at GQ points with N = ',num2str(N_ele)])
hold off

figure
plot(gp_pts_global,diff_q_global1,'*-'); 
hold on
plot(gp_pts_global3,diff_q_global3,'x-');
hold on
plot(gp_pts_global,diff_q_global2,'o-');
legend('Uniform: q-q_h1','Non-uni: q-q_h2','Non-uni+L^2Proj: q-q_h3')
title(['HDG: Error plot at GQ points with N = ',num2str(N_ele)])
hold off

figure
plot(1:N_ele,error_list_u1,'*--');
hold on
plot(1:N_ele3,error_list_u3,'x--');
hold on
plot(1:N_ele,error_list_u2,'o-');
legend('Uniform: ||u-u_h1||','Non-uni: ||u-u_h2||','Non-uni+L^2Proj: ||u-u_h3||')
title(['HDG: Error plot in each element with N = ',num2str(N_ele)])
hold off

figure
plot(1:N_ele,error_list_q1,'*--');
hold on
plot(1:N_ele3,error_list_q3,'*--');
hold on
plot(1:N_ele,error_list_q2,'o-');
legend('Uniform: ||q-q_h1||','Non-uni: ||q-q _h2||','Non-uni+L^2Proj: ||q-q _h3||')
title(['HDG: Error plot in each element with N = ',num2str(N_ele)])
hold off

    



end