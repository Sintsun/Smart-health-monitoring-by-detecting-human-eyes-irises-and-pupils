install.packages("readxl")
library("readxl")
install.packages("ggpubr")
library(ggpubr)
install.packages("BSDA")
library(BSDA)
getwd()
setwd("C:\\Users\\sints\\OneDrive - City University of Hong Kong - Student\\Desktop\\Fyp Test")
path <- "C:\\Users\\sints\\OneDrive - City University of Hong Kong - Student\\Desktop\\Fyp Test\\Fyp Data.xlsx"
df <- read_excel(path)

Screen <- df[1:6, c(1, 6)]
NoScreen <- df[1:6, c(1, 7)]

# Check if the sample follows a normal distribution
# Extract the numeric column from Screen
screen_num <- Screen$Screen

# Extract the numeric column from NoScreen
noscreen_num <- NoScreen$NoScreen

# Perform a sign test
sign_test_result <- binom.test(sum(screen_num > noscreen_num), length(screen_num), p = 0.5, alternative = "two.sided")
print(sign_test_result)

# Perform a Wilcoxon signed-rank test
wilcox_test_result <- wilcox.test(screen_num, noscreen_num, paired = TRUE, alternative = "two.sided")
print(wilcox_test_result)

# Data for Level-10 Ratio
level1_ratio <- df$Level1Ratio
level10_ratio <- df$Level10Ratio

# Extract data for Level 1 HRV and Level 10 HRV
level1_hrv <- df$Level1HRV
level10_hrv <- df$Level10HRV

# Remove NA values
level1_hrv <- na.omit(level1_hrv)
level10_hrv <- na.omit(level10_hrv)

# Remove NA values from Level-10 Ratio data
level1_ratio <- na.omit(level1_ratio)
level10_ratio <- na.omit(level10_ratio)

# Create difference vector
ratio_diff <- level10_ratio - level1_ratio

# Execute a sign test for HRV with a one-sided test, assuming a decrease at level 10
result_hrv <- binom.test(sum(level10_hrv < level1_hrv), length(level1_hrv), alternative = "greater")

# For pupil size one-sided test, assuming increase at level 10
positive_increases <- sum(ratio_diff > 0)
negative_increases <- sum(ratio_diff < 0)
ties <- sum(ratio_diff == 0)
total_non_ties := positive_increases + negative_increases

if (total_non_ties == 0) {
  result_pupil <- NA # Unable to perform test
} else if (positive_increases >= negative_increases) {
  result_pupil <- binom.test(positive_increases, total_non_ties, alternative = "greater")
} else {
  result_pupil <- binom.test(negative_increases, total_non_ties, alternative = "less")
}

# Output results
print("HRV Sign Test Results:")
print(result_hrv)

print("Pupil Size Sign Test Results:")
print(result_pupil)

# Execute Wilcoxon signed rank test
result_hrv <- wilcox.test(level1_hrv, level10_hrv, alternative = "greater")
result_pupil <- wilcox.test(level1_ratio, level10_ratio, alternative = "less")

# Output results
print("HRV Wilcoxon Signed Rank Test Results:")
print(result_hrv)

print("Pupil Size Wilcoxon Signed Rank Test Results:")
print(result_pupil)

# Calculate changes in HRV and pupil size
hrv_change <- level10_hrv - level1_hrv
pupil_change <- level10_ratio - level1_ratio

# Convert changes into binary classification
hrv_binary <- ifelse(hrv_change > 0, "Increase", "Decrease")
pupil_binary <- ifelse(pupil_change > 0, "Increase", "Decrease")

# Create a data frame containing the two binary variables
data_frame <- data.frame(hrv_binary, pupil_binary)

# Create a contingency table
contingency_table <- table(data_frame)

# Display the contingency table
print("Contingency Table:")
print(contingency_table)

# Perform McNemar's test
mcnemar_result <- mcnemar.test(contingency_table)
print("McNemar Test Result:")
print(mcnemar_result)