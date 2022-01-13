# Builds a LaTeX table of regression output using the stargazer package.
# Here we supply our own standard errors b/c we want to 
# use heteroskedasticity-robust errors.

model <- 
  read_csv(here("data/NLSY97_clean.csv")) %>%
  lm(total_arrests ~ race + gender, data = .)

se <- model %>% vcovHC %>% diag %>% sqrt

stargazer(
  model,
  se = se,
  out = here("tables/regress_arrests_by_racegender.tex"),
  title = "Regression Output of Total Arrests by Race and Gender"
)