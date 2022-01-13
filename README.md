# R Hidden Curriculum Assignment

Your assignment is to replicate this GitHub repository and produce a report that describes patterns in INCARCERATION STATUS by race and gender in the year 2002, using NLSY97 publicly available data. To do this, you will need to create a data extract at the [NLSY Investigator](https://www.nlsinfo.org/investigator/pages/search) website that pulls the variables of interest. Here is a screenshot to help you out:

![](https://raw.githubusercontent.com/nateybear/causal-inference-2022/main/writing/rdemo_assets/NLSY97%20Investigator.png)

MAKE SURE to read the Codebook tab to understand how your variables are coded!

Navigate to the Save/Download tab and use the Advanced Download feature to download a comma-delimited file (CSV). You may download the RData file instead if you wish, but my example code uses CSV files.

# Grading

The deliverable that you turn into Canvas will be a URL linking to your GitHub repository. You will be graded based on having all of the following in your GitHub repository:

* A build script that cleans the raw dataset and prepares it for analysis
* A script that generates a plot using `ggplot` and saves it in the figures directory
* A script that generates a summary table using `kableExtra` and saves it in the tables directory
* A script that generates a regression output summary using `stargazer` and saves it in the tables directory
* A brief report written in LaTeX that summarizes the patterns that you find. You are expected to use a formal and descriptive writing style, and you will lose points here if you do not make a genuine attempt at analyzing the results.
