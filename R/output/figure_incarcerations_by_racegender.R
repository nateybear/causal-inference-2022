# Builds a bar graph with total arrests on the y axis and race/gender on the
# x axis. Refer to my presentation on graphing for more detail.
library(ggplot2)
library(ggthemes)

read_csv(here("data/default_clean.csv")) %>%
  group_by(race, gender) %>%
  summarize(total_incarcerations = sum(incarcerated)) %>%
  ggplot(aes(race, total_incarcerations, fill = gender)) +
    geom_bar(stat = "identity", position = "dodge") +
    labs(
      x = "Race", 
      y = "Total Number Incarcerations", 
      fill = "Gender",
      title = "Total Number of Incarcerations in 2002 by Race and Gender") +
    theme_minimal() +
    scale_fill_economist()

ggsave(here("figures/incarcerations_by_racegender.png"), width=8, height=4.5)
