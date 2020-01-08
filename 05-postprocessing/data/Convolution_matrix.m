function AA = Convolution_matrix(k,Nu,pts,N_GQ)

% use Bspine of order k+1;
% Polynomial degree is Np-1;
% pts are the points of interest;
% pts need to be a column vector

deg_bspine = k+1;
[r,w] = my_quadrature(N_GQ);

n = length(pts);
AA = zeros(n,Nu,2*k+1,4*k+1,numeric_t);
basis_mtrix = my_vandermonde_u(r,Nu);

for rr = -k:1:k
    for jj = -2*k:1:2*k
        temp = bsxfun(@minus,pts,r')./numeric_t("2") - jj - rr;
        bspine_matrix = Bspine(temp,deg_bspine);
        AA(:,:,rr+k+1,jj+2*k+1)=bspine_matrix * (w.*basis_mtrix);
    end
end

end