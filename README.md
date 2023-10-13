# kber: Estimate the Strength of the Magnitude Effect
The magnitude effect is an effect where, as stimulus magnitude increases, it becomes more difficult to detect small increments in stimulus magnitude. This package aims to help researchers quantify the strength of the magnitude effect, in experiments which involve discriminating between two stimuli of different magnitudes.

## What is the magnitude effect?
Researchers often assume that animals can choose the largest patch of food or the most attractive mate. All these decisions involve assessing the magnitude of multiple stimuli (ie. the magnitude of a quality, such as length, brightness or mass), and discriminating between these magnitudes.

Intuitively, the ease of discriminating two stimuli depends on the absolute distance between the two magnitudes. If this distance is very small, then the two stimuli will be indistinguishable. This is called the "distance effect". However, often it is not absolute differences which are important, but relative differences. When trying to discriminate the length of two pencils, for example, it may be possible to determine which one is larger if the size difference is only a centimetre. However, it would be very difficult to discriminate the length of two tables which are a centimetre apart in length. This example shows that the magnitude of both stimuli, as well as the distance between them, affects our ability to discriminate. This is called the "magnitude effect".

The ability to discriminate between stimuli often depends on both the distance effect and the magnitude effect. By linking these two effects together with an equation, we can describe the relative strength of each effect:
$$\text{stimulus contrast} = \frac{ΔI}{I^k}$$
where stimulus contrast is a measure of the perceived difference between two stimuli, $ΔI$ is the **distance** between these two stimuli, and $I$ is the stimulus **magnitude**. In this equation, $k$ is a measure of the strength of the magnitude effect. If $k=0$, stimulus magnitude has no effect on discrimination; only the distance betwen stimuli matters. The larger $k$ is, the stronger the magnitude effect.

**Note:** How should the stimulus magnitude $I$ be measured, when there are two stimuli? Historically, studies usually take $I$ to be the smaller magnitude of the pair. Some studies (eg. Nachev et al. 2013) have taken $I$ to be the mean magnitude of both stimuli. Depending on the experiment, one of the stimuli in the pair may have a stronger claim to being the "background" or "reference" stimulus, in which case this stimulus can be used as $I$ (eg. Dixit et al. 2022).

## This package
The aim of this package is to find the value of $k$ which best describes how easy it is to discriminate between two stimuli. The function `estimate_k()` can be used to do this, and the function `stimulus_model()` can be used to inspect the resulting model.
