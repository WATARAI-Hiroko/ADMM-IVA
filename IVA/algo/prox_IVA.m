function x = prox_IVA(x, lambda)
x = max(1-lambda./sqrt(sum(abs(x).^2,3)), 0) .* x;
end