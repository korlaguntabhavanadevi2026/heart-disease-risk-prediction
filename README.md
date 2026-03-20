# 🫀 Heart Disease Risk Prediction Using Lifestyle and Clinical Factors

A statistical analysis project investigating the relationship between clinical and lifestyle risk factors and the likelihood of heart disease, conducted as part of **INFO-B518: Applied Statistics in Biomedical Informatics** at Indiana University's Luddy School of Informatics, Computing, and Engineering.

> **Group 7** | Bhavana Devi Korlagunta | May 2025

---

## 📌 Project Overview

Heart disease remains one of the leading causes of death globally. This project applies a comprehensive statistical pipeline to a dataset of **10,000 patients** to explore how clinical indicators (blood pressure, cholesterol, BMI) and lifestyle factors (smoking, exercise habits, stress levels) relate to heart disease risk.

**Primary Research Hypothesis:**
> At least one lifestyle or clinical factor significantly predicts the likelihood of heart disease.

---

## 📂 Repository Contents

```
├── Heart_disease_-_stats_project.R   # Full R analysis script
├── heart_disease.csv                 # Dataset (10,000 patients, 21 variables)
└── README.md
```

---

## 📊 Dataset

- **Source:** Kaggle (publicly available)
- **Size:** 10,000 observations × 21 variables

### Key Variables Used

| Type | Variables |
|------|-----------|
| **Numerical** | Blood Pressure, Cholesterol Level, BMI |
| **Categorical** | Smoking (Yes/No), Exercise Habits (Low/Medium/High), Stress Level (Low/Medium/High) |
| **Target** | Heart Disease Status (Yes/No → binarized to 1/0) |

---

## 🔬 Methodology

The analysis follows a structured statistical pipeline:

1. **Data Cleaning & Imputation** — Missing values in Blood Pressure, Cholesterol, and BMI were imputed using the **median** (appropriate for non-normal distributions).

2. **Exploratory Data Analysis (EDA)** — Histograms, Q-Q plots, and side-by-side bar plots to visualize distributions and group differences.

3. **Normality Testing** — Shapiro-Wilk tests (n = 5,000 sample) + Q-Q plots confirmed non-normality across all three clinical variables (p < 2.2e-16).

4. **Non-Parametric Tests** — **Mann-Whitney U tests** (Wilcoxon rank-sum) to compare clinical variable distributions between heart disease groups.

5. **Chi-Square Tests** — Assessed associations between categorical lifestyle factors and heart disease status.

6. **Spearman Correlation Analysis** — Evaluated multicollinearity among predictors (all |ρ| < 0.05 — low collinearity confirmed).

7. **Logistic Regression** — Binary logistic regression model predicting heart disease status from all selected predictors.

8. **Odds Ratios & Confidence Intervals** — 95% CIs computed for all regression coefficients.

9. **Proportion Testing** — One-sample proportion test on smoking prevalence.

---

## 📈 Key Results

| Test | Variable | p-value | Finding |
|------|----------|---------|---------|
| Mann-Whitney U | Blood Pressure | 0.1534 | Not significant |
| Mann-Whitney U | Cholesterol Level | 0.8281 | Not significant |
| Mann-Whitney U | BMI | 0.0589 | Borderline (approaching significance) |
| Chi-Square | Smoking | 0.7695 | Not significant |
| Chi-Square | Exercise Habits | 0.8932 | Not significant |
| Chi-Square | **Stress Level** | **0.024** | ✅ Significant |
| Logistic Regression (overall) | All predictors | 0.093 | Marginally non-significant |
| Logistic Regression (BMI) | BMI | ~0.05 | Borderline effect |

- **Stress level** was the only factor with a statistically significant association with heart disease (p = 0.024).
- **BMI** showed a positive trend — higher BMI was associated with a greater predicted probability of heart disease.
- **Smokers** made up 51.3% of the dataset (95% CI: 50.3%–52.3%), statistically different from 50% (p = 0.0105).

---

## 🛠️ Technologies & Libraries

| Tool | Purpose |
|------|---------|
| **R** | Core statistical analysis |
| `ggplot2` | Data visualization |
| `dplyr` | Data manipulation |
| `corrplot` | Correlation heatmaps |
| Base R (`glm`, `wilcox.test`, `chisq.test`, `prop.test`) | Statistical modeling & testing |

---

## 🚀 How to Run

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-username/your-repo-name.git
   cd your-repo-name
   ```

2. **Ensure R is installed** (v4.0+ recommended)

3. **Install required packages** (run once in R console)
   ```r
   install.packages(c("ggplot2", "dplyr", "corrplot"))
   ```

4. **Place the dataset** — Make sure `heart_disease.csv` is in the same directory as the R script.

5. **Run the analysis**
   ```r
   source("Heart_disease_-_stats_project.R")
   ```

---

## 📝 Conclusion

While no single variable was a strong standalone predictor, **stress level** and **BMI** emerged as the most meaningful contributors to heart disease risk in this dataset. The logistic regression model as a whole was marginally non-significant (p = 0.093), likely due to dataset limitations. These findings underscore the need for further research with larger, more diverse populations to clarify these associations and support early prevention strategies.

---

## 👥 Author

- **Bhavana Devi Korlagunta**

*Indiana University — Luddy School of Informatics, Computing, and Engineering*
*INFO-B518: Applied Statistics in Biomedical Informatics*
