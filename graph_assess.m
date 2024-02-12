function [G,A,n] = graph_assess(s,t)
    % Assess graph parameters & determine if s,t form a 
    % directed or undirected graph
    % Inputs:
    %   s & t       nodes connections
    % Output:
    %   G           graph or digraph
    %   A           full adjacency matrix
    %   n           nb of nodes
    
    G = digraph(s,t);
    A = full(adjacency(G));
    if issymmetric(A)
        %matrix = symmetric = undirected graph
        %else undirected graph
        G = graph(A);               
    end
    n = height(G.Nodes);                            %nb of nodes
    G.Nodes.PageRank = centrality(G,'pagerank');    %centrality
end
