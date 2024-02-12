clear all 
close all 

% Filter comparison - fixed connectivity, increasing nb of disruptors
%
% DESCRIPTION:
%   Comparing filter types for random graph scenarios facing off increasing 
%   numbers of disruptors. Simulations tested for fixed connectivity
%   (in-degree) levels. Monte Carlos performed for each nb of
%   disruptors present in the system. 
%   
% STRENGTH
%   Fault resilience (up to UNKNOWN faults) 
%   No Network topology knowledge is required
%   Knowledge of number of faults in system not required 
%
% WEAKNESSES
%   Synchronous/no delay tolerance
%   No dynamic byzantine behaviour (no colluding)
%   Non intelligent byzantine agents
%   No time shifting tolopogy 
%   No drift
%
% CALLED FUNCTIONS:
%   disruptor_parameters
%   disruptor_node_val
%   init_dist
%   connection_based_graphs
%   update_script
%   opinion_plots_single
%   opinion_plots_multi
%
% AUTHOR:
%  Agathe BOUIS 12/02/2024
%
% INPUTS
% experiment_3              run experiment 3 from Bouis, A., Clark R. A., 
%                               Macdonald M, (2024) "Engineering consensus 
%                               in static networks with unknown disruptors" 
%                                   > true - experiement 3
%                                   > false - select inputs for simulation
%                                       of choice
% types of filter compared
% filter_type_array         type of filter tested
%                               "ODDI-C"
%                               "MSR"
%                               "Mean-based"
%
% monte_carlo               length of monte carlo simulations
%                               scenario is tested (random graphs)
% monte carlo tested parameter - number of disruptors in systems
% codes tests disruptors range of [dis_start:test_step_size:dis_max]
% dis_start                 starting nb of disruptor nodes
% dis_max                   max nb of disruptor nodes
% test_step_size            step size of nb of disruptors
% dis_type                  possible behaviour of disruptor nodes [func_1, func_2,...]
%                               "sine_wave": large amplitude sine wave
%                               "lin_const": linear function
%                               "noise": random   
%
% parameters of random graphs created: 
% n                         number of nodes in network tested
% max_conn                  max connectivity (in-deg) tested
% conn_type                 type of graph tested 
%                               "same_conn" - same connectivity for each
%                               node
%                               "normal_dist_conn" connectivity based on
%                               normal distribution
% min_indeg_input           min in-deg allowed (if not same conn)
%
% initial node value distribution 
% init_dist_type            initial distribution type
%                               "rdm": random dist
%                               "uniform": uniform 
%                               "normal": normal 
% max_allowable             maximum allowable in distribution 
% min_allowable             min allowable in distribution 
%
% simulation parmeters: 
% max_time_step             max possible nb of time steps
% break_time                what run scenario [boolean]
%                               true: let run until stable or meet max time
%                               false: run until max time
% mu                        learning rate/update step
% abs_zero_val              min abstolute difference
%                               calculate min value of convergence metric 
%                               from it
%                               replace "0" by - usually 10^(-7)
%
% plot_mc_iteration         choice of which plots to output [boolean]
%                           PER MONTE CARLO SIMULATION
%                               true/false - "Node Trajectory" 
%                               true/false - "Convergence Metric"
% plot_mc_avg               choice of which plots to output [boolean]
%                           AVERAGED OVER THE MONTE CARLO SIM
%                               true/false - "Scatter" 
%                               true/false - "Error Bars" 
%                               true/false - "Filtered Values Percentage"
%
% OUTPUTS
% node_val                  evolution of node values over time 
% t                         associated time array
% convergence metric        relative convergence between compliant nodes
%
% POSSIBLE PLOTS
% Per each connectivity test [plot_mc_iteration]
%   node trajectory
%   convergence metric
% For entire model [plot_mc_avg]
%   scatter
%   error bars
%   filtered values percentage

%% INPUTS 
% run experiment 3?
% yes, experience_3 = true
% no, experience_3 = false
experience_3 = false;

% tested filters
filter_type_array = ["ODDI-C", "MSR"];
% monte-carlo length 
monte_carlo = 50;
% tested parameter range [dis_start:test_step_size:dis_max]
dis_max = 8;
dis_start = 0;
test_step_size = 1;

% network connectivity
n = 20;
conn = 6;
conn_type = "normal_dist_conn";

% node values initial 
init_dist_type = "normal";
min_allowable = 1;
max_allowable = 15;
% simulation parameters
max_time_step = 40; 
break_time = false;         
mu = 0.5; 
abs_zero_val = 10^(-7);
possible_dis_types = ["sine_wave", "lin_const", "noise"];

% plotting directory
plot_dict_mc_iteration = [false false];
plot_dict_mc_avg = [false true false];

%% INITIALISATION 
% Actual length of test
dis_test = dis_start:test_step_size:dis_max;

% OPTIONAL: can create a single graph on which to run simulations 
% graph will remain constant throughout the entire run
% [A, min_indeg_input, network_description_mc_iteration] = connection_based_graphs(n, conn , conn_type);
% graph_stats = ['Network has ' num2str(n) ' Nodes, a Min Indeg of ' num2str(network_description_mc_iteration(1)) ', and Avg Indeg of ' num2str(network_description_mc_iteration(2)) '...'];
% disp(graph_stats)
% disp("...")

% create random disruptor values
dis_val = [];
dis_val_new = [];
if dis_start==0
    i_dis= [];
    dis_type= strings(0,1);
    dis_type_new = strings(0,1);
    dis_param = [];
else
    i_dis = randsample(n, dis_start);
    dis_type_new_idx = randsample(length(possible_dis_types), dis_start, true);
    dis_type = possible_dis_types(dis_type_new_idx);
    dis_param = disruptor_parameters(dis_type, max_allowable, min_allowable, false, max_time_step);
    for dis_id=1:length(i_dis)
        dis_val(dis_id,:) =  disruptor_node_val(dis_type(dis_id), dis_param(dis_id, :), max_allowable, min_allowable, (1:max_time_step+2));
    end
end

% initialise arrays
convergence_metric_mc = zeros(monte_carlo, max_time_step+2);
convergence_metric = zeros(length(dis_test), max_time_step+2);
convergence_metric_max = zeros(length(dis_test), max_time_step+2);
convergence_metric_min = zeros(length(dis_test), max_time_step+2);
convergence_metric_err = zeros(length(dis_test), max_time_step+2);
network_description  =  zeros(length(dis_test), 2);
boxplot_data = zeros(monte_carlo, max_time_step+2);
percentage_filtered = zeros(length(dis_test),1);


% start values
node_val = init_dist(init_dist_type, n, min_allowable, max_allowable);
zero_val = abs_zero_val/(max(node_val)-min(node_val));


if experience_3 
    n = 20;
    conn = 6;
    mu = 0.5;
    conn_type = "same_conn";
    min_allowable = 1;
    max_allowable = 15;
    dis_type_exp = ["sine_wave",	"sine_wave",	"noise",	"sine_wave",	"noise",	"noise",	"sine_wave",	"lin_const"];
    dis_param_exp = [1.2452, 0.3666, 1.6825, 0.2100;
                1.12364, 0.0884, 4.39579, 1.1349;
                0,	0,	0,	0;
                3.9310,	0.4889,	0.4714,	4.4269;
                0,	0,	0,	0
                0,	0,	0,	0
                2.4377,	0.6073,	3.0983,	-2.0523;
                -0.3156, 0,	0, 0];
end



% SIMULATIONS
for Test_runs = 1:length(filter_type_array)
filter_type = filter_type_array(Test_runs);
counter = 1;
for dis_iteration=dis_start+1:test_step_size:dis_max+1    
    percentage_filtered_mc=zeros(n-(dis_iteration-1), 1);
    disp(["Filter type: " + filter_type  + ", # Disruptors: " +  num2str(dis_iteration-1) + '...']);
    disp("...")


    % if disruptive nodes not already created
    if size(dis_param,1)<(dis_iteration-1)
        
        if experience_3 
            dis_type_new=dis_type_exp(1,(dis_iteration-test_step_size):(dis_iteration-1));
            if isempty(dis_type)
                dis_type=dis_type_new;
            else
                dis_type=cat(2, dis_type, dis_type_new);          
            end
            dis_param_new=dis_param_exp((dis_iteration-test_step_size):(dis_iteration-1),1:4);
            dis_param = cat(1,dis_param, dis_param_new);
        else
            dis_type_new_idx = randsample(length(possible_dis_types),((dis_iteration-1)-length(dis_type)), true);
            dis_type_new = possible_dis_types(dis_type_new_idx);
            if isempty(dis_type)
                dis_type=dis_type_new;
            else
                dis_type=cat(2, dis_type, dis_type_new);          
            end
            
            dis_param_all_new = disruptor_parameters(dis_type, max_allowable, min_allowable, false, max_time_step);
            dis_param_new = dis_param_all_new((end-(test_step_size-1)):end,:);
            dis_param = cat(1,dis_param, dis_param_new);
        end
        
        for dis_id=1:test_step_size
            dis_val_new = disruptor_node_val(dis_type_new(dis_id), dis_param_new(dis_id, :), max_allowable, min_allowable, (1:max_time_step+2));
            dis_val = cat(1,dis_val, dis_val_new);
        end        
    end 

    % MONTE CARLO 
    for mc_iteration=1:monte_carlo
        % id of disruptor nodes
        i_dis = randsample(n, dis_iteration-1);

        % create random graph
        [A, min_indeg_input, network_description_mc_iteration] = connection_based_graphs(n, conn, conn_type);

        % update 
        [t, node_val, diff_nb, percentage_filtered_mc] = update_script(filter_type, max_time_step, node_val(:,1), ...
        A, mu, i_dis, dis_val, break_time, percentage_filtered_mc);
        
        % calculate & store convergence metric
        convergence_metric_mc_iteration = diff_nb(1,:)./max(diff_nb(1,:));
        convergence_metric_mc_iteration(convergence_metric_mc_iteration<zero_val)=zero_val;
        convergence_metric_mc(mc_iteration, :) = convergence_metric_mc_iteration;
        
        % plot single run
        opinion_plots_single(node_val, t, i_dis, dis_iteration, ...
            plot_dict_mc_iteration, convergence_metric_mc_iteration, zero_val)        
    end
    
    % monte carlo a nalysis 
    convergence_metric(counter, :) = mean(convergence_metric_mc, 1, "omitnan");

    convergence_metric_max(counter, :) = max(convergence_metric_mc, [], 1) ;
    convergence_metric_min(counter, :) = min(convergence_metric_mc, [], 1) ;
    convergence_metric_min(counter, convergence_metric_min(counter,:)==0) = convergence_metric(counter, convergence_metric_min(counter,:)==0);

    network_description(counter, :) = network_description_mc_iteration;

    boxplot_data(:,counter:length(dis_test):end) = convergence_metric_mc(:,counter:length(dis_test):end);

    percentage_filtered_mc=percentage_filtered_mc./((max_time_step+2)*monte_carlo);
    percentage_filtered(counter,:) = mean(percentage_filtered_mc);

    counter = counter+1;
end

%% PLOTTING

% name plotted lines
names = strings(1,length(dis_test));
name_spec = " %G Disruptive Agents";
for i=1:length(dis_test)
    names(1,i) = sprintf(name_spec,dis_test(1,i));
end
% plot
 opinion_plots_multi(t, test_step_size, convergence_metric, ...
     convergence_metric_max, convergence_metric_min, boxplot_data, percentage_filtered, ....
     dis_test, plot_dict_mc_avg, filter_type, names, zero_val)
end



