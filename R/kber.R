
#### All kber functions ####

### Last Updated: 04/10/2023
### Megan Worsley
### Functions for estimating the value of k (defined in Dixit et al. 2022)

### Functions:
# stimulus_contrast
# stimulus_model
# k_AIC
# estimate_k

# Testing stuff:
# set wd to package location
#library(devtools) #for loading the unfinished package
#library(roxygen2) #for documenting
#load_all(".") # Load source code
#document(".") # Load the help documentation

# Load packages
require(rootSolve) #find roots of a function

#' Stimulus contrast
#'
#' Computes the stimulus contrast, defined as `distance/(magnitude^k)`, for a given value of `k`.
#' @param di a vector of stimulus distances, where stimulus distance is the absolute difference between the magnitudes of two stimuli `a` and `b`.
#' @param i a vector of stimulus magnitudes, where stimulus magnitude is usually the mean magnitude of two stimuli `a` and `b`
#' (but other measures could be used).
#' @param k a constant which determines the strength of the magnitude effect.
#' When `k = 0`, only stimulus distance is used to predict discrimination;
#' when `k = 1`, discrimination follows Weber's law;
#' `0 < k < 1` is a near miss to Weber's law;
#' `k > 1` is an opposite miss to Weber's law.
#' @return The contrast between two stimuli, computed as `di/(i^k)`.
#' @examples
#' data(stimuli)
#' #data contains columns for two stimuli of different magnitudes, a and b
#' stimuli$abs_diff <- abs(stimuli$stimulus_a - stimuli$stimulus_b) #stimulus distance = absolute difference between a and b
#' stimuli$mean_ab <- (stimuli$stimulus_a + stimuli$stimulus_b)/2 #stimulus magnitude = mean magnitude of a and b
#' #get stimulus contrast for k=1.2
#' stimuli$contrast <- stimulus_contrast(di=stimuli$abs_diff, i=stimuli$mean_ab, k=1.2);
#' @export
stimulus_contrast <- function(di, i, k) {
  output <- di/(i^k)
  return (output)
}

#' Stimulus model
#'
#' Fits a generalised linear model, with [`stimulus contrast(di, i, k)`][stimulus_contrast()]
#' as the predictor variable and `response` as the response variable
#' @param di a vector of stimulus distances (see [stimulus_contrast()])
#' @param i a vector of stimulus magnitudes (see [stimulus_contrast()])
#' @param k a constant which determines the strength of the magnitude effect (see [stimulus_contrast()])
#' @param response the response variable of the model (discrimination between stimuli)
#' @param family model family (see [glm()])
#' @param weights weights of each observation, used in binomial models (see [glm()]).
#' Leave empty if each observation is 1 decision (binary stimuli)
#' @return A fitted generalised linear model of the form `glm(response ~ `
#' [`stimulus contrast(di, i, k)`][stimulus_contrast()]`, family=family, weights=weights)`
#' @examples
#' data(stimuli)
#' #data contains columns for two stimuli of different magnitudes, a and b
#' stimuli$abs_diff <- abs(stimuli$stimulus_a - stimuli$stimulus_b) #stimulus distance = absolute difference between a and b
#' stimuli$mean_ab <- (stimuli$stimulus_a + stimuli$stimulus_b)/2 #stimulus magnitude = mean magnitude of a and b
#' #get stimulus model for k=1
#'  stimulus_model(di=stimuli$abs_diff, i=stimuli$mean_ab, k=1, response=stimuli$discrimination,
#'                 family=binomial(link="logit"))
#' @export
stimulus_model <- function(di, i, k, response, family, weights=NULL) {
  # Print model to console unless called inside a function
  if (sys.nframe() == 1) {
    message(paste("model: glm(response ~ di/(i^k), family=",
                  deparse(substitute(family)), sep=""))
  }
  
  # Add column for near miss relative intensity (nmri) for given k value
  contrast <- stimulus_contrast(di=di, i=i, k=k)
  
  # Add weights if there aren't any
  if (is.null(weights)){
    weights <- rep(1, length.out=length(contrast))
  }
  
  # GLM (link can be logit or probit)
  output <- glm(response ~ contrast, weights=weights, family=family)
  return (output)
}

#' Calculate the AIC values of a series of models, varying k
#'
#' Fits a generalised linear models with [stimulus_model()] for a given value of `k` (see [stimulus_contrast()]),
#' and computes the AIC of the extracting model. This is mostly used by other functions,
#' the only reason you'd really need it is if you want to make custom diagnostic plots with `ggplot`.
#' @param di a vector of stimulus distances (see [stimulus_contrast()])
#' @param i a vector of stimulus magnitudes (see [stimulus_contrast()])
#' @param k a constant which determines the strength of the magnitude effect (see [stimulus_contrast()])
#' @param response the response variable of the model (discrimination between stimuli)
#' @param family model family to use for [stimulus_model()] (see [glm()])
#' @param weights weights of each observation, used in binomial models (see [glm()]).
#' Leave empty if each observation is 1 decision (binary stimuli)
#' @param plot show diagnostic plot (recommended).
#' Solid black line shows how the AIC of [stimulus_model()] varies with `k`;
#' red vertical line shows the best fitting value of `k`;
#' dashed horizontal line crosses the AIC curve at the 95% confidence intervals for this `k` estimate.
#' @return A summary table containing the best fitting value of `k` which minimises the model AIC,
#' its 95% confidence intervals (`lower_95` and `upper_95`),
#' and the AIC values of [stimulus_model()] for these values of k.
#' @examples
#' data(stimuli)
#' #data contains columns for two stimuli of different magnitudes, a and b
#' stimuli$abs_diff <- abs(stimuli$stimulus_a - stimuli$stimulus_b) #stimulus distance = absolute difference between a and b
#' stimuli$mean_ab <- (stimuli$stimulus_a + stimuli$stimulus_b)/2 #stimulus magnitude = mean magnitude of a and b
#' #get the AIC of stimulus_model for k=1
#' k_AIC(di=stimuli$abs_diff, i=stimuli$mean_ab, response=stimuli$discrimination,
#'       family=binomial(link="logit"))
k_AIC <- function(di, i, k, response, family, weights=NULL) {
  AIC_vec <- c() #creates empty vector to fill later
  for (kn in k) {
    # Fit model for current value of k
    model_kn <- stimulus_model(di=di, i=i, k=kn, response=response,
                               weights=weights, family=family)
    # Extract AIC from this model
    AIC_kn <- AIC(model_kn)
    # Add this AIC value to vector
    AIC_vec <- c(AIC_vec, AIC_kn)
  }
  
  if (length(AIC_vec)==1){ #un-vectorise if necessary
    AIC_vec <- as.numeric(AIC_vec)
  }
  
  return (AIC_vec)
}

#' Estimate k
#'
#' Fits a series of generalised linear models with [stimulus_model()],
#' to find the best-fitting value of `k` (see [stimulus_contrast()]) which maximises the model fit.
#' @param di a vector of stimulus distances (see [stimulus_contrast()])
#' @param i a vector of stimulus magnitudes (see [stimulus_contrast()])
#' @param response the response variable of the model (discrimination between stimuli)
#' @param family model family to use for [stimulus_model()] (see [glm()])
#' @param weights weights of each observation, used in binomial models (see [glm()]).
#' Leave empty if each observation is 1 decision (binary stimuli)
#' @param k_range the range of `k` values in which to search for the optimal value of `k`,
#' which minimises the AIC of [stimulus_model()], and its 95% confidence intervals.
#' @param plot show diagnostic plot (recommended).
#' Solid black line shows how the AIC of [stimulus_model()] varies with `k`;
#' red vertical line shows the best fitting value of `k`;
#' dashed horizontal line crosses the AIC curve at the 95% confidence intervals for this `k` estimate.
#' @return A summary table containing the best fitting value of `k` which minimises the model AIC,
#' its 95% confidence intervals (`lower_95` and `upper_95`),
#' and the AIC values of [stimulus_model()] for these values of k.
#' @examples
#' data(stimuli)
#' #data contains columns for two stimuli of different magnitudes, a and b
#' stimuli$abs_diff <- abs(stimuli$stimulus_a - stimuli$stimulus_b) #stimulus distance = absolute difference between a and b
#' stimuli$mean_ab <- (stimuli$stimulus_a + stimuli$stimulus_b)/2 #stimulus magnitude = mean magnitude of a and b
#' #get stimulus model for k=1
#' estimate_k(di=stimuli$abs_diff, i=stimuli$mean_ab, response=stimuli$discrimination,
#'            family=binomial(link="logit"))
#' @export
estimate_k <- function(di, i, response, family, weights=NULL, k_range=c(-1, 3), plot=TRUE){
  # Print model to console
  message(paste("model: glm(response ~ di/(i^k), family=",
                deparse(substitute(family)), sep=""))
  
  ### 1. Find minimum value of k
  # Function to minimise (finds AIC for each value of k)
  AIC_fun <- function(x){
    y <- k_AIC(di=di, i=i, k=x, response=response,
               weights=weights, family=family)
    return(y)
  }
  
  # Optional diagnostic plot: add AIC ~ k
  if (plot==TRUE){
    curve(AIC_fun, from=k_range[1], to=k_range[2],
          xlab="k", ylab="model AIC") #fit curve
  }
  
  # Find minimum value of k (minimise AIC_fun)
  min_point <- optimise(f=AIC_fun, interval=k_range)
  k_min <- min_point$minimum
  AIC_min <- min_point$objective
  
  # Check whether the minimum value is at the range edge
  k_lower_edge <- abs(k_min - k_range[1])
  k_upper_edge <- abs(k_min - k_range[2])
  if (k_lower_edge < 0.001 | k_upper_edge < 0.001){
    stop("Optimal value of k is outside of k_range")
  }
  
  ### 2. Find 95% confidence intervals for k
  # Function that crosses the x axis at the 95% conf intervals
  AIC_95_fun <- function(x){
    y <- AIC_fun(x)
    y <- y - AIC_min - 2 #95% conf intervals
    return(y)
  }
  
  # Find 95% conf intervals for k (roots of AIC_95_fun)
  conf_intervals <- uniroot.all(f=AIC_95_fun, interval=k_range)

  # Clean up the confidence intervals
  lower_roots <- conf_intervals[conf_intervals < k_min]
  higher_roots <- conf_intervals[conf_intervals > k_min]
  
  # Stop if either side is missing a confidence interval
  if (length(lower_roots) == 0 & length(higher_roots) == 0){
    stop(paste("95% confidence intervals are outside of k_range"))
  } else if (length(lower_roots) == 0){
    stop(paste("Lower 95% confidence interval is outside of k_range"))
  } else if (length(higher_roots) == 0){
    stop(paste("Upper 95% confidence interval is outside of k_range"))
  }
  
  # Get roots closest to k_min
  lower_root <- max(lower_roots)
  higher_root <- min(higher_roots)
  conf_intervals <- c(lower_root, higher_root)
  
  # Optional diagnostic plot: add minimum point and conf intervals
  if (plot==TRUE){
    abline(v=k_min, col="red") #minimum k
    abline(h=AIC_min+2, lty="dashed") #confidence intervals
  }
  
  ### 3. Organise output into a stimuliframe
  output <- stimuli.frame(estimate=c(k_min, AIC_min),
                       lower_95=c(conf_intervals[1], AIC_min+2),
                       upper_95=c(conf_intervals[2], AIC_min+2))
  rownames(output) <- c("k", "AIC") #set row names
  
  return(output)

}
