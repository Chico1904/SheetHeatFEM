function [Q]=fluxT3(nElem, TRI,X,u, data)
% função que calcula o fluxo e o centróide de cada elemento

% Matriz que guarda o centróide e o fluxo: cada linha corresponde às 
% componentes x/y de cada um, respetivamente -> (x,y,qx,qy)
Q = zeros(nElem, 4);
k = data.k;

for i=1:nElem
    no1 = TRI(i,1);
    no2 = TRI(i,2);
    no3 = TRI(i,3);
    %   copia coordenadas
    x1=X(no1,1);
    x2=X(no2,1);
    x3=X(no3,1);
    y1=X(no1,2);
    y2=X(no2,2);
    y3=X(no3,2);
    %   calcula centroide
    Q(i,1) = (x1+x2+x3)/3.;
    Q(i,2) = (y1+y2+y3)/3.;
    %
    %   calcula vector gradiente no elemento   
    Ae2 = (x2 -x1)*(y3 -y1) -(y2 -y1)*(x3 -x1);
    %   derivadas parciais das funcoes de forma
    d1dx = (y2-y3)/Ae2;
    d1dy = (x3-x2)/Ae2;
    d2dx = (y3-y1)/Ae2;
    d2dy = (x1-x3)/Ae2;
    d3dx = (y1-y2)/Ae2;
    d3dy = (x2-x1)/Ae2;
    %   interpolacao e derivadas
    Q(i,3) = -k*(d1dx*u(no1)+d2dx*u(no2)+d3dx*u(no3));
    Q(i,4) = -k*(d1dy*u(no1)+d2dy*u(no2)+d3dy*u(no3));
    %   sinal negativo para o fluxo
end
end
