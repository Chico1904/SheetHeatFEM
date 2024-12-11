function [X3, X6] = getNodes
    format long
    clear all
    
    fileID1_t3 = fopen('nodes_t3.txt', 'r');
    fileID1_t6 = fopen('nodes_t6.txt', 'r');
    
    formatspec = '%c'; '%d';
    nodes_t3 = splitlines(fscanf(fileID1_t3, formatspec));
    nodes_t6 = splitlines(fscanf(fileID1_t6, formatspec));
    
    aux_t3=[];
    for i = 11:6:length(nodes_t3)
        aux_t3 = [aux_t3 nodes_t3(i)];
    end
    aux_t3 = aux_t3';
    columns_t3 = split(aux_t3);
    
    aux_t6=[];
    for i = 11:6:length(nodes_t6)
        aux_t6 = [aux_t6 nodes_t6(i)];
    end
    aux_t6 = aux_t6';
    columns_t6 = split(aux_t6);
    
    %variáveis auxiliares
    coord1_t3 = [];
    coord2_t3 = [];
    coordx_t3 = [];
    coordy_t3 = [];
    coordout_t3 = [];
    coord1_t6 = [];
    coord2_t6 = [];
    coordx_t6 = [];
    coordy_t6 = [];
    coordout_t6 = [];
    
    for i = 1:1:length(columns_t3)
        coord1_t3 = [coord1_t3;str2double(columns_t3(i,5))];
        coordx_t3 = [coordx_t3;coord1_t3(i)];
        coord2_t3 = [coord2_t3;str2double(columns_t3(i,6))];
        coordy_t3 = [coordy_t3;coord2_t3(i)];
        coordout_t3 = [coordout_t3;coordx_t3(i),coordy_t3(i)];
    end
    
    for i = 1:1:length(columns_t6)
        coord1_t6 = [coord1_t6;str2double(columns_t6(i,5))];
        coordx_t6 = [coordx_t6;coord1_t6(i)];
        coord2_t6 = [coord2_t6;str2double(columns_t6(i,6))];
        coordy_t6 = [coordy_t6;coord2_t6(i)];
        coordout_t6 = [coordout_t6;coordx_t6(i),coordy_t6(i)];
    end
    
    X3 = [coordx_t3,coordy_t3]./1e3;
    X6 = [coordx_t6,coordy_t6]./1e3;
end

