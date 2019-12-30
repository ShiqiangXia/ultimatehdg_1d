function [x,w] = my_quadrature(N)

%% Use Gauss Quadrature with N+1 points
%  accuracy: 2N+1

[x,w] = JacobiGQ(0,0,N);

end