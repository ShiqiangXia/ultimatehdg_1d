function main_driver(user_info, precision)

%% Set up precision
global class_t;
class_t=precision;

%%
if user_info.type == 0 
%% Solve PDE
    fprintf("--------------------\n")
    fprintf("Solve PDE problem.\n")
    PDE_driver(user_info.info)

else
%% Solve Functional
    functional_driver(user_info.info)

end

end