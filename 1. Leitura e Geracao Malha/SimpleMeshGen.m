function [tri3, tri6,X3,X6,b,h,nNosBase,nNosAltura]= SimpleMeshGen
% Geração de uma malha de um elemento retangular 1*2
b = 3;
h = 2;
nNosBase = 9;  % numero de nós na horizontal (considerando uma linha)
nNosAltura = 6;  % numero de nós na vertical (considerando uma linha)

%% Elemento triangular T3
x = 0:b/(nNosBase-1):b;  % vetor com as abcissas dos nós
x_t = x.';
n = length(x);  % número de colunas com nós
delta_y = 0:h/(nNosAltura-1):h;
m = length(delta_y); % número de linhas com nós

X3 = zeros(n*m,2);  % Matriz n*m * 2, cuja 1ª coluna tem as abcissas dos nós e a 2ª tem as ordenadas
for i = 1: m
    j = (i-1)*n +1;
    k = i*n;
    X3(j:k,:)=[x_t zeros(n,1)+delta_y(i)];

    % exemplo "à mão" com 11*6 nós
    % X = [x_t zeros(n,1)+delta_y(1);
    %     x_t zeros(n,1)+delta_y(2);
    %     x_t zeros(n,1)+delta_y(3);
    %     x_t zeros(n,1)+delta_y(4);
    %     x_t zeros(n,1)+delta_y(5);
    %     x_t zeros(n,1)+delta_y(6);]; %Matriz com as coordenadas (x,y) dos nós
end
tri3=delaunay(X3);
%triplot(tri3,X(:,1),X(:,2))

%% Elemento triangular T6

[tri6,x,y] = Convert_TRI3_to_TRI6(tri3,X3(:,1),X3(:,2));
X6(:,1) = x;
X6(:,2) = y;
%triplot(tri3,X(:,1),X(:,2))
end