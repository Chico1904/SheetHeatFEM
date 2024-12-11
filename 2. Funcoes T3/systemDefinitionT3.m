function [Kg, fg, nNodes,nElem, AllBoundNodes]= systemDefinitionT3(TRI, X, data, type)
% Cálculo da matriz K_g e f_g (ver tarefa 22 e 23)

% Variável para o display da mensagem de progresso da simulação
reverse = '';

% Atribuição das constantes do problema
K = data.k;
fL = data.fL;

% Cálculo de número de nós e de elementos
nNodes = length(X(:,1));
nElem = length(TRI(:,1));

% Inicialização de Kg e fg (globais)
Kg=zeros(nNodes,nNodes);
fg=zeros(nNodes,1);

% Variável que guarda os nós identificados
cont = 1;
n = 15 ; %nº de lados de elementos na fronteira com CF natural
AllBoundNodes = zeros(n,4); % matriz cujas 2 1ªs colunas são os nós, 3ª é a
                            % identificação da fronteira a que pertence e 
                            % 4ª é o indice do elemento ao qual os nós
                            % pertencem

% Cálculo de Ke e fe e posterior assemblagem em Kg e fg
for i=1:nElem
    no1 = TRI(i,1);
    no2 = TRI(i,2);
    no3 = TRI(i,3);
    edofs =[no1 no2 no3];  %   guardar a conectividade deste triangulo

    % determinação de Ke e fe, tendo o 1º de ser multiplicado pela
    % condutividade térmica
    [Ke, fe]= ElementDefinitionT3(edofs, X, fL);   % <- carregamento unitario aqui
    Ke = K*Ke;

    % Aplicação de condições de fronteira naturais, se existirem
    if type == 0  % no caso de ser o problema do enunciado, há CF naturais
        [Ke, fe, boundNodes, boundary] =  NatBoundCond_T3(X,Ke, fe, data, edofs);
        if ~(boundNodes == [0 0]) 
            AllBoundNodes(cont,[1 2]) = boundNodes;
            AllBoundNodes(cont,3) = boundary;
            AllBoundNodes(cont,4) = i;
            cont = cont +1;
        end
    end
        
    %     assemblagem do elemento 
    Kg(edofs,edofs)= Kg(edofs,edofs) + Ke;   
    fg(edofs,1)= fg(edofs,1) + fe; 

    % Update do progresso da simulação
    progress = sprintf('%d', fix(100*i/nElem));
    fprintf([reverse, progress, ' %%']);
    reverse = repmat(sprintf('\b'), 1, length(progress)+2);

end 


end

