% Fits model to choices gambling task
% Free pars: softmax and learning rate; NOT initial Q value and uncertainty bonus

%input from RunQlearningMultipleSubjects: data: 200x4 double

function QLearning_2pars(data)
%subj = subj_num;

%% create multistart object
ms = MultiStart;

%% create problem structure
% Softmax & learning rate start values.
% besides these other start valus will also be used, see below.
start_params = [ 2 0.5 ];
OPTIONS = optimset('Algorithm','sqp','TolFun',1e-12,'TolCon',1e-12);
lb = [ 0 0 ];
ub = [ 1000 1 ];

problem = createOptimProblem('fmincon','x0',start_params, ...
    'objective', @model_fit,'lb',lb,'ub',ub, 'options',OPTIONS);

%% set start points
%set # random start points, now set to 100
[xmin,fmin,flag,outpt,allmins] = run(ms,problem,100);

% Display:
xmin %parameter estimates
fmin % neglogLik
flag %exitflag
outpt
%disp(allmins) % need to debug halfway to see allmins

FitData(1,1:3) = [xmin fmin];
%Print fit-output to textfile
% create a file and open it for appending.
fid = fopen('Fit_2pars_100sps.txt', 'a');
fprintf(fid, '\n');
fprintf(fid, 'subject\t');
fprintf(fid, num2str(data(1,2)));
fprintf(fid, '\t');
fprintf(fid, 'Softmax_LR_NegLL\t');
fprintf(fid, '%i\t', FitData);
fclose(fid);

%Save best fitting parameters in mat.file(needed to compute trial-by-trial PEs, Q-values, etc.)

%cd modeldatadir
eval(['save ' 'TwoPars_pp' num2str(data(1,2)) 'FitData']);
%cd ..
%% ======= MLE estimation for model
    function minimizeloglik = model_fit(arg)

        
        % data = trial, subject, choice(q/w/a/s), payoff
        
        outcome = data(:,4);      %payoff chosen machine
        keuze = data(:,3);          %subject's choice
        
        
        for i = 1:length(outcome)
                       
            %set initial Q values
            if i == 1
                for m = 1:4
                    Q(m,i) = 50; %consider replacing by mean value practice block
                end
            end
            
            %% softmax rule
            for m = 1:4;
                ns(m,i) = exp(Q(m,i)/arg(1));   %numerator softmax, arg(1)= softmax-temperature (higher = more random)
            end
            
            som(i) = ns(1,i) + ns(2,i) + ns(3,i) + ns(4,i); %denominator softmax
            
            for m = 1:4;
                kans(m,i) = ns(m,i)/som(i);     %softmax equation; kans = probability choice m on trial i
            end
            
            %% value-updating rule
            %arg(2)=LR
            
            for m = 1:4;  
                if m == keuze(i)
                    %Q value chosen machine is updated:
                    PE(i) = outcome(i) - Q(m,i);
                    Q(m,i+1) = Q(m,i) + (arg(2) * PE(i));
                else
                    %Q unselected machines do not change:
                    Q(m,i+1) = Q(m,i);
                end
            end
                
           %% model choice with softmax
              
            P(i) = ns(keuze(i),i)/som(i);      %P = propability chosen cue
            logP(i) = log(P(i));               %log P
            
            Q_chosen(i) = Q(keuze(i),i);       %Q value subject's choice
        end
        
        loglik = sum(logP);        %sum of log probabilities
        minimizeloglik = -loglik;  %maximixe this (minimize negative LL)
        
    end
end