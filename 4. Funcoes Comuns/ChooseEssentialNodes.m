function [ii, jj] = ChooseEssentialNodes(X,type, nNodes, data, elemento_T3)
% Função que determina quais o nós nas fronteiras com Temp imposta, 
% retornando vetor(es) com as suas coordenadas. No problema de teste temos
% 2 CF essencial, enquanto no do enunciado temos apenas 1

 cont1 = 1; 
 cont2 = 1;

 % variável que tem em conta imprecisões do programa
 epsilon1_T3 = 10e-3;
 epsilon2_T3 = 14e-3;

 epsilon1_T6 = 2e-3;
 epsilon2_T6 = 12e-3;


 % Problema de teste
 if  type == 1 % há 2 CF essenciais
    b = data.b;
    h = data.h;
    for i=1:nNodes
        if X(i,1) == b && X(i,2) == h % vertice onde as 2 fronteiras coincidem
           ii(cont1) = i;
           cont1 = cont1 +1;
           jj(cont2) = i;
           cont2 = cont2 +1;

        elseif X(i,1) == b % se a fronteira for o lado direito do retangulo
           ii(cont1) = i;
           cont1 = cont1 +1;

        elseif X(i,2) == h % se a fronteira for o a base superior do retangulo
           jj(cont2) = i;
           cont2 = cont2 +1;
        end 
        
     end % fim do ciclo
        

 % Problema do enunciado
 else 
     jj = 0;
     % definição da geometria da peça
     h = 0.6; %metade da altura da peça
     r = 0.25; %raio dos quartos de circunferência
     A = [-0.25, 0.6]; %coordenadas do centro do quarto de circunferência

     % interpretando a fronteira inclinada como uma reta:
     B = [0.5, 0.6]; % ponto que pertence à reta
     m = r/0.75; % declive da reta 
     b =  B(2) - m*B(1); %ordenada na origem
     
     % definição da margem que assegura a correta identificação dos nós
     if elemento_T3 == true % estamos perante o T3
         epsilon1 = epsilon1_T3;
         epsilon2 = epsilon2_T3;
     else
         epsilon1 = epsilon1_T6;
         epsilon2 = epsilon2_T6;
     end

     % identificação dos nós
     for i=1:nNodes
        d = sqrt((X(i,1)-A(1))^2 + (X(i,2)-A(2))^2); %distância do nó ao ponto A
        %ver comentário no fim
        if X(i,2) == h || (r-epsilon1 < d && d < r+ epsilon1) || (m*X(i,1)+b - epsilon2 <= X(i,2) && X(i,2)<=m*X(i,1)+b + epsilon2 && X(i,1) >=-0.26) 
           ii(cont1) = i;
           cont1 = cont1 +1;
        end 
        
     end % fim do ciclo 

 end % fim da estrutura if principal

 % Nota: na linha 48, queremos ver se o nó em questão está no topo da peça,
 % que, por ter uma geometria complicada, requer mais do que uma condição
 % simples

end