function Print_error_result(num_element_list,error_list_qh,error_list_uh,error_list_uhat,order_q,order_u,order_uhat)
order_q = [0;order_q];
order_u = [0;order_u];
order_uhat = [0;order_uhat];

T = table(num_element_list,error_list_uh,order_u,error_list_qh,order_q,error_list_uhat,order_uhat);
disp(T);

end