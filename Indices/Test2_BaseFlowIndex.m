clear;
clc;
close all;
%%
data=readtable('reach13659_output.csv');

%%
[BFI, yearList]=BaseFlowIndex(data.year,data.month,data.day,data.discharge);

fprintf('Base Flow Index (BFI)\n');
fprintf('%d --> %0.3f\n',[yearList BFI]');