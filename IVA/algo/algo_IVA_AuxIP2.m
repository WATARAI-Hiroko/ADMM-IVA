%#codegen
function Y = algo_IVA_AuxIP2(X, numIter)
%ALGO_IVA_AUXIP2 Algorithm for IVA using AuxIP2 with pair-wise updates
%
%   Y = ALGO_IVA_AUXIP2(X, numIter) performs independent vector analysis (IVA)
%   on a mixture X in the time-frequency domain using the AuxIP2 algorithm.
%
% Syntax
%   Y = algo_IVA_AuxIP2(X, numIter)
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
%   N. Ono, “Fast stereo independent vector analysis and its implementation 
%   on mobile phone,” Proc. Int. Workshop Acoust. Signal Enhanc. (IWAENC), 
%   pp. 1–4 (2012).
% 
%   T. Nakashima, R. Scheibler, Y. Wakabayashi and N. Ono, “Faster independent 
%   low-rank matrix analysis with pairwise updates of demixing vectors,” Proc. 
%   Eur. Signal Process. Conf. (EUSIPCO), pp. 301–305 (2021).

[N,~,F] = size(X);
Y       = X;
E       = complex(eye(N));
W       = repmat(E,[1,1,F]);

for i = 1:numIter

    for nn = 1:N
        R = sqrt(sum(max(abs(Y).^2, eps), 3));

        m            = nn;
        n            = mod(nn  ,N)+1;

        Um           = pagemtimes(X,"none",X./R(m,:,:),"ctranspose");
        Un           = pagemtimes(X,"none",X./R(n,:,:),"ctranspose");

        Pm           = pagemldivide(pagemtimes(W, Um),E(:,[m n]));
        Pn           = pagemldivide(pagemtimes(W, Un),E(:,[m n]));

        Vm           = pagemtimes(Pm,"ctranspose",pagemtimes(Um,Pm),"none");
        Vn           = pagemtimes(Pn,"ctranspose",pagemtimes(Un,Pn),"none");

        [V,l]        = mypageeig(pagemldivide(Vn,Vm));

        cmp          = l(1,:,:) > l(2,:,:);
        vm           = V(:,1,:);
        vn           = V(:,2,:);
        vm(:,:,~cmp) = V(:,2,~cmp);
        vn(:,:,~cmp) = V(:,1,~cmp);
        wm           = pagemtimes(Pm,vm);
        wn           = pagemtimes(Pn,vn);

        wm           = wm./sqrt(pagemtimes(wm,"ctranspose",pagemtimes(Um,wm),"none"));
        wn           = wn./sqrt(pagemtimes(wn,"ctranspose",pagemtimes(Un,wn),"none"));

        W(m,:,:) = pagectranspose(wm);
        W(n,:,:) = pagectranspose(wn);

        Y = pagemtimes(W,X);
    end
end

end

function [V,l] = mypageeig(W)

V = W;
l = W(:,1,:);

for f = 1:size(W,3)
    [V(:,:,f), l(:,:,f)] = eig(W(:,:,f),"vector");
end

end