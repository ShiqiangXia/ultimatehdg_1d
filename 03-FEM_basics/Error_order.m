function [order_q,order_u,order_uhat] = Error_order(num_element_list,error_list_qh,error_list_uh,error_list_uhat)

N_list = log((num_element_list(2:end)./num_element_list(1:end-1)));

order_q = log(error_list_qh(1:end-1)./error_list_qh(2:end))./N_list;
order_u = log(error_list_uh(1:end-1)./error_list_uh(2:end))./N_list;
if error_list_uhat~=0
    order_uhat = log(error_list_uhat(1:end-1)./error_list_uhat(2:end))./N_list;
end

end