# kber: Estimate the Strength of the Magnitude Effect
The magnitude effect is an effect where, as stimulus magnitude increases, it becomes more difficult to detect small increments in stimulus magnitude. You can read about why this is important and how to quantify how stimuli are perceived **here**:

Dixit, T., Apostol, A.L., Chen, K.-C., Fulford, A.J.C., Town, C.P. & Spottiswoode, C.N. (2022) Visual complexity of egg patterns predicts egg rejection according to Weber’s law. _Proceedings of the Royal Society B: Biological Sciences_. 289 (1978), 20220710. [doi:10.1098/rspb.2022.0710.](https://doi.org/10.1098/rspb.2022.0710)

This package aims to help researchers conduct similar analysis, in experiments which involve discriminating between two stimuli of different magnitudes.

## Quantifying the magnitude effect
The ability to discriminate between stimuli often depends on both the absolute and relative differences between two stimuli. This can be summarised with this equation (modified from Dixit et al. 2022):
$$\text{stimulus contrast} = \frac{ΔI}{I^k}$$
where stimulus contrast is a measure of the perceived difference between two stimuli, $ΔI$ is the absolute difference between these two stimuli, and $I$ is the stimulus **magnitude**. In this equation, $k$ is a measure of the strength of the magnitude effect. If $k=0$, stimulus magnitude has no effect on discrimination; only the distance betwen stimuli matters. The larger $k$ is, the stronger the magnitude effect.

**Note:** How should the stimulus magnitude $I$ be measured, when there are two stimuli? Historically, studies usually take $I$ to be the smaller magnitude of the pair. Some studies (eg. Nachev et al. 2013) have taken $I$ to be the mean magnitude of both stimuli. Depending on the experiment, one of the stimuli in the pair may have a stronger claim to being the "background" or "reference" stimulus, in which case this stimulus can be used as $I$ (eg. Dixit et al. 2022).

## This package
The aim of this package is to find the value of $k$ which best describes discrimination between stimuli. The function `estimate_k()` estimates this value of $k$, and the function `stimulus_model()` can be used to inspect the resulting model, and any other models (eg. $k = 0$ or $k = 1$). If you want to plot the predictions of this model, you can use `stimulus_contrast()` to compute contrast directly.

## Feedback
Please send any questions, suggestions and bugs to meganworsley16@gmail.com or open an issue at https://github.com/mzw22/kber.
