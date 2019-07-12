%% Import data from text file. Created 2017/07/03, Z. Sjoerds
% Script for importing data from a text file.

%% tabula rasa
clear all
clc

%% Modifyme
datadir = 'C:\Users\Zsuzsi\surfdrive\Documents\ERC\BP76_Data\bandit\'; 
filename = 'N82_csv.csv'; 
delimiter = ';'; %in case of a csv file
startRow = 2; %skip the header
savefilename = 'trialexp_data.mat'; %this will be the filename of the data matrix for further analyses

%% Format string for each line of text:
%   column1: text (%s)
%	column2: double (%f)
%   column3: double (%f)
%	column4: text (%s)
%   column5: text (%s)
%	column6: text (%s)
%   column7: double (%f)
%	column8: text (%s)
%   column9: double (%f)
%	column10: double (%f)
%   column11: double (%f)
%	column12: double (%f)
%   column13: double (%f)
%	column14: text (%s)
%   column15: text (%s)
%	column16: text (%s)
%   column17: text (%s)
%	column18: text (%s)
%   column19: text (%s)
%	column20: text (%s)
%   column21: double (%f)
%	column22: double (%f)
%   column23: double (%f)
%	column24: text (%s)
%   column25: text (%s)
%	column26: text (%s)
%   column27: double (%f)
%	column28: double (%f)
%   column29: double (%f)
%	column30: double (%f)
%   column31: text (%s)
%	column32: double (%f)
%   column33: double (%f)
%	column34: double (%f)
%   column35: double (%f)
%	column36: double (%f)
%   column37: double (%f)
%	column38: double (%f)
%   column39: double (%f)
%	column40: double (%f)
%   column41: double (%f)
%	column42: double (%f)
%   column43: text (%s)
%	column44: double (%f)
%   column45: double (%f)
%	column46: double (%f)
%   column47: text (%s)
% For more information, see the TEXTSCAN documentation.
formatSpec = '%s%f%f%s%s%s%f%s%f%f%f%f%f%s%s%s%s%s%s%s%f%f%f%f%s%s%f%f%f%f%s%f%f%f%f%f%f%f%f%f%f%f%s%f%f%f%s%[^\n\r]';

%% Open the text file.
cd(datadir)
fileID = fopen(filename,'r');

%% Read columns of data according to format string.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);

%% Close the text file.
fclose(fileID);

%% Post processing for unimportable data.
% No unimportable data rules were applied during the import, so no post
% processing code is included. To generate code which works for
% unimportable data, select unimportable cells in a file and regenerate the
% script.

%% Allocate imported array to column variable names
ExperimentName = dataArray{:, 1};
Subject = dataArray{:, 2};
Session = dataArray{:, 3};
ClockInformation = dataArray{:, 4};
DataFileBasename = dataArray{:, 5};
Date = dataArray{:, 6};
DisplayRefreshRate = dataArray{:, 7};
ExperimentVersion = dataArray{:, 8};
Group = dataArray{:, 9};
OverallGain1Session = dataArray{:, 10};
OverallGain2Session = dataArray{:, 11};
OverallGain3 = dataArray{:, 12};
RandomSeed = dataArray{:, 13};
RuntimeCapabilities = dataArray{:, 14};
RuntimeVersion = dataArray{:, 15};
RuntimeVersionExpected = dataArray{:, 16};
SessionDate = dataArray{:, 17};
SessionStartDateTimeUtc = dataArray{:, 18};
SessionTime = dataArray{:, 19};
StudioVersion = dataArray{:, 20};
Block = dataArray{:, 21};
blok = dataArray{:, 22};
chosehist = dataArray{:, 23};
ExpBlock = dataArray{:, 24};
ExpBlockCycle = dataArray{:, 25};
ExpBlockSample = dataArray{:, 26};
keuzeDuration = dataArray{:, 27};
keuzeDurationError = dataArray{:, 28};
keuzeOnsetDelay = dataArray{:, 29};
keuzeOnsetTime = dataArray{:, 30};
keuzeRESP = dataArray{:, 31};
keuzeRT = dataArray{:, 32};
noise = dataArray{:, 33};
OverallGain1Block = dataArray{:, 34};
OverallGain2Block = dataArray{:, 35};
payoff1 = dataArray{:, 36};
payoff2 = dataArray{:, 37};
payoff3 = dataArray{:, 38};
payoff4 = dataArray{:, 39};
PractBlock = dataArray{:, 40};
PractBlockCycle = dataArray{:, 41};
PractBlockSample = dataArray{:, 42};
Procedure = dataArray{:, 43};
ptshist = dataArray{:, 44};
rewardOnsetDelay = dataArray{:, 45};
rewardOnsetTime = dataArray{:, 46};
Running = dataArray{:, 47};

%% Clear temporary variables
clearvars filename delimiter startRow formatSpec fileID dataArray ans;

%% Save all variables as a .mat file, for later reference
cd(datadir);
save trial_data;

%% Get Experiment version

for i = 1:length(ExperimentVersion); 
    versions=ExperimentVersion{i}; 
    ExpVersion{i}=str2double(versions(end));
    
end

versions_double=(cell2mat(ExpVersion')-6);

%% Concatenate the needed vars into one matrix for further analyses
trialdata = cat(2,Subject,ExpBlock,chosehist,ptshist,versions_double);


% Remove training trials
trialdata_notrain = trialdata(~any(isnan(trialdata(:,2)),2),:);

%add reward of chosen slotmachine
% for i = 1:length(data_notrain); 
%     data_notrain(i,8)=data_notrain(i,((data_notrain(i,3)+3))); 
% end

%create header names for future reference
headernames = {'Subject';'ExpBlock';'chosehist';'payoff_choice';'versions'}';

cd(datadir);
save(savefilename, 'trialdata_notrain', 'headernames');