clear;
clc;
close all;
%%
data=readtable('39027_PangPangbourne.csv');

%%
BFI=BaseFlowIndex(data.year,data.month,data.day,data.flow);

fprintf('Base Flow Index (BFI): %0.3f\n',BFI)