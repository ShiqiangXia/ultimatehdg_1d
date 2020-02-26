function Print_Estimator_result(num_element_list,error_list_j,error_bound_list)
    for ii = 1:length(num_element_list)
        fprintf('%-4.4d | %-14.2e %-14.2e %-6.2f |\n',num_element_list(ii),error_list_j(ii),error_bound_list(ii),error_bound_list(ii)/error_list_j(ii));
    end
end