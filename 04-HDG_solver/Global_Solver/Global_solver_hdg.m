% Oliver Xia 01/01/2020
% Return uhat_vector : N_nodes x 1

function uhat_vector= Global_solver_hdg(M,N,taus,u0,u1)

% Assemble global matrix and solve the global problem
% The matrix is a tri-diagonal matrix, all the coefficents are determined
% by M,N
% Set notes for details

%  left end   |_____K_____|    right end
%  any left/right end point value = [weight1, weight2] * [u_hat_left, u_hat_right]


temp_diag = [numeric_t('1'); -(taus(1:end-1)+taus(2:end));numeric_t('1')];

ML = [squeeze(M(2,1,1:end-1));numeric_t('0')]; % Right end (2), weight of u_hat_left(1)
MR = [numeric_t('0');squeeze(M(1,2,2:end))];% Left end (1), weight of u_hat_right (2)

temp1 = squeeze(M(2,2,:)); % Right end (2), weight of u_hat_right (2)
temp2 = squeeze(M(1,1,:)); % Left end (1),weight of u_hat_left(1)
Mmid =[numeric_t('0'); temp1(1:end-1)+temp2(2:end);numeric_t('0')];

% Assemble Global matrix ----Three diagonal!!

% for each interior node
%--------------------------------------------------------------------------
%   ML+                 MR+,ML-                MR-
%   |__________K+_________|________K-__________|
% uhat_left            uhat_center         uhat_right
%                       eq here 
%--------------------------------------------------------------------------
% EQUATION:
%
%   MR+_left                                   *uhat_left 
% + (MR+_right + ML-_left - tau_left-tau_right)*uhat_center
% + (ML-_right)                                *uhat_right
% =                                            N+_right+N-_left

A_global = numeric_t(diag(temp_diag))+numeric_t(diag(Mmid)) +numeric_t(diag(ML,-1))+numeric_t(diag(MR,1)) ;

b_global = [u0, -(N(2,1:end-1)+N(1,2:end)),u1]';

A_global = numeric_t( sparse(A_global));

uhat_vector = A_global\b_global;

end