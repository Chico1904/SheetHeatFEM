function [X, tri3, u, nElem, nNodes, Q] = assembleSymmetricPartsT3(X, tri3, nNodes,nElem, Q, u)
% formação da peça toda tendo em conta a sua simetria

    %características da malha 
    nElem = 2*nElem;
    X_sim = [X(:,1) -X(:,2)];
    X = [X; X_sim];
    tri3_sim = tri3 + nNodes;
    tri3 = [tri3; tri3_sim];
    nNodes = 2* nNodes;

    % temperatura e fluxos
    u = [u;u];
    Q = [Q;
        Q(:,1), -Q(:,2), Q(:,3), -Q(:,4)];

end