function F=face_integral_u(N,ref_x)
% evalue all u basis at ref_x
% return column N * 1

F = my_vandermonde_u(ref_x,N)';

end