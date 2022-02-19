# Builds the cleaned NLSY97 dataset on incarceration for analysis
# Read the colwise and rowwise vignettes carefully to understand this code.
# vignette("colwise")
# vignette("rowwise")

read_csv(here("data/NLSY97_raw.csv")) %>%
  
  # refused responses or incarcerated previously but not in current month --> NA
  # starts_with("E") are the columns that show incarceration status per month of 2002
  mutate(across(starts_with("E"), ~case_when(
    .x < 0   ~ NA_real_,
    .x == 99 ~ NA_real_,
    TRUE     ~ .x
  ))) %>%
  
  # if you had NAs for the entire year, remove you
  filter(if_any(starts_with("E"), ~!is.na(.x))) %>%
  
  # sum across the months using rowwise
  rowwise() %>%
  mutate(incar_length = sum(c_across(starts_with("E")), na.rm = TRUE)) %>%
  filter(incar_length > 0) %>%
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
  select(race, gender, incar_length) %>%
  
  # write to a csv
  write_csv(here("data/NLSY97_clean.csv"))