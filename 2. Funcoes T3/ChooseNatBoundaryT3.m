function [boundary,boundNodes, h] = ChooseNatBoundaryT3(X, edofs)
% Função que retorna a fronteira em questão, os nós que estão na fronteira
% (numeração local) e o comprimento entre os referidos n+os

%inicialização da variável que diz quais os nós na fronteira
boundNodes = [0 0]; 
h = 0;
boundary = 0; % boundary = 0 -> n pertence a front. c/ CF natural
              % boundary = 1 -> n pertence a front. ext
              % boundary = 2 -> n pertence a front. int

% variável que tem em conta imprecisões do programa
epsilon = 10^-3;

% variável da geometria da peça: raio do furo 
r = 0.2; 

for i=edofs  % no elemento, vamos avaliar nó a nó

    % Vejamos se o elemento está na fronteira exterior
    if (-1.5-epsilon<=X(i,1))  &&  (X(i,1)<=-1.5+epsilon) % se o elemento está na fronteira da esquerda
        boundary = 1; % boundary = 1 => a fronteira será a exterior
        if boundNodes == [0 0]
            boundNodes(1) = i; %se tiver sido o 1º nó identificado
        else
            boundNodes(2) = i; %se tiver sido o 2º nó identificado
            i1 =  boundNodes(1);
            i2 =  boundNodes(2);
            h = norm(X(i1,:)-X(i2,:));
            break
        end

    % Vejamos se o elemento está na fronteira interior
    elseif (r^2-epsilon<=X(i,1)^2+X(i,2)^2) &&  (X(i,1)^2+X(i,2)^2<= r^2 +epsilon) % se o elemento está na circunferência
        boundary = 2; % boundary = 2 => a fronteira será a interior
        if boundNodes == [0 0]
            boundNodes(1) = i; %se tiver sido o 1º nó identificado
        else
            boundNodes(2) = i; %se tiver sido o 2º nó identificado
            i1 =  boundNodes(1);
            i2 =  boundNodes(2);
            h = norm(X(i1,:)-X(i2,:));
            break
        end

    else
        %nada
    end

end

end