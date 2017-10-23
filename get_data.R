##########
#get_data.R, last updated 10/22/17
#This file must be sourced before running merge_tidy.R
##########
library(repmis)
library(data.table)
library(ggplot2)

GDPURL = 'https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv'
IncURL = 'https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv'

#Sha-1 for GDP = 18dd2f9ca509a8ace7d8de3831a8f842124c533d
gdp_data = source_data(GDPURL)
#Sha-1 for Income = 20be6ae8245b5a565a815c18a615a83c34745e5e
inc_data = source_data(IncURL)