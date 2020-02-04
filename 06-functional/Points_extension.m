function [sol_1_ex,sol_2_ex] = Points_extension(hs,N_u,N_q,GQ_pts,sol_1,sol_2)

% the stucture of sol
% ( qh ; uh; uh_hat ) only GQ points for the first two
% the structure of the extension
% (qh ; uh; grad_uh; uh_hat) GQ+end points for the first three
[~,N_ele] = size(sol_1);

N_uhat = 2;
nn = length(GQ_pts);
n_pt = nn+2;

extension_points = [GQ_pts;numeric_t('-1');numeric_t('1')];

temp_q_mtrix = my_vandermonde_q(GQ_pts,N_q);
extend_q_mtrix = my_vandermonde_q(extension_points,N_q);
V_q = temp_q_mtrix' * temp_q_mtrix; %A'A
temp_u_mtrix = my_vandermonde_u(GQ_pts,N_u);
extend_u_mtrix = my_vandermonde_u(extension_points,N_u);
V_u = temp_u_mtrix' * temp_u_mtrix;

extend_gradu_matrix = my_gradvandermonde_u(extension_points,N_u);

sol_1_ex = zeros(n_pt*3+N_uhat,N_ele,numeric_t);
sol_2_ex = zeros(n_pt*3+N_uhat,N_ele,numeric_t);

sol_1_ex(1:n_pt,:) =extend_q_mtrix * ( V_q\(temp_q_mtrix'*sol_1(1:nn,:)) );
temp1  = ( V_u\(temp_u_mtrix'*sol_1(nn+1:2*nn,:)));
sol_1_ex(n_pt+1:2*n_pt,:) =extend_u_mtrix * temp1;
sol_1_ex(2*n_pt+1:3*n_pt,:) =(numeric_t('2')./hs)'.* ( extend_gradu_matrix * (temp1));
sol_1_ex(3*n_pt+1:end,:) = sol_1(2*nn+1:end,:);

sol_2_ex(1:n_pt,:) = extend_q_mtrix * (V_q\(temp_q_mtrix'*sol_2(1:nn,:)));
temp2 = V_u\(temp_u_mtrix'*sol_2(nn+1:2*nn,:));
sol_2_ex(n_pt+1:2*n_pt,:) = extend_u_mtrix *( temp2);
sol_2_ex(2*n_pt+1:3*n_pt,:) =(numeric_t('2')./hs)'.* ( extend_gradu_matrix * ( temp2));
sol_2_ex(3*n_pt+1:end,:) = sol_2(2*nn+1:end,:);



end