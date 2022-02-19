# Builds a bar graph with incar_length on the y axis and race/gender on the
# x axis. Refer to my presentation on graphing for more detail.

read_csv(here("data/NLSY97_clean.csv")) %>%
  group_by(race, gender) %>%
  summarize(incar_length  = mean(incar_length)) %>%
  ggplot(aes(race, incar_length, fill = gender)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(
    x = "Race", 
    y = "Mean Length of Incarceration (months)", 
    fill = "Gender",
    title = "Mean Length of Incarceration in 2002 by Race and Gender") +
  theme_minimal() +
  scale_fill_economist()

ggsave(here("figures/incar_length_by_racegender.png"), width=8, height=4.5)
