RSC-Model
=========

Matlab implementation of the RSC-Model which is described in the following paper:

>**RSC: Mining and Modeling Temporal Activity in Social Media**

> Alceu Ferraz Costa, Yuto Yamaguchi, Agma Juci Machado Traina, Caetano Traina Jr., and Christos Faloutsos

> The 21st SIGKDD Conference on Knowledge Discovery and Data Mining (KDD), 2015

How to Use
----------

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

Instead of using the default parameters 'paramGuess' returned by the 'rsc_model' function we can estimate (fit) the parameters using real data. The function `load_reddit_data` loads sample data from Reddit users:

```
> Tcell = load_reddit_data();
```

The function `fit_model` is used to estimate the parameters. We are using the RSC default parameters as a starting point for the fit algorithm:
```
> paramEst = fit_model(Tcell, @rsc_model, 'paramGuess', paramGuess);
```

The function `plot_iat_hist_fit` compares the log-binned histogram for real data against synthetic time-stamps. If both histograms are similar then the RSC fit was successful:

```
> timeStampTotal = numel(cell2mat(Tcell));
> Tsynth = fGen(paramEst, timeStampTotal);
> plot_iat_hist_fit(Tcell, Tsynth);
```

The result should be similar to the following figure:

![Log-Binned Histogram](/doc/synth_log_bin_hist_fit.png?raw=true "Log-Binned Histogram Fit")



Datasets
--------



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
