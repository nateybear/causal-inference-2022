library(kableExtra)
library(tidyr)
library(dplyr)
library(readr)
library(snakecase)
# Builds a LaTeX table of mean length of incarceration by race and gender.
# See the pivoting vignette for how to use pivot functions.
# vignette("pivot")
# Documentation for the kableExtra package is here:
# https://cran.r-project.org/web/packages/kableExtra/vignettes/awesome_table_in_pdf.pdf

read_csv(here("data/NLSY97_clean.csv")) %>%
  
  # summarize incarceration length by race and gender
  group_by(race, gender) %>%
  summarize(incar_length = mean(incar_length)) %>%
  
  # pivot the values from race into columns
  pivot_wider(names_from = race, values_from = incar_length) %>%
  
  # rename columns using snakecase
  rename_with(to_title_case) %>%
  
  # create the kable object. Requires booktabs and float LaTeX packages
  kbl(
    caption = "Mean length of incarceration in 2002 by Race and Gender",
    booktabs = TRUE,
    format = "latex",
    label = "tab:summarystats"
  ) %>%
  kable_styling(latex_options = c("striped", "HOLD_position")) %>%
  
  write_lines(here("tables/incar_length_by_racegender.tex"))
