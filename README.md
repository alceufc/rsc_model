RSC-Model
=========

Matlab implementation of the RSC-Model which is described in the following paper:

>**RSC: Mining and Modeling Temporal Activity in Social Media**

> Alceu Ferraz Costa, Yuto Yamaguchi, Agma Juci Machado Traina, Caetano Traina Jr., and Christos Faloutsos

> The 21st SIGKDD Conference on Knowledge Discovery and Data Mining (KDD), 2015

How to Use
----------

### Generating Synthetic Time-stamps

Using RSC to generate 10,000 synthetic time-stamps:

```
> addpath(genpath('.')); % Add sub-folders to Matlab path.
> [ fGen, ~, paramGuess ] = rsc_model();
> Tsynth = fGen(paramGuess, 1e5);
```

We can use the `plot_iat_hist` function to plot the log-binned histogram of the synthetic inter-arrival times (IAT):

```
> plot_iat_hist(Tsynth);
```

The result should be similar to the following figure:

![Log-Binned Histogram](/doc/synth_log_bin_hist.png?raw=true "Log-Binned Histogram")

### Fitting Data

Instead of using the default parameters `paramGuess` returned by the 'rsc_model' function we can estimate (fit) the parameters using real data. The function `load_reddit_data` loads sample data from Reddit users:

```
> Tcell = load_reddit_data();
```

The function `fit_model` is used to estimate the parameters. We are using the RSC default parameters as a starting point for the fit algorithm:
```
> paramEst = fit_model(Tcell, @rsc_model, 'paramGuess', paramGuess);
```

The function `plot_iat_hist_fit` compares the log-binned histogram for real data against synthetic time-stamps. If both histograms are similar, then the RSC fit was successful:

```
> timeStampTotal = numel(cell2mat(Tcell));
> Tsynth = fGen(paramEst, timeStampTotal);
> plot_iat_hist_fit(Tcell, Tsynth);
```

The result should be similar to the following figure:

![Log-Binned Histogram](/doc/synth_log_bin_hist_fit.png?raw=true "Log-Binned Histogram Fit")

### Detecting Bots

The sample dataset of Reddit users has some users that are bots. We can use the `load_reddit_data` function to get a grouping variable that tells whether the i-th entry of Tcell is a bot or a human:

```
> [ Tcell, ~, ~, ~, ~, userType] = load_reddit_data();
```

`userType(idx) == 1` indicates that the time-stamp sequence in `Tcell{idx}` is from a bot. The function `estimate_bot_likelihood` returns a vector `L` where each entry `L(idx)` corresponds to the likelihood (i.e. the score) that the time-stamp sequence `Tcell(idx)` is from a bot:

```
% Split data into train and test subsets.
> CrossValIdxs = my_crossvalind('Kfold', userType, 2);
> TcellTest = Tcell(CrossValIdxs == 1);
> TcellTrain = Tcell(CrossValIdxs == 2);
> userTypeTrain = userType(CrossValIdxs == 2);
> [Ltest, Ltrain] = estimate_bot_likelihood(TcellTest, TcellTrain, userTypeTrain);
```

In order to classify users as bots or humans, we use a cost-sensitive approach in our paper. Assuming the costs `FpCost = 10` and `FnCost = 1` for false-positive (FP) and false-negative errors (FN), we can detect bot using the `likelihood_thresh` function as follows:

```
> FpCost = 10; FnCost = 1;
> Lthresh = likelihood_thresh(Ltrain, userTypeTrain, FpCost, FnCost);
> IsBot = LtrainL > Lthresh;
```

We can also use the `print_conf_matrix` function to print the confusion matrix:

```
> TP = sum(userTypeTrain == 1 & IsBot == 1);
> FP = sum(userTypeTrain == 0 & IsBot == 1);
> TN = sum(userTypeTrain == 0 & IsBot == 0);
> FN = sum(userTypeTrain == 1 & IsBot == 0);
> print_conf_matrix(TP, FP, TN, FN);

Predicted Class  
                .---------.--------.
                |   Pos.  |   Neg. |
        .-------|---------|--------|
 Actual | Pos.  |      9  |     5  |
 Class  | Neg.  |      1  |   498  |
        `--------------------------
```

Datasets
--------

This repository includes a sample dataset with time-stamps of 1,036 Reddit
users in the `sample_data/reddit/` directory.

We also include below links to download the complete datasets used in our paper.
Each dataset has a README.md file with a more detailed description of the data.

 - [Reddit Dataset](https://www.dropbox.com/sh/lqk08yvr5cek8h9/AAD6RoP9xi_iCCUQvpgQIZc-a?dl=0) (20 Million time-stamps from 96,199 users);
 - [Twitter Dataset](https://www.dropbox.com/sh/j7r55z6wqkufcks/AABJYKRUY-PNUxOzaNgYzWPha?dl=0) (16 Million time-stamps from 6,790 users);

Acknowledgements
----------------

This material is based upon work supported by
FAPESP,
CNPq,
CAPES,
STIC-AmSud,
the RESCUER project funded by the European Commission
(Grant: 614154) and by the CNPq/MCTI (Grant: 490084/2013-3),
JSPS KAKENHI, Grant-in-Aid for JSPS Fellows #242322,
the National Science Foundation under Grant No. CNS-1314632, IIS-1408924,
ARO/DARPA under Contract Number W911NF-11-C-0088
and by the Army Research Laboratory under Cooperative Agreement Number W911NF-09-2-0053.
