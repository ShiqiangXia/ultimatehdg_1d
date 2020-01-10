function out= Bspine_break_quadrature(deg_bspine,center_pt,x_l,x_r,r,w,Nu)
% compute integral using quadratures


% map to refer element
half_h = abs(x_r-x_l)*numeric_t('0.5');
mid    = (x_r+x_l) * numeric_t('0.5');
spline_pts = half_h * r + mid;
bspine_matrix = Bspine(spline_pts,deg_bspine);

basis_pts = numeric_t('2')*(center_pt-spline_pts);
basis_mtrix = my_vandermonde_u(basis_pts,Nu);

out = numeric_t('2')*half_h*bspine_matrix'*(w.*basis_mtrix);
end