function [HP, HP_Int, HP_Ext] = HeatPowerT6(NatNodesInfo, X, u, data)

% inicialização
NodesExt_global = [];
NodesExt_local = [];
NodesExt_element = [];
NodesInt_global = [];
NodesInt_local = [];
NodesInt_element = [];

e = 1; % espessura da placa = unidade

for i = 1:length(NatNodesInfo.element)
    if NatNodesInfo.boundary(i) == 1 % boundary = 1 -> fronteira exterior (vertical)
        NodesExt_global  = [NodesExt_global;  NatNodesInfo.global(i,:)];
        NodesExt_local   = [NodesExt_local;   NatNodesInfo.local(i,:)];
        NodesExt_element = [NodesExt_element; NatNodesInfo.element(i)];
    else % boundary =2 -> fronteira interior (circular)
        NodesInt_global  = [NodesInt_global;  NatNodesInfo.global(i,:)];
        NodesInt_local  = [NodesInt_local;   NatNodesInfo.local(i,:)];
        NodesInt_element = [NodesInt_element; NatNodesInfo.element(i)];
    end

end 

% No final deste ciclo tenho os nós da fronteira ext. e int. (colunas 1 e 
% 2 da matriz) separados e o índice do elemento ao qual pertencem (3ª e 
% última coluna da matriz).

%% Potência Calorífica Exterior
HP_Ext = 0;
for i = 1:length(NodesExt_element)    

    h_ext = data.h_ext;
    T_inf = data.T_fluid;

    no1 = NodesExt_global(i,1); %nó1
    no2 = NodesExt_global(i,2); %nó2
    no3 = NodesExt_global(i,3); %nó3

    x1 = X(no1,:); %coordenadas do nó 1 
    x2 = X(no2,:); %coordenadas do nó 2
    x3 = X(no3,:); %coordenadas do nó 3

    [l] = maxSide(x1, x2, x3);

    % sendo T aproximada como uma função quadrática num dado elemento,
    % podemos integrar exatamente esta aproximação
    aux1 = h_ext*ExtIntegrationTemperature_T6(X, NodesExt_global, i, u);
    aux2 = h_ext*T_inf*l*e;
    d_HP_Ext = (e*aux1-aux2);
    HP_Ext = HP_Ext + d_HP_Ext;
end

%% Potência Calorífica Interior
HP_Int = 0;
for i = 1:length(NodesInt_element)    
% 
%     sendo T aproximada como uma função quadrática num dado elemento,
%     % podemos integrar exatamente esta aproximação
    h_int = data.h_int;
    T_inf = data.T_fluid;
    r = 0.2;

    [aux, Max, Min] = IntIntegrationTemperature_T6(X, NodesInt_global, i, u);
   
    aux1 = h_int*aux;
    arc = r*abs(Max-Min);
    aux2 = h_int*T_inf*arc*e;
    d_HP_Int = (e*aux1-aux2);
    HP_Int = HP_Int + d_HP_Int;
end

%% Soma das duas
HP = HP_Int + HP_Ext;

end

function  [d_HP_Ext] = ExtIntegrationTemperature_T6(X, NodesExt_global, i, u)
    no1 = NodesExt_global(i,1); %nó1
    no2 = NodesExt_global(i,2); %nó2
    no3 = NodesExt_global(i,3); %nó3
    x1 = X(no1,:); %coordenadas do nó 1 
    x2 = X(no2,:); %coordenadas do nó 2
    x3 = X(no3,:); %coordenadas do nó 3
    y = [x1(2), x2(2), x3(2)];

    M = [y(1)^2 y(1) 1;
         y(2)^2 y(2) 1;
         y(3)^2 y(3) 1;];
    u = [u(no1); u(no2); u(no3)];
    coef = M\ u; %coef = [a b c], onde T(y) = ay^2+by+c;
    a = coef(1);
    b = coef(2);
    c = coef(3);

    Max = max(y);
    Min = min(y);

    integralTemp = @(x) a*x^3/3 + b*x^2/2 + c*x;
    d_HP_Ext = integralTemp(Max)-integralTemp(Min);


end

function [d_HP_Int, Max, Min] = IntIntegrationTemperature_T6(X, NodesInt_global, i, u)
    no1 = NodesInt_global(i,1); %nó1
    no2 = NodesInt_global(i,2); %nó2
    no3 = NodesInt_global(i,3); %nó3

    x1 = X(no1,:); %coordenadas do nó 1 
    x2 = X(no2,:); %coordenadas do nó 2
    x3 = X(no3,:); %coordenadas do nó 3

    x = [x1(1); x2(1);x3(1)];
    r = 0.2;

    for i = 1:3
        ang = acos(x(i)/r);
        if ang<0
            ang = ang + pi;
        end
        theta(i) = ang;
    end

    M = [theta(1)^2 theta(1) 1;
         theta(2)^2 theta(2) 1;
         theta(3)^2 theta(3) 1;];
    u = [u(no1); u(no2); u(no3)];
    coef = M\ u; %coef = [a b c], onde T(y) = ay^2+by+c;
    a = coef(1);
    b = coef(2);
    c = coef(3);

    Max = max(theta);
    Min = min(theta);

    integralTemp = @(x) a*x^3/3 + b*x^2/2 + c*x;
    d_HP_Int = r*(integralTemp(Max)-integralTemp(Min));

end

function [max_h] = maxSide(x1, x2, x3)
 
     % cálculo do comprimento do lado
     max_h = 0;
     h = [0 0 0];
     h(1) = norm(x3-x2);
     h(2) = norm(x3-x1);
     h(3) = norm(x2-x1);
 
     for i= 1:3
         if h(i) > max_h
             max_h = h(i);
         end
     end
 
end
