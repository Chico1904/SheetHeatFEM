%% plotsTestProblem
% Tratamento dos resultados para o problema de teste: comparação com 
% solução analítica, plots, etc. 

%% Plot da malha com elementos T3
figure(1)
Nelt=size(tri3,1);
for i=1: nElem
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
    fill (X(edofs,1),X(edofs,2),'c');hold on
    plot(X(edofs,1),X(edofs,2),'b');hold on
end
plot(X(:,1),X(:,2),'ro');

%% Definição da solução analítica
b = data.b;
h = data.h;
nNosBase = data.nNosBase;
passo = b/(nNosBase-1);

% cálculo do vetor das temperaturas analiticamente
T_analitico =zeros(length(u),1);
for kk=1:length(X(:,1))
    T_analitico(kk) = data.T_0*cosh(pi*X(kk,2)/(2*b))*cos(pi*X(kk,1)/(2*b))/cosh(pi/3);
end

%% -------------- Plots Relevantes dos Resultados --------------------

%% plot Temperatura obtida 2D com cores (T3)
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
for i = 1:nElem
    %edofs = tri6(i,:); % nº dos nos do elemento
    no1=tri6(i,1) ;
    no2=tri6(i,2) ;
    no3=tri6(i,3) ;
    no4=tri6(i,4) ;
    no5=tri6(i,5) ;
    no6=tri6(i,6) ;
    edofs=[tri6(i,1) tri6(i,4) tri6(i,2) tri6(i,5) tri6(i,3) tri6(i,6)] ;
    x = X(edofs,1);
    y = X(edofs,2);
    t = u(edofs);
    fill(x,y,t); hold on
    colorbar;
end
title('Colormap da Temperatura Obtida por MEF (elemento T6)')

%% plot Temperatura teórica 2D com cores (elemento T3)
close all
for i = 1:data.nElem
    edofs = tri3(i,:); % nº dos nos do elemento
    x = X(edofs,1);
    y = X(edofs,2);
    t = T_analitico(edofs);
    fill(x,y,t); hold on
    colorbar;
end
title('Colormap da Temperatura calculada analiticamente (T3)')

%% plot Temperatura teórica 2D com cores (elemento T6)
close all
for i = 1:data.nElem
    %edofs = tri6(i,:); % nº dos nos do elemento
    no1=tri6(i,1) ;
    no2=tri6(i,2) ;
    no3=tri6(i,3) ;
    no4=tri6(i,4) ;
    no5=tri6(i,5) ;
    no6=tri6(i,6) ;
    edofs=[tri6(i,1) tri6(i,4) tri6(i,2) tri6(i,5) tri6(i,3) tri6(i,6)] ;
    x = X(edofs,1);
    y = X(edofs,2);
    t = T_analitico(edofs);
    fill(x,y,t); hold on
    colorbar;
end
title('Colormap da Temperatura calculada analiticamente (T6)')
%% plot Temperatura obtida 3D com cores (T3)
figure
trisurf(tri3, X(:,1), X(:,2), u); grid on
title('Temperatura Obtida (elemento T3)')

%% plot Temperatura obtida 3D com cores (T6)
figure
trisurf(tri6, X(:,1), X(:,2), u); grid on
title('Temperatura Obtida (elemento T6)')

%% plot Temperatura teórica 3D com cores
figure
trisurf(tri3, X(:,1), X(:,2), T_analitico); grid on
title('Temperatura Teórica')

%% plot do Fluxo (T3)
figure
plot (X(:,1),X(:,2),'ro'); hold
quiver (Q(:,1),Q(:,2),Q(:,3),Q(:,4),'k');
triplot(tri3, X(:,1),X(:,2));
axis equal
title('Fluxo Obtido (T3)')

%% plot do Fluxo (T6)
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
title('Fluxo Obtido (T6)')

%% Plot do fluxo teórico (T3)
x = Q(:,1);
y = Q(:,2);
k = data.k;
T_0 = data.T_0;
b = data.b;
Q_xteor = (k*T_0*pi/(2*b*cosh(pi/3))).*cosh(pi*y*0.5/b).*sin(pi*0.5*x/b);
Q_yteor = -(k*T_0*pi/(2*b*cosh(pi/3))).*cos(pi*x*0.5/b).*sinh(pi*0.5*y/b);

figure
plot (X(:,1),X(:,2),'ro'); hold
quiver (Q(:,1),Q(:,2),Q_xteor,Q_yteor,'k');
triplot(tri3, X(:,1),X(:,2));
title('Fluxo Analítico (T3)')

%% Plot do fluxo teórico (T6)
x = Q(:,1);
y = Q(:,2);
k = data.k;
T_0 = data.T_0;
b = data.b;
Q_xteor = (k*T_0*pi/(2*b*cosh(pi/3))).*cosh(pi*y*0.5/b).*sin(pi*0.5*x/b);
Q_yteor = -(k*T_0*pi/(2*b*cosh(pi/3))).*cos(pi*x*0.5/b).*sinh(pi*0.5*y/b);

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
quiver (Q(:,1),Q(:,2),Q_xteor,Q_yteor,'k');
%triplot(tri6, X(:,1),X(:,2))
title('Fluxo Analítico (T6)')

%% Cálculo erro Tempertura 
erroTemp = T_analitico - u;
maxErroTemp = max(abs(erroTemp));

%% Cálculo erro Fluxo
erroFlux_x = Q_xteor - Q(:,3);
erroFlux_y = Q_yteor - Q(:,4);
erroGrad = sqrt(erroFlux_x.^2 + erroFlux_y.^2);
maxErroGrad = max(abs(erroGrad));

%% ------------- Plots de verificação do programa ---------------------
%% Plots dos nós com T imposta
figure(1)
plot(X(ii,1),X(ii,2),'ro');
axis equal




