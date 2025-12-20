# dealing with 'no visible binding' note as recommended in lecture 11
utils::globalVariables(c("heart_dat","p_hat"))

#' Simulation
#'
#' This function generates reproducible synthetic datasets
#'
#' @param seed random seed
#' @param n number of rows to data
#'
#' @return A synthetic dataset with continuous, categorical and outcome variables
#'
#' @importFrom MASS mvrnorm
#' @importFrom stats glm cov predict binomial median IQR
#' @importFrom utils data
#' @importFrom dplyr mutate select
#' @export
simulation <- function(seed = 403, n = NULL){
    data("heart_dat", package = "HeartR", envir = environment())

  if(is.null(n)){
    n <- nrow(heart_dat)
  }

  set.seed(seed)

  bounds <-function(x,min,max){
    x[x<min] <- min
    x[x>max] <- max
    return(x)
  }

  ## do it by default
  ## don't do it based on the data
  ## ensure the users have some control
  ## what if they want to build their own data
  ## set default mu and sigma and all in the parameters

  contVars <- c("Age", "Weight", "Height", "Systolic_BP", "Diastolic_BP","Heart_Rate",
                "Blood_Sugar_Fasting", "Cholesterol_Total", "BMI")
  mu <- colMeans(heart_dat[, contVars])
  sigma <- cov(heart_dat[, contVars]) # covariance matrix

  # multivariate normal data
  contData <- MASS::mvrnorm(n, mu,sigma)
  # to make sure there are no decimals. We wouldn't say someone is 34.8715 years old
  contData <- as.data.frame(round(contData))
  # View(contData)

  contData$Age <- bounds(contData$Age,30,80)
  contData$Weight <- bounds(contData$Weight, 50, 119)
  contData$Height <- bounds(contData$Height,150,199)
  contData$Systolic_BP <- bounds(contData$Systolic_BP, 100, 179)
  contData$Diastolic_BP <- bounds(contData$Diastolic_BP, 60,119)
  contData$Heart_Rate <- bounds(contData$Heart_Rate, 60,109)
  contData$Blood_Sugar_Fasting <- bounds(contData$Blood_Sugar_Fasting, 70, 179)
  contData$Cholesterol_Total <- bounds(contData$Cholesterol_Total, 150, 299)
  contData$BMI <- bounds(contData$BMI, 18, 40)

  # n <- nrow(heart_dat)
  gender_prob <- prop.table(table(heart_dat$Gender))
  smoking_prob <- prop.table(table(heart_dat$Smoking))
  alcohol_prob <- prop.table(table(heart_dat$Alcohol_Intake))
  activity_prob <- prop.table(table(heart_dat$Physical_Activity))
  diet_prob <- prop.table(table(heart_dat$Diet))
  stress_prob <- prop.table(table(heart_dat$Stress_Level))
  hypertension_prob <- prop.table(table(heart_dat$Hypertension))
  diabetes_prob <- prop.table(table(heart_dat$Diabetes))
  hyperlipidemia_prob <- prop.table(table(heart_dat$Hyperlipidemia))
  family_prob <- prop.table(table(heart_dat$Family_History))
  prevHA_prob <- prop.table(table(heart_dat$Previous_Heart_Attack))

  Gender <- sample(names(gender_prob), n, replace = TRUE, prob = gender_prob)
  Smoking <- sample(names(smoking_prob), n, replace = TRUE, prob = smoking_prob)
  Alcohol_Intake <- sample(names(alcohol_prob), n, replace = TRUE, prob = alcohol_prob)
  Physical_Activity <- sample(names(activity_prob), n, replace = TRUE, prob = activity_prob)
  Diet <- sample(names(diet_prob), n, replace = TRUE, prob = diet_prob)
  Stress_Level <- sample(names(stress_prob), n, replace = TRUE, prob = stress_prob)
  Hypertension <- sample(names(hypertension_prob), n, replace = TRUE, prob = hypertension_prob)
  Diabetes <- sample(names(diabetes_prob), n, replace = TRUE, prob = diabetes_prob)
  Hyperlipidemia <- sample(names(hyperlipidemia_prob), n, replace = TRUE, prob = hyperlipidemia_prob)
  Family_History <- sample(names(family_prob), n, replace = TRUE, prob = family_prob)
  Previous_Heart_Attack <- sample(names(prevHA_prob), n, replace = TRUE, prob = prevHA_prob)

  synthetic_data <- data.frame(contData,Gender,Smoking,Alcohol_Intake,
                               Physical_Activity,Diet, Stress_Level,Hypertension,Diabetes,
                               Hyperlipidemia,Family_History,Previous_Heart_Attack)

  # View(synthetic_data)

  full_logistic_reg <- glm(Heart_Disease ~ ., family = binomial, data = heart_dat)

  # Predictions on synthetic data
  synthetic_data <- synthetic_data |>
    mutate(p_hat = predict(full_logistic_reg, newdata = synthetic_data, type = "response"),
           Heart_Disease = ifelse(p_hat >= 0.5, 1, 0))|>
    select(-p_hat)

  return(synthetic_data)

}
