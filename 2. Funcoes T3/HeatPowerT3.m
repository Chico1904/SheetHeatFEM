function [HP, HP_Int, HP_Ext] = HeatPowerT3(Q, AllBoundNodes, X)
% cálculo da potência calorífica na malha com elementos T3

NatNodesExt = [];
NatNodesInt = [];
e = 1; % espessura da placa = unidade

for i = 1:length(AllBoundNodes(:,1))
    if AllBoundNodes(i,3) == 1 % boundary =1 -> fronteira exterior (vertical)
        NatNodesExt = [NatNodesExt ; AllBoundNodes(i,[1 2 4]) ];
    else % boundary =2 -> fronteira interior (circular)
        NatNodesInt = [NatNodesInt ; AllBoundNodes(i,[1 2 4])];
    end

end 

% No final deste ciclo tenho os nós da fronteira ext. e int. (colunas 1 e 
% 2 da matriz) separados e o índice do elemento ao qual pertencem (3ª e 
% última coluna da matriz).

% Para calcular o fluxo há que integrar o seu produto interno com a normal
% exterior. Notar que para o T3, fluxo é constante num dado elemento

%% Cálculo da potência calorífica na fronteira exterior
HP_Ext = 0;
for i = 1:length(NatNodesExt(:, 1))

    no1 = NatNodesExt(i,1); %nó1
    no2 = NatNodesExt(i,2); %nó2
    x1 = X(no1,:); %coordenadas do nó 1 (só serve para a norma)
    x2 = X(no2,:); %coordenadas do nó 2

    q = Q(NatNodesExt(i,3), [3 4]); % q = [qx, qy]
    n = [-1, 0];

    d_HP_Ext = e*norm(x2-x1)*dot(q,n);
    HP_Ext = HP_Ext + d_HP_Ext;
end


%% Cálculo da potência calorífica na fronteira interior
HP_Int = 0;

for i = 1:length(NatNodesInt(:, 1))

    no1 = NatNodesInt(i,1); %nó1
    no2 = NatNodesInt(i,2); %nó2
    x1 = X(no1,:); %coordenadas do nó 1
    x2 = X(no2,:); %coordenadas do nó 2
    
    % para não fazer uma integração de produto interno em coordenadas
    % polares, aproximamos e usamos o ponto médio para definir a normal na
    % fronteira de 1 elemento (ponto M = vec(OM))
    q = Q(NatNodesInt(i,3), [3 4]); % q = [qx, qy]
    M = [(x1(1) + x2(1))/2, (x1(2) + x2(2))/2];
    n = -[M(1), M(2)]/norm(M);
    d_HP_Int = e*norm(x2-x1)*dot(q,n);  


    % ou fazendo de uma forma + precisa
    HP_Int = HP_Int + d_HP_Int;
end
HP = HP_Int + HP_Ext;

end % fim função

