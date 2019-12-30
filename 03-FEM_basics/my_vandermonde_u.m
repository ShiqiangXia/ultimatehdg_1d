function V1D = my_vandermonde_u(r,N)

% r: points
% N: number of basis  

% return Matrix (dimension will be r * N) 
% every row : same point different basis

V1D = zeros(length(r),N,numeric_t);

for j=1:N % for each column
    V1D(:,j) = basis_u(r(:),j);
end

end