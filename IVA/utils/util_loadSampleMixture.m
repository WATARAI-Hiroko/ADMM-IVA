function [signal1, signal2, fs] = util_loadSampleMixture

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

folder = "./dev1";
name1  = "dev1_female4_liverec_130ms_5cm_sim_1.wav";
name2  = "dev1_female4_liverec_130ms_5cm_sim_4.wav";

file1  = fullfile(folder, name1);
file2  = fullfile(folder, name2);

if ~exist(file1, "file")
    answer = questdlg( ...
        sprintf("Do you want to download dev1.zip (91 MB) " + ...
        "from SiSEC dataset?"), ...
        "Downloading dataset", ...
        "Yes", "No", "No");

    if answer=="Yes"
        fprintf("Downloading dev1 (this might take several minutes)... ")
        unzip("http://www.irisa.fr/metiss/SiSEC10/underdetermined/dev1.zip", folder)
        fprintf("Done.\n")
    end
end

[signal1,~ ] = audioread(file1);
[signal2,fs] = audioread(file2);

end