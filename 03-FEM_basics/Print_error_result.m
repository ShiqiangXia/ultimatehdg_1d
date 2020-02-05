function Print_error_result(num_element_list,error_list_qh,error_list_uh,error_list_uhat,order_q,order_u,order_uhat)
order_q = [0;order_q];
order_u = [0;order_u];
order_uhat = [0;order_uhat];

%T = table(num_element_list,error_list_uh,order_u,error_list_qh,order_q,error_list_uhat,order_uhat);
%disp(T);
fprintf('%-4s | %-14s %-6s | %-14s %-6s | %-14s %-6s|\n','N','E_u','Order','E_q','Order','E_uhat','Order')
for ii = 1:length(num_element_list)
    fprintf('%-4.4d | %-14.2e %-6.2f | %-14.2e %-6.2f | %-14.2e %-6.2f|\n',num_element_list(ii),error_list_uh(ii),order_u(ii),error_list_qh(ii),order_q(ii),error_list_uhat(ii),order_uhat(ii));
end

end