function Dvr = my_gradvandermonde_u(r,N)

% r: points
% N: number of basis  

% return Matrix (dimension will be r * N) 
% every row : same point different basis

Dvr = zeros(length(r),N,numeric_t);

for j=1:N % for each column
    Dvr(:,j) = grad_basis_u(r(:),j);
end

end