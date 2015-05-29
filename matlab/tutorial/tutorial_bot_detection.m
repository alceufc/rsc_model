[ Tcell, ~, ~, ~, ~, userType] = load_reddit_data();

% Split data into train and test subsets.
CrossValIdxs = my_crossvalind('Kfold', userType, 2);
TcellTest = Tcell(CrossValIdxs == 1);
TcellTrain = Tcell(CrossValIdxs == 2);
userTypeTrain = userType(CrossValIdxs == 2);

% Estimate bot likelihood.
[Ltest, Ltrain] = estimate_bot_likelihood(TcellTest, TcellTrain, userTypeTrain);

% Classify users.
FpCost = 1; FnCost = 1;
Lthresh = likelihood_thresh(Ltrain, userTypeTrain, FpCost, FnCost);
IsBot = Ltrain > Lthresh;


TP = sum(userTypeTrain == 1 & IsBot == 1);
FP = sum(userTypeTrain == 0 & IsBot == 1);
TN = sum(userTypeTrain == 0 & IsBot == 0);
FN = sum(userTypeTrain == 1 & IsBot == 0);
print_conf_matrix(TP, FP, TN, FN);
