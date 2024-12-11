%% Função principal do programa
% Código elaborado por:
%   Tomás Fadista, nº 102488
%   Francisco Miranda, nº 102494
%   Maria Sebastião, nº 102565
%-------------------------------------------------------------------------

% O problema de teste foi retirado do livro da bibliografia "Finite Element
% Method, J.N.Reddy, 2nd Edition", página 346, exemplo 8.4

% IMPORTANTE: o utilizador deverá selecionar as pastas 1-5 -> botão direito
% do rato -> Add to path -> Select Folders and Subfolders para poder correr
% o programa. Após isso, basta escolher o tipo de problema a resolver e o
% elemento a usar e poderá correr o mesmo.

clear ; clc; close all;
disp('Simulação Iniciada, aguarde.')

%% Escolha do problema a resolver e do elemento a usar
type = 0;  % se type = 0 => é o problema do enunciado
           % se type =1 => é o problema de teste
element = 'T6'; %element = 'T3' ou 'T6'

%% Obtenção das coordenadas dos nós e da tabela de conectividades
if type == 1
    [tri3, tri6,X3,X6,b,h,nNosBase,nNosAltura]= SimpleMeshGen;
    data.nNosBase = nNosBase;  % numero de nós na horizontal (considerando uma linha)
    data.nNosAltura = nNosAltura; % numero de nós na vertical (considerando uma linha)
    data.T_0 = 100;
else
    [X3, X6] = getNodes;
    [tri3, tri6] = getConnections;
end

%% Definição da estrutura data, ie, dos parametros do problema
data.k = 2;
data.h_int = 1000;
data.h_ext = 5;
data.T_fluid = 25;
data.T_imp = 100;
data.fL = 0; % carregamento, ie, fontes internas, que no nosso caso são 0

% definição da geometria da peça, no caso de ser o problema teste, o que é
% importante para as CF essenciais
if type == 1
    data.b = b;
    data.h = h;
else
    data.b = 0;
    data.h = 0;
end

%% Definição do sistema do problema de acordo com o elemento

% Verificação do elemento a usar, se for x = true (x=1), é T3
elemento_T3 = strcmp(element,'T3'); 

if elemento_T3 == true
    X = X3;
    [Kg, fg, nNodes,nElem, AllBoundNodes]= systemDefinitionT3(tri3, X, data, type);
else
     X = X6;
    [Kg, fg, nNodes,nElem, NatNodesInfo]= systemDefinitionT6(tri6, X, data, type);
end
data.nElem = nElem;

%% Resolução do problema
[R,u, ii, jj] = SystemResolution(Kg, fg, nNodes, data, type, X, elemento_T3);

%% Cálculo do fluxo e potência calorífica
if elemento_T3 == true
    [Q]=fluxT3(nElem, tri3,X,u, data);
    if  type == 0 % problema do enunciado
        [HP, HP_Int, HP_Ext] = HeatPowerT3(Q, AllBoundNodes, X);
    end
else
    csi = 1/3;
    eta = 1/3;
    [Q]=fluxT6(nElem, tri6,X,u, data, csi, eta);
    if  type == 0 % problema do enunciado
        [HP, HP_Int, HP_Ext] = HeatPowerT6(NatNodesInfo, X, u, data);
    end
end

%% Formação da peça inteira tendo em conta a simetria
%if elemento_T3 == true
%     [X, tri3, u, nElem, nNodes, Q] = assembleSymmetricPartsT3(X, tri3, nNodes,nElem, Q, u);
% else
%     [X, tri3, u, nElem, nNodes, Q] = assembleSymmetricPartsT6(X, tri6, nNodes,nElem, Q, u);
%end

% Notar que a função para o T6 não foi feita porque concordámos com o 
% professor que era denecessária mas seria semelhante à do T3. Para ver a
% peça completa com a malha T3, tirar o comentário das linhas 86, 87 e 90
% e por em comentário a linha 48 do script RealProblemAnalysis

%% Resultados e plots relevantes
% ver pasta 5.Plots -> script RealProblemAnalysis p/ o problema do enunciado
%                             TestProblemAnalysis p/ o problema de teste
%% Guardar Resultados
save("Temperature.txt", "u", "-ascii");
save("Centroids&Flux.txt", "Q", "-ascii");
save("Reactions.txt", "X", "R", "-ascii");




