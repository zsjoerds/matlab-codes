%% Logistic regression stay behavior. Created 2017/07/19, Z. Sjoerds
% Script for computing a logistic regression to predict stay behavior in the multi-arm bandit task (Daw et al., 2006).

%% tabula rasa
clear all
clc

%% Modifyme

datadir = 'C:\Users\sjoerdsz1\surfdrive\Documents\ERC\BP76_Data\bandit\'; %'C:\Users\sjoerdsz1\surfdrive\Documents\Onderwijs\Bachelorprojecten\Sem2_2017\Data\bandit\
filename = 'trialbytrial_raw.mat'; 
savefilename = 'glmfit_stay.mat'; %this will be the filename of the data matrix for further analyses

%% load the data
cd(datadir);
data=load(filename);
dataset = data.tbt_raw;

%% get info
check_pp_amount = length(dataset)/200;

check_text = ['number of participants = ' {check_pp_amount}];
disp(check_text);

pps = unique(dataset(:,1), 'stable'); %extract pp numbers, but make sure that the order is not changed!


%% perform logistic regression

%individual
for i = 1:length(pps)
    %preparation
    first=1+(200*(i-1));
    last=first+199;
    st = dataset(first+1:last,7);
    Y = st;
    X = [dataset(first+1:last,4)] dataset(first+1:last,6)  dataset(first+1:last,5)]
    N = ones(size(Y));
    
        %perform regression
        [B,DEV,STATS] = glmfit(X, [Y N], 'binomial', 'link', 'logit', 'constant', 'on');
        
        %save output for all pp
        pp_output{i}.B     = B;
        pp_output{i}.DEV   = DEV;
        pp_output{i}.STATS = STATS;
end

%trialwise

    %preparation
    st = dataset(:,7);
    Y = st;
    X = [dataset(:,2) dataset(:,6) dataset(:,5)]; %dataset(:,4)
    N = ones(size(Y));
    
        %perform regression
        [B,DEV,STATS] = glmfit(X, [Y N], 'binomial', 'link', 'logit', 'constant', 'on');
        
        %save output for all pp
        output.B     = B;
        output.DEV   = DEV;
        output.STATS = STATS;
