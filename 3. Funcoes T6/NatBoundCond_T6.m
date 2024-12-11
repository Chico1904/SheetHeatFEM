function [Ke, fe, GlobalBoundNodes, boundary, LocalBoundNodes] = NatBoundCond_T6(X, XN, Ke, fe, data, edofs)
% Adição dos termos H e p tendo em conta as condições de fronteira. Para CF
% essencial, fazemos depois o método do penalty, não aqui

% Identificação da fronteira e dos nós que fazem parte dela
[boundary, GlobalBoundNodes, LocalBoundNodes] = ChooseNatBoundaryT6(X, edofs);
k = data.k;
% Aplicação da CF se existir ou n fazer nd se n existir
if any(GlobalBoundNodes == 0) == false % se um lado do elemento T6 tiver na fronteira, então tem de ter 3 nós lá e o vetor boundNodes n pode ter 0
    % Definição de p e gama corretos de acordo com fronteira
    switch boundary
        case 1  % boundary = 1 => fronteira exterior, CF de Robin com h_ext  VER SE TENHO DE POR O MENOS OU NÃO
            gama = data.h_ext*data.T_fluid;
            p = data.h_ext;         
        case 2  % boundary = 1 => fronteira interior, CF de Robin com h_int
            gama = data.h_int*data.T_fluid;
            p = data.h_int;        
    end

    % Tendo conhecimento dos nós que estão na fronteira, calculamos He e pe
    He = zeros(6,6); % inicialização
    Pe = zeros(6,1); % inicialização

    % ATENÇÃO SÓ FAZER DE 1 FORMA

    % fazendo por integração de Gauss_Legendre
     %[he, pe]=Robin_quadr(GlobalBoundNodes,X,p,gama);
     %he = he*k; % multiplicação pelo k (ver formulação fraca)
     %pe = pe*k; % multiplicação pelo k (ver formulação fraca)
     %He(LocalBoundNodes,LocalBoundNodes) = he;
     %Pe(LocalBoundNodes) = pe;

    %Fazendo com as matrizes do livro
    [He, Pe] = Robin_exact(LocalBoundNodes, p, gama, He, Pe, GlobalBoundNodes, X);


    % somas destes termos à matriz de rigidez e ao vetor de forças para
    % incorporar com sucesso CF de Robin
    Ke = Ke + He;
    fe = fe + Pe;

else % se não forem identicados nós na fronteira

    % não há alterações em Ke/fe, 

end % fim estrutura if

end %fim função


function [He, Pe] = Robin_exact(LocalBoundNodes, p, gama, He, Pe, GlobalBoundNodes, X)
% função que aplica as expressões de He/pe apresentadas no livro da bibliografia para
% o elemento T6 mas com a numeração adotada na UC

    % coordendas dos nós do lado do elemento e comprimento do mesmo
    x1 = X(GlobalBoundNodes(1),:);
    x2 = X(GlobalBoundNodes(2),:);
    x3 = X(GlobalBoundNodes(3),:);
    
    d(1) = norm(x3-x2);
    d(2) = norm(x3-x1);
    d(3) = norm(x1-x2);
    
    l = max(d);

    % expressões apresentadas no livro da bibliografia
    he = (1/30)*l*p*[4, 2, -1; 
                    2, 16, 2; 
                    -1 2 4];

    pe = (1/6)*l*gama*[1;4;1];

     % alteração 
     aux = LocalBoundNodes(3);
     LocalBoundNodes(3) = LocalBoundNodes(2);
     LocalBoundNodes(2) = aux;

    He(LocalBoundNodes, LocalBoundNodes) = he;
    Pe(LocalBoundNodes) = pe;
end

