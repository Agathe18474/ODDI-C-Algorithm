function [conn_val_filt, conn_val_filt_z] = filter_ODDI_C(conn_val, node_id_val)
% Opinion Dynamics-inspired Disruption-tolerant Consensus (ODDI-C) Filter
%
% DESCRIPTION: 
%   Filters values out if their median z-score are smaller than the node's 
%   own median z-score. Ensures that the more of an outlier a node is, 
%   the more willing it will be to account for other opinions while a 
%   node fitting in with other nodes will stay put.
%
%   Inspired by Deffuant-Weisbuch opinion model & adapted using 
%   Robust Statiscal Approaches (median, MAD, and scaled MAD)
%
% REFERENCES:
%   [1] P. Sobkowicz, "Extremism without extremists: Deffuant model 
%   with emotions", Front Phys. Interdisciplinary Phys, vol. 3, 
%   pp. 17, Mar. 2015.
%   [2] https://en.wikipedia.org/wiki/Median_absolute_deviation
%   [3] https://en.wikipedia.org/wiki/Robust_measures_of_scale
%   [4] https://www.itl.nist.gov/div898/software/dataplot/refman2/auxillar/mad.htm
%
% AUTHOR:
%   Agathe BOUIS, 22/01/2024
%
% INPUTS:
%   conn_val        connected nodes' values 
%
% OUTPUTS:           
%   conn_val_filt   connected nodes' filtered out values

    
    %median 
    med = median(conn_val);
    % median absolute deviation
    MAD = median(abs(conn_val-med));
    % scaled MAD
    MAD_scaled = MAD/0.6745 ;
    % connected values z-score (median based)
    conn_z = abs((conn_val-med)./MAD_scaled);

    %Hampel identifier, values outside of +/- 3*NMAD 
    %filter_val = abs((MAD_scaled*3)-med)/MAD;
    filter_val = 3;

    

    %conn_z(1,abs(conn_val-med)>3*MAD_scaled)=inf;
    % if length(conn_z(1,abs(conn_val-med)>3*MAD_scaled))>0
    %     a=a+1;
    % end
    % if abs(node_id_val-med)>3*MAD_scaled
    %     node_id_val=med+3*MAD_scaled;
    % end
    % % node id z-score
    z_node_id = abs((node_id_val-med)./MAD_scaled);

     %min filter val
   %  min_val = min(conn_z(conn_z>0))
    % 
    % % catch error
    % % prevent filter from reaching inf when MAD=0
    if isinf(z_node_id)
        z_node_id=0;
    end
    % % filter
    % if z_node_id<min_val
    %     z_node_id=min_val
    % end

    if z_node_id>filter_val                                    
       z_filter = filter_val;
    else 
         z_filter = z_node_id;
     end
    % % filtered values
    conn_val_filt_z = conn_z(1,conn_z<=z_filter);
     conn_val_filt = conn_val(1,conn_z<=z_filter);
    
   

    %conn_val_filt = conn_val(1,abs(conn_val-med)<3*MAD_scaled);

end