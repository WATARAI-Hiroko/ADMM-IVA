function util_visualizeAndPlay(x,y,fs)

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

tiledlayout(2,2);

range = 4.0;
idx   = 1:fs*range;

mix1  = nexttile; plot((idx-1)/fs, x(idx,1)); title("Mixture 1")  ; grid minor; xlabel("Time [sec]"); ylabel("Amplitude")
mix2  = nexttile; plot((idx-1)/fs, x(idx,2)); title("Mixture 2")  ; grid minor; xlabel("Time [sec]"); ylabel("Amplitude")
sep1  = nexttile; plot((idx-1)/fs, y(idx,1)); title("Separated 1"); grid minor; xlabel("Time [sec]"); ylabel("Amplitude")
sep2  = nexttile; plot((idx-1)/fs, y(idx,2)); title("Separated 2"); grid minor; xlabel("Time [sec]"); ylabel("Amplitude")

tiles = [mix1, mix2, sep1, sep2];
linkaxes(tiles); 
ylim([-0.1 0.1]);

for target = 1:4
    for ii = 1:4
        if ii == target
            tiles(ii).Color = "#FFFFFF";
        else
            tiles(ii).Color = "#BBBBBB";
        end
    end
    soundsc(tiles(target).Children.YData,fs);
    pause(range+0.5)
end
end