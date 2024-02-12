function [t, node_val, relative_diff_nodes, per_filtered] = update_script(filter_type, max_time, node_val_init, ...
    A, mu, i_dis, dis_val, break_time, per_filtered)
    % Update Script 
    %
    % DESCRIPTION: 
    %   Update script simulating opinion diffusion. Nodes update their values 
    %       based on that of their in-neighbours. Filters can be implemented 
    %       to restrict which values are used for the update. 
    %       to be implemted allowing for different filter types. 
    %       
    % AUTHOR:
    %   Agathe BOUIS, 12/02/2024
    %
    % INPUTS:
    %   filter_type     type of filter used 
    %                       "ODDI-C"
    %                       "MSR"
    %                       "Mean-based"
    %   it_count        iteration counter
    %   max_time        maximum nb of time steps before break 
    %   node_val_init   value of nodes at time 0 (initialised value)
    %   A               adjacency matrix of graph (full matrix)
    %   mu              learning rate [0,1]
    %   i_DIS           id of disruptive nodes
    %   dis_val         stored byzantine values from previous run 
    %   break_time      is the run stopping based on nb of time steps or 
    %                       stability? [boolean]
    %                       true: let run until stable or meet max time
    %                       false: run until max time
    %   per_filtered    empty array to be filled with percentage of values 
    %                       filtered out by the selected filter per each 
    %                       node over the time elaspsed
    %
    % OUTPUTS:           
    %   t               time elapsed
    %   node_val        array of node values over time
    %   relative_diff_nodes   normalised relative node difference
    %   per_filtered    percentage of values filtered out by the selected 
    %                       filter per each node over the time elaspsed
    %
    % CALLED SCRIPTS:
    %   node_diff  
    %   filter_ODDI_C
    %   filter_MSR
    %   loop_check
    
    % format function input values
    node_val = node_val_init; 
    
    % find min and max values among the nodes
    max_init = max(node_val(:,1));
    min_init = min(node_val(:,1));
 
    % initialise values for start of loop 
    break_check = false;
    k = 1;    
    t = 0;
    n = length(node_val);
    i_normal = 1:n;
    if ~isempty(i_dis)
        i_normal(i_dis) = [];
    end

    % initial difference between nodes
    % only account for the non-disruptive nodes
    relative_diff_nodes = node_diff(node_val(i_normal,1), max_init, min_init);

    while ~break_check
        % increase time counters
        t = cat(2,t,k);                            
        % initialise empty/zero for new node values
        node_val = cat(2,node_val, zeros(n,1));

        if i_dis ~=0
            node_val(i_dis,k+1) = dis_val(1:length(i_dis),k+1); 
        end

        % update of non-disruptor nodes
        for i=1:length(i_normal)
            % index of current (normal) node
            node_id = i_normal(i); 
            % indeces of connected nodes
            conn_idx = find(A(:,node_id)).';
            % connected node values
            conn_val = node_val(conn_idx,k).';
            
            % filter selection
            switch filter_type
                case "ODDI-C"
                    [conn_val_filt] = filter_ODDI_C(conn_val, node_val(node_id,k));
                case "MSR"
                    [conn_val_filt] = filter_MSR(conn_val, i_dis, node_val(node_id,k));
                case "Mean-based"
                    conn_val_filt = conn_val;
            end
            
            per_filtered(i) = (length(conn_val)-length(conn_val_filt))/length(conn_val) + per_filtered(i);
            
            % if ALL connected values have been filtered out
            % node id val stays the same
            if isempty(conn_val_filt) || (length(conn_val)<=2)
                node_val(node_id,k+1) = node_val(node_id,k);
            else
                diff = conn_val_filt-node_val(node_id,k);
                node_val(node_id,k+1) = node_val(node_id,k) + mu*mean(diff);
            end
        end     
        % calculate normalised node difference
        % convergence analysis 
        % only check non-disruptive nodes
        relative_diff_nodes_new = node_diff(node_val(i_normal,k+1), max_init, min_init);
        relative_diff_nodes = cat(2,relative_diff_nodes, relative_diff_nodes_new);
        
        % break if meet stability criteria
        if break_time && k>3
            break_check = loop_check(node_val(i_normal,k+1), node_val(i_normal,k), node_val(i_normal,k-1), error_thresh);
        end
        
        % increase time step
        k = k+1;
        
        % break in case time exceeds maximum run time
        if t(1,end)>max_time
            break
        end
    end
end