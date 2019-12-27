classdef User_info
    properties
        type % 0: solve PDE; 1: solve Functional
        info % info class (Functional_info or PDE_info)
    end
    methods
        function obj = User_info(type, info)
            obj.type = type;
            obj.info = info;
        end
    end
end