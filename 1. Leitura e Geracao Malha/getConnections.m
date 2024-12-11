function [tri3, tri6] = getConnections
    format long
    clear all
    
    fileID0_t3 = fopen('elements_t3.txt', 'r');
    fileID0_t6 = fopen('elements_t6.txt', 'r');
    
    formatspec = '%c'; '%d';
    elements_t3 = splitlines(fscanf(fileID0_t3, formatspec));
    elements_t6 = splitlines(fscanf(fileID0_t6, formatspec));
    
    aux_t3=[];
    for i = 17:1:324
        aux_t3 = [aux_t3 elements_t3(i)];
    end
    aux_t3 = aux_t3';
    columns_t3 = split(aux_t3);
    
    aux_t6=[];
    for i = 17:1:92
        aux_t6 = [aux_t6 elements_t6(i)];
    end
    aux_t6 = aux_t6';
    columns_t6 = split(aux_t6);
    
    %variáveis auxiliares
    node1_t3 = [];
    node2_t3 = [];
    node3_t3 = [];
    nodesout_t3 = [];
    node1_t6 = [];
    node2_t6 = [];
    node3_t6 = [];
    node4_t6 = [];
    node5_t6 = [];
    node6_t6 = [];
    nodesout_t6 = [];
    
    for i = 1:1:length(columns_t3)
        node1_t3 = [node1_t3;str2double(columns_t3(i,11))];
        node2_t3 = [node2_t3;str2double(columns_t3(i,12))];
        node3_t3 = [node3_t3;str2double(columns_t3(i,13))];

        % se não trocarmos ordem da 2ª e 3ª colunas
        %nodesout_t3 = [nodesout_t3;node1_t3(i),node2_t3(i),node3_t3(i)];
        %se trocarmos ordem da 2ª e 3ª colunas
        nodesout_t3 = [nodesout_t3;node1_t3(i),node3_t3(i), node2_t3(i)];
    end
    
    for i = 1:1:length(columns_t6)
        node1_t6 = [node1_t6;str2double(columns_t6(i,11))];
        node2_t6 = [node2_t6;str2double(columns_t6(i,12))];
        node3_t6 = [node3_t6;str2double(columns_t6(i,13))];
        node4_t6 = [node4_t6;str2double(columns_t6(i,14))];
        node5_t6 = [node5_t6;str2double(columns_t6(i,15))];
        node6_t6 = [node6_t6;str2double(columns_t6(i,16))];
        %nodesout_t6 = [nodesout_t6;node1_t6(i),node2_t6(i),node3_t6(i),node4_t6(i), node5_t6(i), node6_t6(i)];
        %nodesout_t6 = [nodesout_t6;node2_t6(i),node4_t6(i),node1_t6(i),node6_t6(i), node3_t6(i), node5_t6(i)];
        %nodesout_t6 = [nodesout_t6;node1_t6(i),node6_t6(i),node3_t6(i),node5_t6(i), node2_t6(i), node4_t6(i)];
        nodesout_t6 = [nodesout_t6;node1_t6(i),node3_t6(i),node2_t6(i),node6_t6(i), node5_t6(i), node4_t6(i)];
    end

    tri3 = nodesout_t3;
    tri6 = nodesout_t6;

end