function uhat_vector= Global_solver_hdg(M,N,taus,u0,u1)

[~,N_ele] = size(M);

temp_diag = [numeric_t('1'), -(taus(1:end-1)+taus(2:end)),numeric_t('1')];

ML = [reshape(M(2,1,:),N_ele,1),numeric_t('0')];
MR = [numeric_t('0'),reshape(M(1,2,:),N_ele,1)];

temp1 = reshape(M(2,2,:),N_ele,1);
temp2 = reshape(M(1,1,:),N_ele,1);
Mmid =[numeric_t('0'), temp1(1:end-1)+temp2(2:end),numeric_t('0')];

NN = reshape(N(1,:),N_ele,1);

% Assemble Global matrix ----Three diagonal!!

A_global = numeric_t(diag(temp_diag))+numeric_t(diag(Mmid)) +numeric_t(diag(ML,-1))+numeric_t(diag(MR,1)) ;
b_global = [u0, -NN(1:end-1)-NN(2:end),u1];

A_global = numeric_t( sparse(A_global));

uhat_vector = A_global\b_global;

end