# Install and load necessary packages
packages <- c("readxl", "ggpubr", "ez", "dplyr", "reshape2", "coin", "nparld", "gtools")
lapply(packages, library, character.only = TRUE)

# Set working directory
setwd("C:/Users/sints/OneDrive - City University of Hong Kong - Student/Desktop/Fyp Test/FypTest2 Data")

# Read Excel file
path <- "C:/Users/sints/OneDrive - City University of Hong Kong - Student/Desktop/Fyp Test/FypTest2 Data/test 2.xlsx"
data <- read_excel(path)

# Create Condition variable
df_long <- reshape2::melt(data, id.vars = "participants",
                          measure.vars = c("R1Ratio", "R1HRV", "Level1Ratio", "Level1HRV",
                                           "R2Ratio", "R2HRV", "Level15Ratio", "Level15HRV"),
                          variable.name = "Condition", value.name = "Value")

# Repeated measures ANOVA
ratio_aov <- ezANOVA(data = subset(df_long, grepl("Ratio", Condition)),
                     dv = .(Value), wid = .(participants), within = .(Condition), type = 3)
hrv_aov <- ezANOVA(data = subset(df_long, grepl("HRV", Condition)),
                   dv = .(Value), wid = .(participants), within = .(Condition), type = 3)

print(ratio_aov)
print(hrv_aov)

# Function to perform sign test and rank sum test
run_sign_test <- function(data, var1, var2) {
  diff <- sign(data[[var1]] - data[[var2]])
  pos <- sum(diff == 1)
  neg <- sum(diff == -1)
  ties <- sum(diff == 0)
  
  statistic <- min(pos, neg)
  
  if (pos + neg == 0) {
    p_value <- 1
  } else {
    p_value <- 2 * binom.test(statistic, pos + neg, p = 0.5, alternative = "two.sided")$p.value
  }
  
  return(list(statistic = statistic, p_value = p_value))
}
run_rank_sum_test <- function(data, var1, var2) {
  rank_sum_test <- wilcox.test(data[[var1]], data[[var2]], alternative = "two.sided", distribution = "normal")
  return(rank_sum_test)
}

# Perform sign test and rank sum test for Ratio
ratio_tests <- list(
  "R1 vs R2" = list(sign_test = run_sign_test(data, "R1Ratio", "R2Ratio"),
                    rank_sum_test = run_rank_sum_test(data, "R1Ratio", "R2Ratio")),
  "R1 vs Level1" = list(sign_test = run_sign_test(data, "R1Ratio", "Level1Ratio"),
                        rank_sum_test = run_rank_sum_test(data, "R1Ratio", "Level1Ratio")),
  "R1 vs Level15" = list(sign_test = run_sign_test(data, "R1Ratio", "Level15Ratio"),
                         rank_sum_test = run_rank_sum_test(data, "R1Ratio", "Level15Ratio")),
  "R2 vs Level1" = list(sign_test = run_sign_test(data, "R2Ratio", "Level1Ratio"),
                        rank_sum_test = run_rank_sum_test(data, "R2Ratio", "Level1Ratio")),
  "R2 vs Level15" = list(sign_test = run_sign_test(data, "R2Ratio", "Level15Ratio"),
                         rank_sum_test = run_rank_sum_test(data, "R2Ratio", "Level15Ratio")),
  "Level1 vs Level15" = list(sign_test = run_sign_test(data, "Level1Ratio", "Level15Ratio"),
                             rank_sum_test = run_rank_sum_test(data, "Level1Ratio", "Level15Ratio"))
)

# Create data frame to store results of sign test and rank sum test for Ratio
ratio_sign_results <- data.frame(
  Comparison = names(ratio_tests),
  Statistic = sapply(ratio_tests, function(x) if ("sign_test" %in% names(x) && "statistic" %in% names(x$sign_test)) x$sign_test$statistic else NA),
  p.value = sapply(ratio_tests, function(x) if ("sign_test" %in% names(x) && "p_value" %in% names(x$sign_test)) x$sign_test$p_value else NA)
)

ratio_rank_sum_results <- data.frame(
  Comparison = names(ratio_tests),
  Statistic = sapply(ratio_tests, function(x) if ("rank_sum_test" %in% names(x) && "statistic" %in% names(x$rank_sum_test)) x$rank_sum_test$statistic else NA),
  p.value =sapply(ratio_tests, function(x) if ("rank_sum_test" %in% names(x) && "p.value" %in% names(x$rank_sum_test)) x$rank_sum_test$p.value else NA)
)

# Perform sign test and rank sum test for HRV
hrv_tests <- list(
  "R1 vs R2" = list(sign_test = run_sign_test(data, "R1HRV", "R2HRV"),
                    rank_sum_test = run_rank_sum_test(data, "R1HRV", "R2HRV")),
  "R1 vs Level1" = list(sign_test = run_sign_test(data, "R1HRV", "Level1HRV"),
                        rank_sum_test = run_rank_sum_test(data, "R1HRV", "Level1HRV")),
  "R1 vs Level15" = list(sign_test = run_sign_test(data, "R1HRV", "Level15HRV"),
                         rank_sum_test = run_rank_sum_test(data, "R1HRV", "Level15HRV")),
  "R2 vs Level1" = list(sign_test = run_sign_test(data, "R2HRV", "Level1HRV"),
                        rank_sum_test = run_rank_sum_test(data, "R2HRV", "Level1HRV")),
  "R2 vs Level15" = list(sign_test = run_sign_test(data, "R2HRV", "Level15HRV"),
                         rank_sum_test = run_rank_sum_test(data, "R2HRV", "Level15HRV")),
  "Level1 vs Level15" = list(sign_test = run_sign_test(data, "Level1HRV", "Level15HRV"),
                             rank_sum_test = run_rank_sum_test(data, "Level1HRV", "Level15HRV"))
)

# Create data frame to store results of sign test and rank sum test for HRV
hrv_sign_results <- data.frame(
  Comparison = names(hrv_tests),
  Statistic = sapply(hrv_tests, function(x) if ("sign_test" %in% names(x) && "statistic" %in% names(x$sign_test)) x$sign_test$statistic else NA),
  p.value = sapply(ratio_tests, function(x) if ("sign_test" %in% names(x) && "p_value" %in% names(x$sign_test)) x$sign_test$p_value else NA)
)

hrv_rank_sum_results <- data.frame(
  Comparison = names(hrv_tests),
  Statistic = sapply(hrv_tests, function(x) if ("rank_sum_test" %in% names(x) && "statistic" %in% names(x$rank_sum_test)) x$rank_sum_test$statistic else NA),
  p.value = sapply(hrv_tests, function(x) if ("rank_sum_test" %in% names(x) && "p.value" %in% names(x$rank_sum_test)) x$rank_sum_test$p.value else NA)
)

# Set options for number display
options(scipen = 999)

# Print results
print(ratio_sign_results)
print(ratio_rank_sum_results)
print(hrv_sign_results)
print(hrv_rank_sum_results)

# Bar plot for Ratio Mean
ratio_data <- data[, c("participants", "R1Ratio", "R2Ratio", "Level1Ratio", "Level15Ratio")]
ratio_data <- melt(ratio_data, id.vars = "participants")
colnames(ratio_data)[2] <- "Condition"

ggplot(ratio_data, aes(x = Condition, y = value, fill = Condition)) +
  geom_bar(stat = "summary", fun = mean, position = "dodge") +
  labs(title = "Bar Plot for Ratio Mean", x = "Condition", y = "Ratio") +
  theme_bw()

# Bar plot for HRV Mean
hrv_data <- data[, c("participants", "R1HRV", "R2HRV", "Level1HRV", "Level15HRV")]
hrv_data <- melt(hrv_data, id.vars = "participants")
colnames(hrv_data)[2] <- "Condition"

ggplot(hrv_data , aes(x = Condition, y = value, fill = Condition)) +
  geom_bar(stat = "summary", fun = mean, position = "dodge") +
  labs(title = "Bar Plot for HRV Mean", x = "Condition", y = "HRV") +
  theme_bw()

# Violin plot with Boxplot for Ratio
ggplot(subset(df_long, grepl("Ratio", Condition)), aes(x = Condition, y = Value, fill = Condition)) +
  geom_violin(trim = FALSE, scale = "area", adjust = 1, kernel = "gaussian", alpha = 0.6) +
  geom_boxplot(width = 0.1, alpha = 0.6) +
  labs(title = "Violin Plot with Boxplot for Ratio", x = "Condition", y = "Ratio") +
  theme_bw() +
  theme(legend.position = "none")
# Violin plot with Boxplot for HRV
ggplot(subset(df_long, grepl("HRV", Condition)), aes(x = Condition, y = Value, fill = Condition)) +
  geom_violin(trim = FALSE, scale = "area", adjust = 1, kernel = "gaussian", alpha = 0.6) +
  geom_boxplot(width = 0.1, alpha = 0.6) +
  labs(title = "Violin Plot with Boxplot for HRV", x = "Condition", y = "HRV") +
  theme_bw() +
  theme(legend.position = "none")

# Calculate changes in HRV and pupil size from R1 to R2
hrv_changeR1_R2 <- data$R1HRV - data$R2HRV
pupil_changeR1_R2 <- data$R1Ratio - data$R2Ratio

# Convert changes to binary classification
hrv_binary <- ifelse(hrv_changeR1_R2 > 0, "Increase", "Decrease")
pupil_binary <- ifelse(pupil_changeR1_R2 > 0, "Increase", "Decrease")

# Create a data frame containing the two binary variables
data_frame <- data.frame(hrv_binary, pupil_binary)

# Create a contingency table
contingency_table <- table(data_frame)

# Display the contingency table
print("R1 vs R2 Contingency Table:")
print(contingency_table)

# Perform McNemar's test
chisq_result <- mcnemar.test(contingency_table)
print("McNemar Test Result:")
print(chisq_result)

# Calculate changes in HRV and pupil size from R1 to Level 1
hrv_changeR1_1 <- data$R1HRV - data$Level1HRV
pupil_changeR1_1 <- data$R1Ratio - data$Level1Ratio

# Convert changes to binary classification
hrv_binary <- ifelse(hrv_changeR1_1 > 0, "Increase", "Decrease")
pupil_binary <- ifelse(pupil_changeR1_1 > 0, "Increase", "Decrease")

# Create a data frame containing the two binary variables
data_frame <- data.frame(hrv_binary, pupil_binary)

# Create a contingency table
contingency_table <- table(data_frame)

# Display the contingency table
print("R1 vs Level1 Contingency Table:")
print(contingency_table)

# Perform McNemar's test
chisq_result <- mcnemar.test(contingency_table)
print("McNemar Test Result:")
print(chisq_result)

# Calculate changes in HRV and pupil size from R1 to Level 15
hrv_changeR1_15 <- data$R1HRV - data$Level15HRV
pupil_changeR1_15 <- data$R1Ratio - data$Level15Ratio

# Convert changes to binary classification
hrv_binary <- ifelse(hrv_changeR1_15 > 0, "Increase", "Decrease")
pupil_binary <- ifelse(pupil_changeR1_15 > 0, "Increase", "Decrease")

# Create a data frame containing the two binary variables
data_frame <- data.frame(hrv_binary, pupil_binary)

# Create a contingency table
contingency_table <- table(data_frame)

# Display the contingency table
print("R1 vs Level15 Contingency Table:")
print(contingency_table)

# Perform McNemar's test
chisq_result <- mcnemar.test(contingency_table)
print("McNemar Test Result:")
print(chisq_result)

# Calculate changes in HRV and pupil size from R2 to Level 1
hrv_changeR2_1 <- data$R2HRV - data$Level1HRV
pupil_changeR2_1 <- data$R2Ratio - data$Level1Ratio

# Convert changes to binary classification
hrv_binary <- ifelse(hrv_changeR2_1 > 0, "Increase", "Decrease")
pupil_binary <- ifelse(pupil_changeR2_1 > 0, "Increase", "Decrease")

# Create a data frame containing the two binary variables
data_frame <- data.frame(hrv_binary, pupil_binary)

# Create a contingency table
contingency_table <- table(data_frame)

# Display the contingency table
print("R2 vs Level1 Contingency Table:")
print(contingency_table)

# Perform McNemar's test
chisq_result <- mcnemar.test(contingency_table)
print("McNemar Test Result:")
print(chisq_result)

# Calculate changes in HRV and pupil size from R2 to Level 15
hrv_changeR2_15 <- data$R2HRV - data$Level15HRV
pupil_changeR2_15 <- data$R2Ratio - data$Level15Ratio

# Convert changes to binary classification
hrv_binary <- ifelse(hrv_changeR2_15 > 0, "Increase", "Decrease")
pupil_binary <- ifelse(pupil_changeR2_15 > 0, "Increase", "Decrease")

# Create a data frame containing the two binary variables
data_frame <- data.frame(hrv_binary, pupil_binary)

# Create a contingency table
contingency_table <- table(data_frame)

# Display the contingency table
print("R2 vs Level15 Contingency Table:")
print(contingency_table)

# Perform McNemar's test
chisq_result <- mcnemar.test(contingency_table)
print("McNemar Test Result:")
print(chisq_result)

# Calculate changes in HRV and pupil size from Level 1 to Level 15
hrv_change1_15 <- data$Level1HRV - data$Level15HRV
pupil_change1_15 <- data$Level1Ratio - data$Level15Ratio

# Convert changes to binary classification
hrv_binary <- ifelse(hrv_change1_15 > 0, "Increase", "Decrease")
pupil_binary <- ifelse(pupil_change1_15 > 0, "Increase", "Decrease")

# Create a data frame containing the two binary variables
data_frame <- data.frame(hrv_binary, pupil_binary)

# Create a contingency table
contingency_table <- table(data_frame)

# Display the contingency table
print("Level1 vs Level15 Contingency Table:")
print(contingency_table)

# Perform McNemar's test
chisq_result <- mcnemar.test(contingency_table)
print("McNemar Test Result:")
print(chisq_result)





