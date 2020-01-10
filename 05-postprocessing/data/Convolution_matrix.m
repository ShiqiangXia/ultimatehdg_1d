% Oliver Xia 01/08/2020
% Return Convolution matrix 
% #points x Nu x (2k+1) x (4k+1)

function AA = Convolution_matrix(k,Nu,pts,N_GQ)

% use Bspine of order k+1;
% Polynomial degree is Nu-1;
% pts are the points of interest;
% pts need to be a COLUMN vector

deg_bspine = k+1;
%[r,w] = my_quadrature(N_GQ);

n = length(pts);
AA = zeros(n,Nu,2*k+1,4*k+1,numeric_t);

% compute Gauss Quadratue point values of basis functions
%basis_mtrix = my_vandermonde_u(r,Nu);

for rr = -k:1:k
    for jj = -2*k:1:2*k
        for nn = 1:n
        % compute pt_n/2 - jj - r_n/2 -r
            center_pt = pts(nn)/numeric_t("2") - jj - rr;
            %[breaks,spline_flag] = Bspline_breaks(deg_bspine,temp);
        
        % compute Bspine_k+1 (pt_n/2 - jj - r_n/2 -r)
        % matrix: each row same point, diffent Gauss points rn
            bspine_matrix = Bspline_int(deg_bspine,center_pt,Nu,N_GQ);
            %bspine_matrix = Bspine(temp,deg_bspine);
        
        % numerical quadratue
            AA(nn,:,rr+k+1,jj+2*k+1)=bspine_matrix;
        end
    end
end

end