%#codegen
function Y = algo_IVA_AuxIP(X, numIter)
%ALGO_IVA_AUXIP Algorithm for IVA using Auxiliary-function-based Iterative Projection (AuxIP)
%
%   Y = ALGO_IVA_AUXIP(X, numIter) performs independent vector 
%   analysis (IVA) on a mixture X in the time-frequency domain using the AuxIP algorithm.
%
% Syntax
%   Y = algo_IVA_AuxIP(X, numIter)
%
% Inputs
%   X                 Mixture in the time-frequency domain, size N-by-T-by-F
%                     (N: channels/sources, T: time frames, F: frequency bins).
%   numIter           Number of iterations.
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
%   N. Ono, “Stable and fast update rules for independent vector analysis 
%   based on auxiliary function technique,” Proc. IEEE Workshop Appl. 
%   Signal Process. Audio Acoust. (WASPAA), pp. 189–192 (2011).

[N,~,F] = size(X);
Y       = X;
E       = complex(eye(N));
W       = repmat(E,[1,1,F]);

for i = 1:numIter
    R = sqrt(sum(max(abs(Y).^2, eps), 3));

    for mm = 1:N
        U         = pagemtimes(X,"none",X./R(mm,:,:),"ctranspose");
        W(mm,:,:) = pagectranspose(pagemldivide(pagemtimes(W, U),E(:,mm)));
    end

    Y = pagemtimes(W,X);
end

end