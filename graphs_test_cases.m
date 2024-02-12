function [s,t, r] = graphs_test_cases(name)
    % Outputs connectivity of selected graph
    % Inputs:
    %   name            test scenario investigated
    %                       "Test_1": 7 nodes (2,2)-robust graph
    %                       "Test_2": 8 nodes (3,1)-robust graph
    %                       "Test_3": 14 nodes (2,2)-robust graph
    %                       "Test_4": 7 nodes (3,3)-robust graph 
    %                       "Test_5": 5 nodes (2,2)-robust DIgraph
    %                       "Test_6": 6 nodes (3,1)-robust DIgraph
    %                       "Test_7": 12 nodes (3,2)-robust DIgraph
    %                       "Test_8": 15 nodes (5,1) or (4/3,2)-robust DIgraph
    %                       "Test_9": 7 nodes (4,1) or (3,2)-robust DIgraph
    %
    % Output:
    %   s & t           graph connectivity
    %   robustness      graph robustness
    switch name
        case "Test_1"
        % (2,2)-robust graph
        % 7 nodes
        %Spoof resilient coordination for distributed multi-robot systems
        %https://ieeexplore.ieee.org/abstract/document/8250942
        r = [2,2];
        s = [1 1 2 2 2 3 3 3 3 4 4 4 4 5 5 5 5 6 6 6 7 7];
        t = [2 3 1 3 4 1 2 4 5 2 3 5 6 3 4 6 7 4 5 7 5 6];
        case "Test_2"
        % (3,1)-robust graph
        % 8 nodes
        %Resilient Asymptotic Consensus in Robust Networks
        %https://ieeexplore.ieee.org/document/6481629
        r = [3,1];
        s = [1 1 1 2 2 2 2 3 3 3 3 4 4 4 5 5 5 5 5 5 6 6 6 6 6 7 7 7 7 7 8 8 8 8 8 8];
        t = [5 6 7 4 5 6 8 4 5 7 8 2 3 8 1 2 3 6 7 8 1 2 5 7 8 1 3 5 6 8 2 3 4 5 6 7];
        case "Test_3"
        % (2,2)-robust
        % 14 nodes
        %Resilient Asymptotic Consensus in Robust Networks
        %https://ieeexplore.ieee.org/document/6481629
        r = [2,2];
        s = [1  1  1 2  2 2 3 3  3  3 4 4  4  4 5 5 5 5  5 6 6 7 7 7  7 8 8 8 8  8 9 9  9  9  9 10 10 10 10 11 11 11 11 12 12 12 12 13 13 13 13 13 13 13 14 14 14 14 14 14 14 14];
        t = [2 12 11 1 12 3 2 4 13 14 3 5 13 14 4 6 7 8 14 5 8 5 8 9 14 5 6 7 9 14 7 8 10 14 13  9 11 13 14  1 10 12 13  1  2 11 13  3 4  9  10 11 12 14  3  4  5  7  8  9 10 13];
        case "Test_4"
        % (3,3)-robust graph
        % 7 nodes
        r = [3,3];
        s = [1 1 1 1 2 2 2 2 2 3 3 3 3 3 4 4 4 4 5 5 5 5 5 6 6 6 6 6 7 7 7 7 7 7];
        t = [2 3 5 7 1 3 4 6 7 1 2 5 6 7 2 5 6 7 1 3 4 6 7 2 3 4 5 7 1 2 3 4 5 6];        
        case "Test_5"
        % (2,2)-robust 
        % 5 nodes
        %digraph
        %Resilient consensus of second-order agent networks: Asynchronous update rules with delays
        %https://www.sciencedirect.com/science/article/pii/S0005109817301310#f000005
        %
        r = [2,2];
        s = [1 1 1 2 2 2 2 4 4 4 4 5];
        t = [2 4 5 1 3 4 5 1 2 3 5 3];  
        case "Test_6"
        % (3,1)-robust 
        %6 nodes
        %digraph
        %Consensus of Hybrid Multi-Agent Systems With Malicious Nodes
        %https://ieeexplore.ieee.org/abstract/document/8721111
        r = [3,1];
        s = [1 1 1 1 2 2 2 2 2 3 3 3 4 4 4 4 5 5 5 5 6 6 6 6];
        t = [2 3 5 6 1 3 4 5 6 2 4 5 2 3 5 6 1 2 4 6 1 2 4 5];
        
        case "Test_7"
        % (3,2)-robust
        % 12 nodes
        %digraph
        %Manually created & tested for robustness
        r = [3,2]; 
        s = [1	1	1	1	1	1	1	1	2	2	2	2	2	2	2	3	3	3	3	3	3	3	3	3	3	4	4	4	4	4	5	5	5	5	5	5	5	6	6	6	6	6	6	6	7	7	7	7	7	7	7	7	7	8	8	8	8	8	8	8	8	8	9	9	9	9	9	9	10	10	10	10	10	10	10	11	11	11	11	11	11	11	12	12	12	12	12	12	12	12];
        t = [2	4	5	7	8	9	10	11	1	4	5	7	9	10	11	1	2	4	5	6	7	8	9	10	12	1	2	5	10	11	1	2	3	4	7	10	11	2	3	8	9	10	11	12	1	2	3	4	5	8	9	10	11	1	2	3	6	7	9	10	11	12	1	2	5	7	8	11	1	2	3	4	5	6	7	1	2	4	5	7	9	12	2	3	4	6	8	9	10	11];
        

        case "Test_8"
        % (5,1)-robust OR (4,2)-robust OR (3,2)-robust
        % 15 nodes
        %digraph
        %Manually created & tested for robustness
        r = [4,2];
        s = [1	1	1	1	1	1	1	2	2	2	2	2	2	2	2	2	2	2	3	3	3	3	3	3	3	3	3	3	4	4	4	4	4	4	4	4	5	5	5	5	5	5	5	5	5	6	6	6	6	6	6	6	6	7	7	7	7	7	7	8	8	8	8	8	8	8	9	9	9	9	9	9	9	10	10	10	10	10	10	10	11	11	11	11	11	11	11	12	12	12	12	12	12	12	12	12	13	13	13	13	13	13	14	14	14	14	14	14	14	14	14	14	14	15	15	15	15	15	15	15	15	15	15	15	15];
        t = [2	6	8	10	12	14	15	1	5	6	8	9	10	11	12	13	14	15	4	5	6	7	9	11	12	13	14	15	1	3	5	6	8	9	14	15	2	3	4	7	9	12	13	14	15	1	2	4	8	9	10	11	15	3	5	9	12	13	14	1	2	6	10	11	13	15	3	4	5	6	7	12	14	1	2	6	8	12	14	15	1	3	6	7	8	13	15	1	2	5	7	9	10	13	14	15	3	5	7	11	12	15	1	2	3	4	5	6	7	9	10	12	13	1	2	5	6	7	8	9	10	11	12	13	14];
        
        
        case "Test_9"
        % (4,1)-robust OR (3,2)-robust
        % 7 nodes
        %digraph
        %Manually created & tested for robustness
        r = [3,2];
        s = [1	1	1	1	1	1	2	2	2	2	2	2	3	3	3	3	3	3	4	4	4	4	4	5	5	5	5	5	5	6	6	6	6	6	7	7	7	7	7	7];
        t = [2	3	4	5	6	7	1	3	4	5	6	7	1	2	4	5	6	7	1	2	3	5	6	1	2	3	4	6	7	1	2	4	5	7	1	2	3	4	5	6];
    end
end