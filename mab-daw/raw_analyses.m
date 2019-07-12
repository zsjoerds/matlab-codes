%% Raw bandit data analysis. Created 2017/07/04, Z. Sjoerds
% Script for analyzing the raw data from the multi-arm bandit task (Daw et al., 2006).

%% tabula rasa
clear all
clc

%% Modifyme
datadir = 'C:\Users\Zsuzsi\surfdrive\Documents\ERC\BP76_Data\bandit\'; %'C:\Users\sjoerdsz1\surfdrive\Documents\Onderwijs\Bachelorprojecten\Sem2_2017\Data\bandit\
filename = 'trialexp_data.mat'; 
savefilename = 'pp_rawvars.mat'; %this will be the filename of the data matrix for further analyses

%% load the data
cd(datadir);
data=load(filename);
dataset = data.trialdata_notrain;

%% get info
check_pp_amount = length(dataset)/200;

check_text = ['number of participants = ' {check_pp_amount}];
disp(check_text);

pps = unique(dataset(:,1), 'stable'); %extract pp numbers, but make sure that the order is not changed!

%% calculate trial-by-trial variables

%gain
for i = 2:length(dataset);
    dataset(i,6)= (dataset(i,4)- dataset(i-1,4));   
    %stay probabilities (total)
    if dataset(i,3)==dataset(i-1,3);
        dataset(i,7)=1;
    else dataset(i,7)=0;
    end
    %switch probabilities (total)
    if dataset(i,3)~=dataset(i-1,3);
        dataset(i,8)=1;
    else dataset(i,8)=0;
    end   
    %stay probabilities after increase in payout
    if dataset(i,6)==1 && (dataset(i-1,4)<=dataset(i,4));
        dataset(i,9)=1;
    else dataset(i,9)=0;
    end
    %switch probabilities after decrease in payout
    if dataset(i,6)==0 && (dataset(i-1,4)>=dataset(i,4));
        dataset(i,10)=1;
    else dataset(i,10)=0;
    end
end


%% save your trial-by-trial (tbt) data
tbt_raw = [dataset];
tbt_raw_hdrs = {'Subject';'ExpBlock';'chosehist';'payoff_choice';'versions';'gain';'p_stay';'p_switch';'p-stay-gain';'p_switch_lose'}';
save('trialbytrial_raw', 'tbt_raw', 'tbt_raw_hdrs')

%% calculate means per pp

for j = 1:length(pps)
    first=1+(200*(j-1));
    last=first+199;
    p_stay(j,1)=(sum(dataset(first:last,6)))/200;
    p_switch(j,1)=(sum(dataset(first:last,7)))/200;
    p_stay_gain(j,1)=(sum(dataset(first:last,8)))/200;
    p_switch_lose(j,1)=(sum(dataset(first:last,9)))/200;
    expversion(j,1)=dataset(first,5);
end

    %calculate stay clustering
for j = 1:length(pps)
    first=1+(200*(j-1));                    %define where you start counting: at 1 with 1st pp, 201 with 2nd, etc.
    last=first+199;                         %define where you stop counting: at 200 with 1st pp, at 400 with 2nd, etc.                        
    stay_ind=find(dataset(first:last,6));    %give indices of all stay trials
	stay_ind=[0; stay_ind];                 %add a 0 in the beginning, so that the first cluster is also counted
    stay_ind_diff=find(diff(stay_ind)>1);   %index again
    clustsize=(diff(stay_ind_diff)+1);      %calculate the difference between those last indices = clustersize. Add 1 to add the one trial that was not counted in the stay-step (as only from the 2nd trial on it was counted as 'staying')
    %clusters(j)=num2cell(clustsize')
    n_clust(j,1) = length(clustsize);
    m_clustsize(j,1) = mean(clustsize);
end

pp_data = [round(pps) expversion p_stay p_switch p_stay_gain p_switch_lose n_clust m_clustsize];
pp_data_headers = {'pps'; 'expversion'; 'p_stay'; 'p_switch'; 'p_stay_gain'; 'p_switch_lose'; 'n_clust'; 'm_clustsize'}';
save(savefilename, 'pp_data', 'pp_data_headers')