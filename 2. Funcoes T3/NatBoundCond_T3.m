function [Ke, fe, boundNodes, boundary] = NatBoundCond_T3(X,Ke, fe,data, edofs)
% Adição dos termos H e p tendo em conta as condições de fronteira. Para CF
% essencial, fazemos depois o método do penalty, não aqui

% Identificação da fronteira e dos nós que fazem parte dela
[boundary, boundNodes, h] = ChooseNatBoundaryT3(X, edofs);

% Aplicação da CF se existir ou n fazer nd se n existir
if ~(boundNodes == [0 0]) % se forem identificados nós na fronteira

    % Definição de p e gama corretos de acordo com fronteira 
    switch boundary
        case 1  % boundary = 1 => fronteira exterior, CF de Robin com h_ext  VER SE TENHO DE POR O MENOS OU NÃO
            gama = data.h_ext*data.T_fluid;
            p = data.h_ext;         
        case 2  % boundary = 2 => fronteira interior, CF de Robin com h_int
            gama = data.h_int*data.T_fluid;
            p = data.h_int;        
    end

    % Tendo conhecimento da fronteira em questão e dos nós que estão nela, 
    % podemos somar He/pe a Ke/fe. Mas 1º há que passar para numeração local
    boundNodesLocal = [0 0];
    for kk=1:2
        boundNodesLocal(kk) = find(edofs==boundNodes(kk));
    end

    He = zeros(3,3);
    He(boundNodesLocal,boundNodesLocal) =   (p*h*(1/6)*[2 1; 1 2]); 
    Ke = Ke + He;

    pe = zeros(3,1);
    pe(boundNodesLocal) =   (gama*h*0.5*[1;1]);
    fe = fe + pe;

else % se não forem identicados nós na fronteira

    % não há alterações em Ke/fe, 

end % fim estrutura if

end %fim função




