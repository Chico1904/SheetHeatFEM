function [boundary,GlobalBoundNodes, LocalBoundNodes] = ChooseNatBoundaryT6(X, edofs)
% Função que retorna a fronteira em questão, os nós que estão na fronteira
% (numeração local) e o comprimento entre os referidos n+os


%inicialização da variável que diz quais os nós na fronteira
LocalBoundNodes = [0 0 0];
GlobalBoundNodes = [0 0 0]; 
boundary = 0;
cont = 0; % variável que nos diz quantos nós do elemento na fronteira já identificámos

% variável que tem em conta imprecisões do programa
epsilon = 5*10^-3;

% variável da geometria da peça: raio do furo 
r = 0.2; 

for i=1:length(edofs)  % no elemento, vamos avaliar nó a nó
    
    % Vejamos se o elemento está na fronteira exterior
     if ( -1.5-epsilon<=X(edofs(i),1) )  &&  ( X(edofs(i),1)<=-1.5+epsilon ) % um dos nós do elemento está na reta x= 0 DEPENDE DO REFERENCIAL
        boundary = 1; % boundary = 1 => a fronteira será a exterior
        if cont == 0 
            GlobalBoundNodes(1) = edofs(i); %se tiver sido o 1º nó identificado
            LocalBoundNodes(1) = i; %se tiver sido o 1º nó identificado
            cont = cont+1;
        elseif cont ==1
            GlobalBoundNodes(2) = edofs(i); %se tiver sido o 2º nó identificado
            LocalBoundNodes(2) = i; %se tiver sido o 2º nó identificado
            cont = cont+1;
        else
            GlobalBoundNodes(3) = edofs(i); %se tiver sido o 3º nó identificado
            LocalBoundNodes(3) = i; %se tiver sido o 3º nó identificado
            break
        end


    elseif ( r^2-epsilon<= X(edofs(i),1)^2+ X(edofs(i),2)^2 ) &&  (X(edofs(i),1)^2+ X(edofs(i),2)^2<= r^2 +epsilon ) % se o elemento está na circunferência
        boundary = 2; % boundary = 2 => a fronteira será a interior
        if cont == 0 
            GlobalBoundNodes(1) = edofs(i); %se tiver sido o 1º nó identificado
            LocalBoundNodes(1) = i; %se tiver sido o 1º nó identificado
            cont = cont+1;
        elseif cont ==1
            GlobalBoundNodes(2) = edofs(i); %se tiver sido o 2º nó identificado
            LocalBoundNodes(2) = i; %se tiver sido o 2º nó identificado
            cont = cont+1;
        else
            GlobalBoundNodes(3) = edofs(i); %se tiver sido o 3º nó identificado 
            LocalBoundNodes(3) = i; %se tiver sido o 3º nó identificado
            break
        end

    else
        %nada  
    end

end

% Falta calcular o comprimento do lado que contém os nós que taõ na
% fronteira (isto é, h)

end