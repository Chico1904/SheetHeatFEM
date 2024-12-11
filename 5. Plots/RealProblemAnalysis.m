%% plotsRealProblem
% Plots dos resultados para o problema do enunciado

%% Plot da malha com elementos T3
close all
X = X3;
figure(1)
Nelt=size(tri3,1);
for i=1: Nelt
    no1=tri3(i,1);
    no2=tri3(i,2);
    no3=tri3(i,3);   
    edofs=[no1 no2 no3];
    %polyshape (X(edofs,1),X(edofs,2)');hold
    fill (X(edofs,1),X(edofs,2),'c');hold on
    plot(X(edofs,1),X(edofs,2),'b');hold on
end
plot(X(:,1),X(:,2),'ro'); 
axis equal
title('Malha (elemento T3)')

%% Plot da malha com elementos T6
close all
X = X6;
figure
Nels=size(tri6,1);
for i=1: Nels
    no1=tri6(i,1);
    no2=tri6(i,2);
    no3=tri6(i,3);
    no4=tri6(i,4);
    no5=tri6(i,5);
    no6=tri6(i,6);
    %edofs=[no1 no2 no3 no4 no5 no6];
    edofs=[no1 no4 no2 no5 no3 no6];
    fill (X(edofs,1),X(edofs,2),'c');hold on
    plot(X(edofs,1),X(edofs,2),'b');hold on
end
plot(X(:,1),X(:,2),'ro');
axis equal
title('Malha (elemento T6)')

%% -------------- Plots Relevantes dos Resultados --------------------

%% plot Temperatura obtida 2D com cores (T3)
close all
X = X3;
for i = 1:nElem
    edofs = tri3(i,:); % nº dos nos do elemento
    x = X(edofs,1);
    y = X(edofs,2);
    t = u(edofs);
    fill(x,y,t); hold on
    colorbar;
end
axis equal
title('Colormap da Temperatura Obtida por MEF (elemento T3)')

%% plot Temperatura obtida 2D com cores (T6)
close all
X = X6;
for i = 1:nElem
    %edofs = tri6(i,:); % nº dos nos do elemento
    no1=tri6(i,1) ;
    no2=tri6(i,2) ;
    no3=tri6(i,3) ;
    no4=tri6(i,4) ;
    no5=tri6(i,5) ;
    no6=tri6(i,6) ;
    edofs=[no1 no4 no2 no5 no3 no6];
    %edofs=[tri6(i,1) tri6(i,2) tri6(i,3) tri6(i,4) tri6(i,5) tri6(i,6)] ;
    %edofs=[tri6(i,1) tri6(i,4) tri6(i,2) tri6(i,5) tri6(i,3) tri6(i,6)] ;
    x = X(edofs,1);
    y = X(edofs,2);
    t = u(edofs);
    fill(x,y,t); hold on
    colorbar;
end
axis equal
title('Colormap da Temperatura Obtida por MEF (elemento T6)')

%% plot do Fluxo (T3)
close all
X = X3;
figure
plot (X(:,1),X(:,2),'ro'); hold
quiver (Q(:,1),Q(:,2),Q(:,3),Q(:,4),'k');
triplot(tri3, X(:,1),X(:,2));
axis equal
title('Fluxo Obtido (T3)')

%% plot do Fluxo (T6)
close all
X = X6;
figure
Nels=size(tri6,1);
for i=1: Nels
    no1=tri6(i,1);
    no2=tri6(i,2);
    no3=tri6(i,3);
    no4=tri6(i,4);
    no5=tri6(i,5);
    no6=tri6(i,6);
    edofs=[no1 no4 no2 no5 no3 no6];
    %polyshape (x(edofs)',y(edofs)');hold
    %fill (X(edofs,1),X(edofs,2),'c');hold on
    plot(X(edofs,1),X(edofs,2),'b');hold on
end
plot(X(:,1),X(:,2),'ro');
quiver (Q(:,1),Q(:,2),Q(:,3),Q(:,4),'k');
%triplot(tri6, X(:,1),X(:,2));
axis equal
title('Fluxo Obtido (T6)')

%% ------------- Plots de verificação do programa ---------------------
%% Plots dos nós com T imposta
close all
figure(1)
plot(X(ii,1),X(ii,2),'ro');
axis equal

%% Plot dos nós com CF Robin (T3)
close all
figure(1)
kk = [];
for i = 1:length(AllBoundNodes(:,1))
    kk = [kk ;AllBoundNodes(i,[1 2])];
end
plot(X(kk,1),X(kk,2),'ro');
axis equal

%% Plot dos nós com CF Robin (T6)
close all
figure(1)
kk = [];
for i = 1:length(NatNodesInfo.global(:,1))
    kk = [kk ;NatNodesInfo.global(i,[1 2 3])];
end
plot(X(kk,1),X(kk,2),'ro');
axis equal





