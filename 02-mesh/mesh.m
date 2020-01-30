% Mesh in 1D
%
% Oliver Xia 12/28/2019
%
% Assume we number the elements from the left to the right in ascending
% order.
classdef mesh
    
    
    properties(Access = private)
        
        %% hide all properties 
        N_nds % number of nodes
        nodes % all the face points
        max_h % max of element size h
        type %  "uniform"; "non-uniform"
    end
    
    methods
        %% general mesh based on all the nodes
        function obj = mesh(nodes)
            % assume the nodes are sorted in ascending order!!!!!
            eof = numeric_t('1e-12');
            nds       = length(nodes);
            obj.nodes = nodes;
            obj.N_nds = nds;
            
            temp_h = nodes(2:end) - nodes(1:end-1);
            max_h = max(temp_h);
            min_h = min(temp_h);
            
            obj.max_h = max_h;
            if max_h - min_h <= eof
                obj.type = "uniform";
            else
                obj.type = "non-uniform";
            end
            
        end
        
        %% methods about the mesh
        
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function out = get_faces(obj,idx)
            % given element index, return the two faces points
            if (idx > obj.N_elemets() || idx<1)
                fprintf("ERROE: the element idx is out of range!")
                out = NaN;
            else
                out = [obj.nodes(idx) obj.nodes(idx+1)];
            end
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function out = get_elements(obj,idx)
            % given the node idx, return the two element idx that share this
            % face
            if (idx>obj.N_nodes() || idx<1)
                fprintf("ERROR: the face idx is out of range")
                out = NaN;
            else
                if (idx>=2 && idx <= obj.N_nodes-1)
                    out = [idx-1, idx];
                elseif (idx == 1)
                    out = idx;
                else
                    out = idx-1;
                    
                end
            end
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function out = boundary_nodes_or_not(obj,idx)
            if (idx == 1 || idx == obj.N_nodes())
                out = true ;
            else
                out = false ;
            end
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function new_mesh = mesh_uniform_refine(obj)
            % Uniformly refine mesh
            nds = obj.all_nodes();
            temp = (nds(1:end-1)+nds(2:end))./numeric_t(2); % compute all midpoints
            new_nds = sort([nds temp]); % put together and sort
            
            new_mesh = mesh(new_nds);
            
            
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function new_mesh = mesh_nonuniform_refine(obj,refine_vector)
            % based on the refine_vector to refine the mesh
            num_ele = obj.N_elemets();
            nds = obj.all_nodes();
            ll      = length(refine_vector);
            
            if (num_ele ~= ll)
                fprintf("ERROR:the refine vector has the wrong size! No refinement applied.")
            else
                temp = (nds(1:end-1)+nds(2:end))./numeric_t(2); % compute all midpoints
                
                % only use midpoints for those that needed to be refined
                add_pts = temp(refine_vector==1); 
                
                new_nds = sort([nds add_pts]); % put together and sort
                
                new_mesh = mesh(new_nds);
              
            end
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        function new_mesh = get_background_uniform_mesh(obj)
            if obj.mesh_type == "uniform"
                new_mesh = obj;
            else
                h = obj.max_h;
                new_nodes = numeric_t('0'):h:numeric_t('1');
                new_mesh = mesh(new_nodes);
            end
        end
        
        
        %% methods to access mesh properties
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function num = N_elemets(obj)
            num = obj.N_nds - 1;
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function num = N_nodes(obj)
            num = obj.N_nds;
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function num = N_faces(obj)
            num = 2* (obj.N_nds-1);
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function t = mesh_type(obj)
            t = obj.type;
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function nds = all_nodes(obj)
            nds = obj.nodes;
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function h = get_max_h(obj)
            h = obj.max_h;
        end
        
        
        
    end
end