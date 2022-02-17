# Builds the cleaned NLSY97 dataset on incarceration for analysis
# Read the colwise and rowwise vignettes carefully to understand this code.
# vignette("colwise")
# vignette("rowwise")

library(readr)
library(dplyr)
read_csv("/Users/jirapat/Desktop/R/default/default.csv") %>%
  
  # refused responses or already incarcerated --> NA
  # starts_with("E") are the columns that hold number of arrests per month of 2002
  mutate(across(starts_with("E"), ~case_when(
    .x < 0   ~ NA_real_,
    .x == 99 ~ NA_real_,
    TRUE     ~ .x
  ))) %>%
  
  # if you had NAs for the entire year, remove you
  filter(if_any(starts_with("R"), ~!is.na(.x))) %>%
  
  # sum across the months using rowwise
  rowwise() %>%
  mutate(incarcerated = ifelse(sum(c_across(starts_with("E")), na.rm = TRUE) >= 1, yes = 1, no = 0)) %>%
  ungroup() %>%

  # recode the gender variable
  mutate(gender = if_else(R0536300 == 1, "Male", "Female")) %>%
  
  # recode the race variable
  mutate(race = case_when(
    R1482600 == 1 ~ "Black",
    R1482600 == 2 ~ "Hispanic",
    R1482600 == 3 ~ "Mixed Race (Non-Hispanic)",
    R1482600 == 4 ~ "Non-Black / Non-Hispanic",
  )) %>%
  
  # finally, select the variables that will be used in the analysis
  select(race, gender, incarcerated) %>%
  
  # write to a csv
  write_csv(here("data/default_clean.csv"))