%#codegen
function Y = algo_IVA_ADMM(X, numIter, rho, alpha, lambda)
%ALGO_IVA_ADMM Algorithm for IVA using basic ADMM
%
%   Y = ALGO_IVA_ADMM(X, numIter, rho, alpha, lambda) performs independent vector 
%   analysis (IVA) on a mixture X in the time-frequency domain using the ADMM algorithm.
%
% Syntax
%   Y = algo_IVA_ADMM(X, numIter, rho, alpha, lambda)
%
% Inputs
%   X                 Mixture in the time-frequency domain, size N-by-T-by-F
%                     (N: channels/sources, T: time frames, F: frequency bins).
%   numIter           Number of iterations.
%   rho               ADMM step size (rho > 0).
%   alpha             ADMM relaxation parameter (0 < alpha < 2).
%   lambda            Regularization weight for the source model term.
%
% Output
%   Y                 Estimated sources in the time-frequency domain, size N-by-T-by-F.

% Copyright 2025 Hiroko Watarai, Kazuki Matsumoto, Kohei Yatabe.
% 
% Permission is hereby granted, free of charge, to any person obtaining a copy of
% this software and associated documentation files (the "Software"), to deal in
% the Software without restriction, including without limitation the rights to
% use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
% of the Software, and to permit persons to whom the Software is furnished to do
% so, subject to the following conditions:
% 
% The above copyright notice and this permission notice shall be included in all
% copies or substantial portions of the Software.
% 
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
% SOFTWARE.

% References:
%   Hiroko Watarai, Kazuki Matsumoto, Kohei Yatabe, "Fast and flexible algorithm
%   for determined blind source separation based on alternating direction 
%   method of multipliers", 47(1), pp. XX–XX (2026).

[N,~,F] = size(X);
E       = eye(N);
W       = complex(repmat(E,[1,1,F]));

z1    = W;
z2    = X;
Y     = X;
u1    = 0*W;
u2    = 0*X;

for i = 1:numIter
    W   = ((z1-u1) + pagemtimes(z2-u2,"none",X,"ctranspose"))/2;
    Y  = pagemtimes(W,X);
    xi1 = alpha*W + (1-alpha)*z1;
    xi2 = alpha*Y + (1-alpha)*z2;
    z1  = prox_logDet(xi1  + u1, 1/rho);
    z2  = prox_IVA(xi2 + u2, lambda/rho);
    u1  = u1 + xi1 - z1;
    u2  = u2 + xi2 - z2;
end
end