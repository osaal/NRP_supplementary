# Clear environment first
rm(list=ls())
resetpar <- par(no.readonly = TRUE)

# Set seed for bootstrapping reproduction
set.seed(12345)

# Setup directories and libraries
packages <- c(
  "tidyverse", "naniar", "psychonetrics", "bootnet"
)
lapply(packages, library, character.only = TRUE)

# Load data
data <- tibble(read.csv2("emergencyservicesattitudes2023.csv"))
# NB: The dataset cannot be published due to respondent privacy rights and a lack of publication consent.

# Rename variables
data <- data %>%
  dplyr::rename(
    Weather = question_3_row_1,
    Traffic = question_3_row_2,
    Fire = question_3_row_3,
    Nuclear = question_3_row_4,
    Work = question_3_row_5,
    Leisure = question_3_row_6,
    War = question_3_row_7,
    Environmental = question_3_row_8,
    Pandemic = question_3_row_9,
    Illness = question_3_row_10,
    Violence = question_3_row_11,
    Operational = question_3_row_12,
    Hybrid = question_3_row_13,
    Polarization = question_3_row_14,
    Fire_Exp = question_25_row_1,
    Traffic_Exp = question_25_row_2,
    Accident_Exp = question_25_row_3,
    Rescue_Exp = question_25_row_4,
    Leisure_Exp = question_25_row_5,
    Work_Exp = question_25_row_6,
    Illness_Exp = question_25_row_7,
    Inspection_Exp = question_25_row_8,
    Education_Exp = question_25_row_9,
    Event_Exp = question_25_row_10,
    Internet_Exp = question_25_row_11,
    Other_Exp = question_25_row_12,
    No_Experience = question_25_row_13,
    CannotSay_Exp = question_25_row_14
  )

# Recode risk perception variables
data <- data %>%
  dplyr::mutate(
    across(
      Weather:Polarization,
      ~case_match(
        .,
        1 ~ 4,
        2 ~ 3,
        3 ~ 2,
        4 ~ 1
      )
    )
  )

# Assing missing values
data <- data %>%
  naniar::replace_with_na_all(., condition = ~.x == 5)

# Constructing the experience group
exp.variables <- c("Fire_Exp", "Traffic_Exp", "Accident_Exp", "Rescue_Exp", "Leisure_Exp", "Work_Exp", "Illness_Exp")
experience <- rowSums(data[, exp.variables]) %>%
  tibble() %>%
  dplyr::mutate(across(everything(), function(x) ifelse(x >= 1, 1, 0))) %>%
  rename(., Experience.Dichotomy = ".")

# Bind experience to main dataset
data <- dplyr::bind_cols(data, experience)
