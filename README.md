# kber: Estimate the Strength of the Magnitude Effect
The magnitude effect is an effect where, as stimulus magnitude increases, it becomes more difficult to detect small increments in stimulus magnitude. You can read about why this is important and how to quantify how stimuli are perceived in our Behavioral Ecology paper [**here**](https://doi.org/10.1093/beheco/araf025) (Worsley et al. 2025), and also [**here**](https://doi.org/10.1111/evo.14290) (Dixit et al. 2021).

This package, presented in the paper, aims to help researchers conduct similar analysis.

## Quantifying the magnitude effect
The ability to discriminate between stimuli often depends on both the absolute and relative differences between two stimuli. This can be summarised with this equation (modified from Dixit et al. 2022):
$$\text{stimulus contrast} = \frac{ΔI}{I^k}$$
where stimulus contrast is a measure of the perceived difference between two stimuli, $ΔI$ is the absolute difference between these two stimuli, and $I$ is the stimulus **magnitude**. In this equation, $k$ is a measure of the strength of the magnitude effect. If $k=0$, stimulus magnitude has no effect on discrimination; only the distance betwen stimuli matters. The larger $k$ is, the stronger the magnitude effect.

**Note:** How should the stimulus magnitude $I$ be measured, when there are two stimuli? Historically, studies usually take $I$ to be the smaller magnitude of the pair. Some studies (eg. Nachev et al. 2013) have taken $I$ to be the mean magnitude of both stimuli. Depending on the experiment, one of the stimuli in the pair may have a stronger claim to being the "background" or "reference" stimulus, in which case this stimulus can be used as $I$ (eg. Dixit et al. 2022).

## Installing kber
This package is not (yet) available on CRAN, but you can download it from GitHub using the package `devtools`. Install kber with the following code:
```r
library(devtools) #allows downloads from github
install_github("mzw22/kber") #download package
library(kber)
```

## About this package
`estimate_k()` estimates the value of $k$ which best describes discrimination between stimuli. `stimulus_model()` can be used to inspect the resulting model, and any other models (eg. $k = 0$ or $k = 1$). If you want to plot the predictions of this model, you can use `stimulus_contrast()` to compute contrast directly.

## Warning
This model of stimulus perception assumes that (a) discrimination can/should be described with a generalised linear model, and (b) discrimination varies with magnitude in an unidirectional manner which can be described by the parameter $k$. You can (and should) treat the output the way you would any other binomial GLM - plot the output and check that the assumptions make sense.

## References
Tanmay Dixit, Eleanor M. Caves, Claire N. Spottiswoode, Nicholas P. C. Horrocks, Why and how to apply Weber's Law to coevolution and mimicry, Evolution, Volume 75, Issue 8, 1 August 2021, Pages 1906–1919, https://doi.org/10.1111/evo.14290

Tanmay Dixit, Andrei L. Apostol, Kuan-Chi Chen, Anthony J. C. Fulford, Christopher P. Town, Claire N. Spottiswoode 2022 Visual complexity of egg patterns predicts egg rejection according to Weber's law Proc. R. Soc. B.28920220710 http://doi.org/10.1098/rspb.2022.0710

Vladislav Nachev, Kai Petra Stich, York Winter 2013 Weber’s Law, the Magnitude Effect and Discrimination of Sugar Concentrations in Nectar-Feeding Animals. PLoS ONE 8(9): e74144. https://doi.org/10.1371/journal.pone.0074144

Megan Z Worsley, Julia Schroeder, Tanmay Dixit, How animals discriminate between stimulus magnitudes: a meta-analysis, Behavioral Ecology, Volume 36, Issue 3, May/June 2025, araf025, https://doi.org/10.1093/beheco/araf025

## Feedback
Please send any questions, suggestions and bugs to mw327@st-andrews.ac.uk or open an issue at https://github.com/mzw22/kber.
