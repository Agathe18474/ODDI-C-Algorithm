clear all 
close all 

% Filter comparison - fixed nb disruptors, increasing connectivity
%
% DESCRIPTION:
%   Comparing filter types for random graph scenarios facing off fixed 
%   numbers of disruptors. Simulations tested for increasing connectivity
%   (in-degree) levels. Monte Carlos performed for each connectivity
%   level. 
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
%
% experiment_2              run experiment 3 from Bouis, A., Clark R. A., 
%                               Macdonald M, (2024) "Engineering consensus 
%                               in static networks with unknown disruptors" 
%                                   > true - experiement 2
%                                   > false - select inputs for simulation
%                                       of choice
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
%                               "sine_large_amp": large amplitude sine wave
%                               "sine_small_amp": small amp sine wave
%                               "sine_very_small_amp": very small amp sine wave
%                               "const": constant 
%                               "lin_const": constant linear increase
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
% to simulate experiments from 
% Bouis, A., Clark R. A., Macdonald M, (2024) "Engineering consensus in 
% static networks with unknown disruptors, inspired by social dynamics" 
% run experiment 2?
% yes, experiment_2 = true
% no, experiment_2 = false
experiment_2 = true;

% tested filters
filter_type_array = ["ODDI-C", "MSR"];
% monte-carlo length 
monte_carlo = 50;
% tested parameter range [max_conn:test_step_size:start_conn]
conn_max = 15;
conn_start = 3;
test_step_size = 2;

% does the disruptive behaviour change in each simulation?
dis_nb = 5;
dis_random_swap_flag = false;

% network connectivity
n = 20;
conn = 6;
conn_type = "same_conn";

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
if experiment_2
    % if run experiment 2, overwrite values selected 
    conn_max = 15;
    conn_start = 3;
    test_step_size = 2;
    init_dist_type = "normal";
    min_allowable = 1;
    max_allowable = 15;
    mu = 0.5; 
    abs_zero_val = 10^(-7);
    dis_random_swap_flag = false;
    dis_type = ["sine_wave"	"sine_wave"	"lin_const"	"sine_wave"	"noise"];
    i_dis = randsample(n, dis_nb);
    dis_param = [3.1381, 0.1137,	1.2050,	-3.9058;
        0.2217,	0.5181,	0.9961,	-1.5561;
        0.5738,	0,	0,	0;
        0.2203,	0.39528,	4.5602,	-0.0241;
        0,	0,	0,	0];
    for dis_id=1:length(i_dis)
        dis_val(dis_id,:) =  disruptor_node_val(dis_type(dis_id), dis_param(dis_id, :), max_allowable, min_allowable, (1:max_time_step+2));
    end
    disp("Running Experiment 2")
    disp("...")
else
    if dis_random_swap_flag == false
        % changing byzantine agents
        dis_val = [];
        dis_val_new = [];
        i_dis = randsample(n, dis_nb);
        dis_type_new_idx = randsample(length(possible_dis_types), dis_nb, true);
        dis_type = possible_dis_types(dis_type_new_idx);
        dis_param = disruptor_parameters(dis_type, max_allowable, min_allowable, false, max_time_step);
        for dis_id=1:length(i_dis)
            dis_val(dis_id,:) =  disruptor_node_val(dis_type(dis_id), dis_param(dis_id, :), max_allowable, min_allowable, (1:max_time_step+2));
        end        
    end
end

% Actual length of test
conn_test = conn_start:test_step_size:conn_max;

convergence_metric_mc = zeros(monte_carlo, max_time_step+2);
convergence_metric = zeros(length(conn_test), max_time_step+2);
convergence_metric_max = zeros(length(conn_test), max_time_step+2);
convergence_metric_min = zeros(length(conn_test), max_time_step+2);
convergence_metric_err = zeros(length(conn_test), max_time_step+2);
network_description  =  zeros(length(conn_test), 2);
boxplot_data = zeros(monte_carlo, max_time_step+2);
percentage_filtered = zeros(length(conn_test),1);


colours = parula(length(conn_test)+1);
colours_boxplot = repmat(colours(1:end-1,:), ceil((max_time_step+2)/(length(conn_test))),1);

% start values
node_val = init_dist(init_dist_type, n, min_allowable, max_allowable);
zero_val = abs_zero_val/(max(node_val)-min(node_val));

for Test_runs =1:length(filter_type_array)
    filter_type = filter_type_array(Test_runs);
    counter = 1;
for conn_iteration=conn_start:test_step_size:conn_max
    max_filter_mc=zeros(n-dis_nb, 1);
    percentage_filtered_mc=zeros(n-dis_nb, 1);
    disp(["Filter type: " + filter_type  + ", Graph Connectivity: " +  num2str(conn_iteration) + '...']);
    disp("...")
    
    for mc_iteration=1:monte_carlo
        % if flag on
        % change disruptor id & value at each iteration
        if dis_random_swap_flag
            dis_val = [];
            dis_val_new = [];
            i_dis = randsample(n, dis_nb);
            dis_type_new_idx = randsample(length(possible_dis_types), dis_nb, true);
            dis_type = possible_dis_types(dis_type_new_idx);
            dis_param = disruptor_parameters(dis_type, max_allowable, min_allowable, false, max_time_step);
            for dis_id=1:length(i_dis)
                dis_val(dis_id,:) =  disruptor_node_val(dis_type(dis_id), dis_param(dis_id, :), max_allowable, min_allowable, (1:max_time_step+2));
            end
        end

        % create random graph
        [A, min_indeg_input, network_description_mc_iteration] = connection_based_graphs(n, conn_iteration, conn_type);

        % update 
        [t, node_val, diff_nb, percentage_filtered_mc] = update_script(filter_type, max_time_step, node_val(:,1), ...
        A, mu, i_dis, dis_val, break_time, percentage_filtered_mc);

        % calculate & store convergence metric
        convergence_metric_mc_iteration = diff_nb(1,:)./max(diff_nb(1,:));
        convergence_metric_mc_iteration(convergence_metric_mc_iteration<zero_val)=zero_val;
        convergence_metric_mc(mc_iteration, :) = convergence_metric_mc_iteration;
        
        % plot single run
        opinion_plots_single(node_val, t, i_dis, conn_iteration, ...
            plot_dict_mc_iteration, convergence_metric_mc_iteration)  
    end
    
    % monte carlo analysis 
    convergence_metric(counter, :) = mean(convergence_metric_mc, 1, "omitnan");

    convergence_metric_max(counter, :) = max(convergence_metric_mc, [], 1) ;
    convergence_metric_min(counter, :) = min(convergence_metric_mc, [], 1) ;
    convergence_metric_min(counter, convergence_metric_min(counter,:)==0) = convergence_metric(counter, convergence_metric_min(counter,:)==0);

    network_description(counter, :) = network_description_mc_iteration;

    boxplot_data(:,counter:length(conn_test):end) = convergence_metric_mc(:,counter:length(conn_test):end);

    percentage_filtered_mc=percentage_filtered_mc./((max_time_step+2)*monte_carlo);
    percentage_filtered(counter,:) = mean(percentage_filtered_mc);

    counter = counter +1;
end

% name each plot
names = strings(1,length(conn_test));
if conn_type == "same_conn"
    name_spec = "In-degree %G";
    for i=1:length(conn_test)
        names(1,i) = sprintf(name_spec,network_description(i, 1));
    end
elseif conn_type == "normal_dist_conn"
    name_spec = "Min InDeg %G, Avg InDeg %0.2G";
    for i=1:length(conn_test)
        names(1,i) = sprintf(name_spec,network_description(i, 1), network_description(i, 2));
    end
end 

opinion_plots_multi(t, test_step_size, convergence_metric, ...
     convergence_metric_max, convergence_metric_min, boxplot_data, percentage_filtered, ....
     conn_test, plot_dict_mc_avg, filter_type, names, zero_val)
end



