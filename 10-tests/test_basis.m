r=[-0.3 -0.2 0 0.1 0.5];
N = 3;

test_u = basis_u(r,N);
test_q = basis_q(r,N);

exact = legendreP(2,r) / sqrt(2/5);
fprintf("test u: %d \n ", test_u);
fprintf("test q: %d \n ", test_q);
fprintf("exact: %d \n ", exact);
