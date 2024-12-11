function [Q]=fluxT6(nElem, TRI,X,u, data, csi, eta)
% função que calcula o fluxo e o centróide de cada elemento

% Matriz que guarda o centróide e o fluxo: cada linha corresponde às 
% componentes x/y de cada um, respetivamente -> (x,y,qx,qy)
Q = zeros(nElem, 4);
k = data.k;

%-----------------------------------------------------
% calcular (gradiente) fluxo nos centroides
%-----------------------------------------------------
% figure
% plot(x,y,'ro');hold on

for i=1:nElem
    no1=TRI(i,1); no2=TRI(i,2); no3=TRI(i,3);
    no4=TRI(i,4); no5=TRI(i,5); no6=TRI(i,6);
    edofs =[no1 no2 no3 no4 no5 no6]; % conectividade deste triangulo
    XN(1:6,1)=X(edofs,1);
    XN(1:6,2)=X(edofs,2);
    % para cada ponto calcular
    %----------------------------------------------------------------
    [B, psi, ~]=Shape_N_Der6 (XN,csi,eta);
    %----------------------------------------------------------------
    %uint = psi'*u(edofs); PERGUNTAR PARA QUE SERVE
    xpint = XN'*psi;
    gradu = B'*u(edofs);
    fluxu = -k*gradu;

    % Guardar na matriz Q
    Q(i,[1 2]) = xpint;
    Q(i,[3 4]) = fluxu;
   
    % plot(xpint(1),xpint(2),'bx');hold on
    % quiver(xpint(1),xpint(2),fluxu(1),fluxu(2));hold on
end

end
