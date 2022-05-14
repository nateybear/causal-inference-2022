read_csv(here("data/NLSY02.csv")) %>%


# A build script that cleans the raw dataset and prepares it for analysis
  mutate(across(starts_with("E"), ~case_when(
  .x < 0   ~ NA_real_,
  .x == 99 ~ NA_real_,
  TRUE     ~ .x
))) %>%
  
  # if you had NAs for the entire year, remove you
  filter(if_any(starts_with("E"), ~!is.na(.x))) %>%
  
  # sum across the months using rowwise
  rowwise() %>%
  mutate(total_arrests = sum(c_across(starts_with("E")), na.rm = TRUE)) %>%
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
  select(race, gender, total_arrests) %>%
  
  # write to a csv
  write_csv(here("data/NLSY02_clean.csv"))







# A script that generates a plot using ggplot and saves it in the figures directory
read_csv(here("data/NLSY02_clean.csv")) %>%
group_by(race, gender) %>%
  summarize(total_arrests = mean(total_arrests)) %>%
  ggplot(aes(race, total_arrests, fill = gender)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(
    x = "Race", 
    y = "Mean Arrests", 
    fill = "Gender",
    title = "Mean Number of Arrests in 2002 by Race and Gender") +
  theme_minimal() +
  scale_fill_economist()
ggsave(here("figures/02arrests_by_racegender.png"), width=8, height=4.5)








# A script that generates a summary table using kableExtra and saves it in the tables directory
# summarize arrests by race and gender
read_csv(here("data/NLSY02_clean.csv")) %>%
group_by(race, gender) %>%
  summarize(total_arrests = mean(total_arrests)) %>%
  
  # pivot the values from race into columns
  pivot_wider(names_from = race, values_from = total_arrests) %>%
  
  # rename columns using snakecase
  rename_with(to_title_case) %>%
  
  # create the kable object. Requires booktabs and float LaTeX packages
  kbl(
    caption = "Mean arrests in 2002 by Race and Gender",
    booktabs = TRUE,
    format = "latex",
    label = "tab:summarystats"
  ) %>%
  kable_styling(latex_options = c("striped", "HOLD_position")) %>%
  
  write_lines(here("tables/02arrests_by_racegender.tex"))







# A script that generates a regression output summary using stargazer and saves it in the tables directory
model <- 
  read_csv(here("data/NLSY02_clean.csv")) %>%
  lm(total_arrests ~ race + gender, data = .)

# Here we supply our own standard errors b/c we want to 
# use heteroskedasticity-robust errors.
se <- model %>% vcovHC %>% diag %>% sqrt

# this is unnecessary, but tidies the coefficient names,
# so that you have "Male" instead of "genderMale" in the table.
# Note that stargazer treats the intercept differently so we drop it (the [-1] part)
covariate.labels <- names(coef(model))[-1] %>% str_replace("(^race)|(^gender)", "")

stargazer(
  model,
  se = list(se),
  covariate.labels = covariate.labels,
  dep.var.labels = "Arrests in 2002",
  out = here("tables/02regress_arrests_by_racegender.tex"),
  title = "Regression Output. Omitted category is Black Females.",
  label = "tab:regression"
)

# A brief report written in LaTeX that summarizes the patterns that you find. Use a formal and descriptive writing style. You will be graded on a genuine attempt at analyzing the results.