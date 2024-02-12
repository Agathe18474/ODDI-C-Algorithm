function  opinion_plots_single(node_val, t, i_dis, start_counter, ...
    plot_dict, convergence_metric, zero_val)
    % Plots SINGLE RUN of opinion diffusion scenario scenario as per plot 
    % dictionary selection
    % INPUTS:
    %   node_val            exact node values
    %   t                   time elapsed
    %   i_dis               id of disruptive nodes
    %   starting counter
    %   plot_dict           dictionary of plot selections [boolean]. Allows: 
    %                           node trajectory
    %                           convergence metric           
    %   convergence metric    array of convergence metric for a single run 
    % OUTPUTS:
    %  node trajectory plot
    %  convergence metric plot
   
    n = size(node_val,1);

    i_normal = true(1,n).';
    if ~isempty(i_dis)
        i_normal(i_dis) = false;
    end

    if ~exist('node_names','var')
        % if node_names do not exist, initialise manually 
        % initialise node names
        node_names = strings(1,n);
        node_node_spec = "Node %d";
        
        for i=1:n
            node_names(1,i) = sprintf(node_node_spec,i);
        end
        node_names(i_dis) = "Disruptive Node";
    end
    %node_name_healthy = node_names;
    %node_name_healthy(i_dis)=[];

    % colours
    newcolors= [0.83 0.14 0.14
             1.00 0.54 0.00
             0.47 0.25 0.80
             0.25 0.80 0.54
             0 0 4/256
             139/256 10/256 165/256
             200/256 230/256 40/256
             101/256 21/256 110/256
             159/256 42/256 99/256
             160/256 218/256 57/256
             245/256 125/256 21/256
             250/256 194/256 40/256
             42/256 137/256 120/256];

    
    if plot_dict(1)
        % NODE TRAJECTORY
        f = figure(1 + (start_counter-1)*2);
        clf
        hold on
        
        tt_normal = repmat(t,(n-length(i_dis)),1);
        plot(repmat(t,length(i_dis),1).', node_val(~i_normal,:).', '--', 'Color','#21918c')

        % % if ~isempty(multi_colour_opt)
        % %     %multi colour
        % %     colororder(newcolors);
        % %     h = plot(tt_normal.', node_val(i_normal,:).');
        % %     legend("E", "E", node_name_healthy, 'Location', 'northeastoutside')
        % % else
            %single colours
            h = plot(tt_normal.', node_val(i_normal,:).', 'Color', '#440154');
            line_names = ["Compliant Nodes", "Disruptive Nodes"];
            line_widths = [1.5,1];
            line_type = ["-", "--"];
            cols =  ['#440154'; '#21918c'];
            legend('','Location', 'northeast')
            for j =1:length(line_names)            
                plot(NaN, NaN, line_type(j), 'Color', cols(j,:), 'DisplayName', line_names(j),'LineWidth', line_widths(j))
            end
       % end
        
        grid on
        xlabel("Time steps")
        ylabel("Node Values")        
        box on 
        fontsize(f,13, "points")
        xlim([0 t(end)])
        
       
        % PLOT FOR PAPERS
        %
        %legend('','Location', 'northeast')
        %cols =  ['#440154'; '#21918c'];
        %line_type = ["-", "--"];
        %for j =1:length(line_names)            
        %    plot(NaN, NaN, line_type(j), 'Color', cols(j,:), 'DisplayName', line_names(j),'LineWidth', line_widths(j))
        %end

    
    end

    if plot_dict(2)
        % RELATIVE CONVERGENCE METRIC
        f = figure(2 + (start_counter-1)*2);
        clf
        semilogy(t,convergence_metric, 'k') 
        xlim([0 t(end)])
        ylim([zero_val 1]) 
        xlabel("Time steps")
        ylabel("Convergence Metric")
        grid on
        box on 
        fontsize(f,13, "points")
        
    end
end