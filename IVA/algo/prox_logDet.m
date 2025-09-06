function W = prox_logDet(W, mu)
for f = 1:size(W,3)
    [U,S,V] = svd(W(:,:,f),"vector");
    S = (S + sqrt(S.^2 + 4*mu))/2;
    W(:,:,f) = (U.*S.')*V';
end
end