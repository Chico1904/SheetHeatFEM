function [Ke, fe]=ElementDefinitionT3(edofs, X,el)   
% Cálculo das matrizes Ke e fe (referentes a um único elemento)

% Definição das coordenadas de cada nó
x1= X(edofs(1),1);
y1= X(edofs(1),2);
x2= X(edofs(2),1);
y2= X(edofs(2),2);
x3= X(edofs(3),1);
y3= X(edofs(3),2);

%	el - element load - carga uniforme - variavel de entrada
%--------------------------------------------------------------------------
%       calcula o dobro da area sinalizada do triangulo
Ae2 = (x2 -x1)*(y3 -y1) -(y2 -y1)*(x3 -x1);
%       calculo da area do triangulo
Ae= Ae2/2;	%	area sinalizada
%       derivadas parciais das funcoes de forma
d1dx = (y2-y3)/Ae2;
d1dy = (x3-x2)/Ae2;
d2dx = (y3-y1)/Ae2;
d2dy = (x1-x3)/Ae2;
d3dx = (y1-y2)/Ae2;
d3dy = (x2-x1)/Ae2;
%--------------------------------------------------------------------------
%       coeficientes do triangulo superior da matriz
Ke(1,1) = (d1dx*d1dx + d1dy*d1dy)*Ae;
Ke(1,2) = (d1dx*d2dx + d1dy*d2dy)*Ae;
Ke(1,3) = (d1dx*d3dx + d1dy*d3dy)*Ae;
Ke(2,2) = (d2dx*d2dx + d2dy*d2dy)*Ae;
Ke(2,3) = (d2dx*d3dx + d2dy*d3dy)*Ae;
Ke(3,3) = (d3dx*d3dx + d3dy*d3dy)*Ae;
%   	usar a simetria para obter o triangulo inferior da matriz
Ke(2,1)= Ke(1,2);
Ke(3,1)= Ke(1,3);
Ke(3,2)= Ke(2,3);
%
%--------------------------------------------------------------------------
%             acrescentar o vector de forcas a seguir
%--------------------------------------------------------------------------
%   	vector de forcas:   declarar como vector coluna
fe(1:3,1)= el*Ae/3;     %   para uma carga uniforme de intensidade el
%
end   