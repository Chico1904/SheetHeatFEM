function [R,u,ii, jj] = SystemResolution(Kg, fg, nNodes, data, type, X, elemento_T3)
% Determinação do vetor u (Temperatura) e R, isto é, aplicação do método do 
% penalty/boom para incorporar CF essenciais

% Definição do valor do boom e da matriz/vetor temporarios p/ o boom
boom = 1.0e+10;
Kr = Kg;
fr = fg;
b = data.b;

% Identificação dos nós das fronteiras com CF essenciais
[ii, jj] = ChooseEssentialNodes(X,type, nNodes, data, elemento_T3);

% Distinção entre problema de teste e do enunciado. Aplicação do boom aos 
% nós do vetor jj (CF essencial do problema de teste)
if type == 1 % problema de teste;
    % aproveita-se e aplica-se o boom para uma das CF do problema de teste
    for i=1:length(jj)
        node = jj(i); % identificação do nó para ir ao sítio certo em Kg
        Kr (node,node) = boom;
        T_0 = data.T_0;
        T_imp = T_0 * cos(pi*X(node,1)/(2*b));
        fr(node) = boom *T_imp;	% o valor pretendido aqui e zero
    end
    T_imp = 0; 
else
    T_imp = data.T_imp;
end

% Aplicação do boom aos nós do vetor ii, que existe nos 2 casos
for i=1:length(ii)
    node = ii(i); % identificação do nó para ir ao sítio certo em Kg
    Kr (node,node) = boom;
    fr(node) = boom *T_imp;	
end

% solucao do sistema modificado por backslash
u=Kr\fr;

% Reacoes nos apoios com o sistema apos assemblagem + cond. naturais
R = Kg*u-fg;

end
