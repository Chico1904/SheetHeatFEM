function [Kg, fg, nNodes, nElem, NatNodesInfo]= systemDefinitionT6(TRI, X, data, type)
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
n = 7 ; %nº de lados de elementos na fronteira com CF natural

% Inicialização da estrutura NatNodesInfo, que vai guardar informação 
% necessária para  posterior cálculo da potência calorífica 
NatNodesInfo.global = zeros(n,3); %numeração global dos 3 nós do lado do elemento que está na fronteira
NatNodesInfo.local = zeros(n,3); %numeração global dos 3 nós do lado do elemento que está na fronteira
NatNodesInfo.element = zeros(n,1); % índice do elemento
NatNodesInfo.boundary = zeros(n,1); %número (1 ou 2) indicativo da fronteira (exterior ou interior, respetivamente)

% Cálculo de Ke e fe e posterior assemblagem em Kg e fg
for i=1:nElem    
    no1=TRI(i,1) ; 
    no2=TRI(i,2) ; 
    no3=TRI(i,3) ; 
    no4=TRI(i,4) ; 
    no5=TRI(i,5) ; 
    no6=TRI(i,6) ; 
    edofs =[no1 no2 no3 no4 no5 no6]  ;  %   conectividade deste triangulo

    % matriz com as coordenadas dos nós do elemento
    XN(1:6,1)=X(edofs,1) ; 
    XN(1:6,2)=X(edofs,2) ; 

    % determinação de Ke e fe, tendo o 1º de ser multiplicado pela
    % condutividade térmica
    [Ke, fe]=ElementDefinitionT6(XN,fL); 
    Ke = K*Ke;
    
    % Aplicação de condições de fronteira naturais, se existirem
    if type == 0  % no caso de ser o problema do enunciado, há CF naturais
        [Ke, fe, GlobalBoundNodes, boundary, LocalBoundNodes] =  NatBoundCond_T6(X, XN, Ke, fe, data, edofs); 
        if ~(GlobalBoundNodes == [0 0 0]) 
            NatNodesInfo.global(cont,:) = GlobalBoundNodes;
            NatNodesInfo.local(cont,:) = LocalBoundNodes;
            NatNodesInfo.element(cont) = i;
            NatNodesInfo.boundary(cont) = boundary;
            cont = cont +1;
        end
    end

    %     assemblagem
    Kg(edofs,edofs)= Kg(edofs,edofs) + Ke  ;  % 
    fg(edofs,1)= fg(edofs,1) + fe     ;       % 

    % Update do progresso da simulação
    progress = sprintf('%d', fix(100*i/nElem));
    fprintf([reverse, progress, ' %%']);
    reverse = repmat(sprintf('\b'), 1, length(progress)+2);

end %for i


end % fim função

