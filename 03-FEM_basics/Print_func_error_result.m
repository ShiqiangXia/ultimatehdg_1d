function Print_func_error_result(num_element_list,error_list_j,error_list_j_adj,order_j,order_j_adj)
order_j = [0;order_j];
order_j_adj = [0;order_j_adj];

%T = table(num_element_list,error_list_uh,order_u,error_list_qh,order_q,error_list_uhat,order_uhat);
%disp(T);
fprintf('%-4s | %-14s %-6s | %-14s %-6s |\n','N','J(u)-Jh(u_h)','Order','J(u)-J(u_h)','Order')
for ii = 1:length(num_element_list)
    fprintf('%-4.4d | %-14.2e %-6.2f | %-14.2e %-6.2f |\n',num_element_list(ii),error_list_j_adj(ii),order_j_adj(ii),error_list_j(ii),order_j(ii));
end

end