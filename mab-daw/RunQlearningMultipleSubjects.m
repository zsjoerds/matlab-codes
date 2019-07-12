%% script by Marieke Jepma; adjusted by Z. Sjoerds, July 2017


%% tabula rasa
clear all
clc
close all

%% modifyme

datadir = 'C:\Users\Zsuzsi\surfdrive\Documents\ERC\BP76_Data\bandit';
modeldatadir = 'C:\Users\Zsuzsi\surfdrive\Documents\ERC\BP76_Data\bandit\modeling\';
filename = 'trialexp_data.mat';
datamat = 'trialdata_notrain';
modelfun = 'QLearning_2pars';

%% load data

cd(datadir);
trialdata = load(filename);
trials = trialdata.(datamat);
subj_num = unique(trials(:,1), 'stable');  
for i = 1:length(subj_num)
    subdata = trials((trials(:,1)==subj_num(i)),:);   
    
    Ntrials = length(subdata);
    data = [(1:Ntrials)',subdata(:,[1,3,4])];    
    % data = trial, subject, session (1=voor, 2=na), choice(q/w/a/s), payoff
     
    % run model:    
    QLearning_2pars(data);
end
