##1. Load required libraries
library(ggplot2)
library(dplyr)
library(corrplot)

##2. Data loading and initial exploration
# Load data
data <- read.csv("heart_disease.csv")


# View structure and check for missing values
str(data)
summary(data)
colSums(is.na(data))

##3. Missing value imputation
# Impute missing clinical values using median as data is not normally distributed
data$Blood.Pressure[is.na(data$Blood.Pressure)] <- median(data$Blood.Pressure, na.rm = TRUE)
data$Cholesterol.Level[is.na(data$Cholesterol.Level)] <- median(data$Cholesterol.Level, na.rm = TRUE)
data$BMI[is.na(data$BMI)] <- median(data$BMI, na.rm = TRUE)
data <- subset(data, 
               Exercise.Habits %in% c("High", "Medium", "Low") &
               Smoking %in% c("Yes", "No") &
               Stress.Level %in% c("High", "Medium", "Low"))


##4. Data transformation
# Convert target variable to binary
data$HeartDiseaseBinary <- ifelse(data$Heart.Disease.Status == "Yes", 1, 0)

# Convert lifestyle variables to factors
data$Smoking <- as.factor(data$Smoking)
data$Exercise.Habits <- as.factor(data$Exercise.Habits)
data$Stress.Level <- as.factor(data$Stress.Level)

##5. Data subsetting
# Subset data for relevant variables
data_subset <- data[, c("Heart.Disease.Status", "HeartDiseaseBinary",
                        "Smoking", "Exercise.Habits", "Stress.Level",
                        "Blood.Pressure", "Cholesterol.Level", "BMI")]



##6. Exploratory data analysis

#a. Histograms
hist(data_subset$Blood.Pressure, col = "skyblue", main = "Blood Pressure", xlab = "BP")
hist(data_subset$Cholesterol.Level, col = "steelblue", main = "Cholesterol", xlab = "Cholesterol")
hist(data_subset$BMI, col = "orchid", main = "BMI", xlab = "BMI")

#b. Q-Q plots
# Q-Q Plot for Blood Pressure
qqnorm(data_subset$Blood.Pressure, main = "Q-Q Plot of Blood Pressure", xlab = "Theoretical Quantiles", ylab = "Sample Quantiles")
qqline(data_subset$Blood.Pressure, col = "red")

# Q-Q Plot for Cholesterol Level
qqnorm(data_subset$Cholesterol.Level, main = "Q-Q Plot of Cholesterol Level", xlab = "Theoretical Quantiles", ylab = "Sample Quantiles")
qqline(data_subset$Cholesterol.Level, col = "red")

# Q-Q Plot for BMI
qqnorm(data_subset$BMI, main = "Q-Q Plot of BMI", xlab = "Theoretical Quantiles", ylab = "Sample Quantiles")
qqline(data_subset$BMI, col = "red")


#c. Bar plots

# Stacked bar plots (proportions)
# List of categorical lifestyle variables
lifestyle_vars <- c("Smoking", "Exercise.Habits", "Stress.Level")

# Side-by-side bar plots (not stacked)
for (var in lifestyle_vars) {
  print(
    ggplot(data_subset, aes_string(x = var, fill = "Heart.Disease.Status")) +
      geom_bar(position = position_dodge()) +
      theme_minimal() +
      labs(
        title = paste(var, "by Heart Disease Status"),
        x = var,
        y = "Count"
      ) +
      scale_fill_manual(values = c("No" = "lightgreen", "Yes" = "red")) +
      theme(axis.text.x = element_text(angle = 45, hjust = 1))
  )
}

##7. Statistical tests

#a. Normality test
# Shapiro-Wilk Test (sampled)
set.seed(123)
shapiro.test(sample(data_subset$Blood.Pressure, 5000))
shapiro.test(sample(data_subset$Cholesterol.Level, 5000))
shapiro.test(sample(data_subset$BMI, 5000))

#b. Group-comparison
# Mann-Whitney U Test (non-parametric)
wilcox.test(Blood.Pressure ~ HeartDiseaseBinary, data = data_subset)
wilcox.test(Cholesterol.Level ~ HeartDiseaseBinary, data = data_subset)
wilcox.test(BMI ~ HeartDiseaseBinary, data = data_subset)

#c.Chi-Square Tests for Lifestyle Factors

chisq.test(table(data_subset$Smoking, data_subset$HeartDiseaseBinary))
chisq.test(table(data_subset$Exercise.Habits, data_subset$HeartDiseaseBinary))
chisq.test(table(data_subset$Stress.Level, data_subset$HeartDiseaseBinary))

##8. Logistic regression modeling
# Logistic Regression
model <- glm(HeartDiseaseBinary ~ Blood.Pressure + Cholesterol.Level + BMI +
               Smoking + Exercise.Habits + Stress.Level,
             data = data_subset, family = binomial())

# Summary & Odds Ratios
summary(model)
exp(coef(model))

##9. Model significance
# Model Deviance-Based Significance Test
null_deviance <- model$null.deviance        # Null model
residual_deviance <- model$deviance         # Fitted model
df_difference <- model$df.null - model$df.residual  # Degrees of freedom

# P-value using Chi-square
p_value <- 1 - pchisq(null_deviance - residual_deviance, df = df_difference)

# Display results
cat("Null Deviance:", null_deviance, "\n")
cat("Residual Deviance:", residual_deviance, "\n")
cat("Degrees of Freedom Difference:", df_difference, "\n")
cat("P-value:", p_value, "\n")


##10. Prediction and visualization
# Predict probabilities
data_subset$predicted_prob <- predict(model, type = "response")

# View sample rows with prediction
head(data_subset[, c("Heart.Disease.Status", "BMI", "predicted_prob")])

ggplot(data_subset, aes(x = BMI, y = predicted_prob, color = Heart.Disease.Status)) +
  geom_point(alpha = 0.1) +  # Make points lighter to reduce clutter
  geom_smooth(method = "loess", se = FALSE) +  # Add a smooth trend line
  labs(title = "Predicted Probability of Heart Disease by BMI",
       x = "BMI", y = "Predicted Probability",
       color = "Heart Disease Status") +
  theme_minimal()

##11. Confidence intervals for proportions

# Count number of smokers (assuming "Yes" means they smoke)
smoker_yes <- sum(data_subset$Smoking == "Yes")
total_patients <- nrow(data_subset)

# 95% Confidence Interval for proportion
prop.test(smoker_yes, total_patients, conf.level = 0.95)

prop.test(smoker_yes, total_patients, p = 0.5, alternative = "two.sided")


##12. Odds ratio and confidence intervals

odds_ratios <- exp(coef(model))
conf_intervals <- exp(confint(model))

# Combine into a table
odds_table <- data.frame(
  Variable = names(odds_ratios),
  OddsRatio = round(odds_ratios, 2),
  CI_Lower = round(conf_intervals[, 1], 2),
  CI_Upper = round(conf_intervals[, 2], 2)
)

print(odds_table)

#odds_summary 
odds_summary <- data.frame(
  OR = odds_ratios,
  Lower = conf_intervals[, 1],
  Upper = conf_intervals[, 2]
)
print(odds_summary)

