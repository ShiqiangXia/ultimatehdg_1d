function F= face_integral_q(N_q,ref_x)
% evalue all q basis at ref_x
% return column N * 1

F = my_vandermonde_q(ref_x,N_q)';
end