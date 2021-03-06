# Summary of GDP Rankings from 2012
Jose Torres, Ruhaab Markas, Megan Hodges  
10/21/2017  

***
### Introduction

***

This document provides a summary of facts about GDP and income data from The World Bank.  The six main questions of interest are:

1. How many countries are included in our GDP data?
2. Which country has the 13th lowest GDP?
3. What are the average comparative GDP rankings for the 'High income: OECD' and 'High income: nonOECD' groups?
4. What does a colored scatterplot of GDP vs income group look like?
5. What does a two-way classification table of GDP quantiles and income look like?
6. Which lower-middle income countries have a GDP that ranks among the 38 highest? 


The data used for this review comes from [The World Bank](http://www.worldbank.org/) and is staged in two CSV files:


* Gross Domestic Product data for 190 ranked Countries ([source file](https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv))
* Income Data by country ([source file](https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv))

The primary variables of interest in this review are the following:

* Short country code
* Country name
* GDP rankings
* Income Group (e.g. low,middle,high)

The two CSV tables need to be merged and cleaned after being downloaded in order to answer any questions of interest.

```r
#Change to your desired project directory

#library(repmis)
#library(data.frame)
#library(ggplot2)

proj_dir = 'C:/Users/Jose/Documents/R/SMU/MSDS_6306/Case_Study'
setwd(proj_dir)

#Download the two CSV files to the working directory
source('get_data.R')

#Merge the GDP and Inc table on country code, and then filter out unwanted rows
#Please review this file for a better understanding of the data frames mentioned in succeeding code snippets
source('merge_tidy.R')
```

***
### Summary

***

#### 1. How many countries are included in our GDP Data?

There are 224 countries that have matching country codes in both the income and GDP data sets.


```r
#The number of countries that had matching country codes in both data frames is the row dimension of the merged data frame
match_count = dim(inc_gdp)[1]
print(match_count)
```

```
## [1] 224
```

#### 2. Which country has the 13th lowest GDP?

Once the data was sorted in ascending order, by GDP, we found the 13th lowest GDP to be St. Kitts and Nevis. One interesting point to note is that there was a tie for the 13th rank in GDP between St. Kitts and Grenada.

```r
#Cast as numeric type so sorting is not performed legt-to-right (e.g. 1000 < 200 < 30 < 4)
inc_gdp_filter$GDP_2012 = as.numeric(inc_gdp_filter$GDP_2012)
inc_gdp_filter = inc_gdp_filter[order(inc_gdp_filter$'GDP_2012'),]
print(paste('The 13th is ',inc_gdp_filter[13,'Short Name']))
```

```
## [1] "The 13th is  St. Kitts and Nevis"
```

#### 3. What are the average comparative GDP rankings for the 'High income: OECD' and 'High income: nonOECD' groups?

Utilizing GDP Rankings and the Income Group we found the average GDP ranks for the following income groups are as follows:
* High Income: OECD = 32.97
* High Income: nonOECD = 91.39

```r
#Get average rankings for certain income groups

gdp_ranks = frank(inc_gdp_filter,-GDP_2012,ties.method='average',na.last='keep')

#Overwrite the ranks column with correct rankings
inc_gdp_filter$Rank = gdp_ranks

#Select the rank subgroups we are interested in
hi_oecd = inc_gdp_filter[inc_gdp_filter$Income_Group=='High income: OECD',]$Rank
hi_nonoecd = inc_gdp_filter[inc_gdp_filter$Income_Group=='High income: nonOECD',]$Rank

mean_rank_oecd = round(mean(hi_oecd),digits=2)
mean_rank_nonoecd = round(mean(hi_nonoecd),digits=2)

print(paste('The mean rank for high income:oecd is ',mean_rank_oecd,'.',sep=''))
```

```
## [1] "The mean rank for high income:oecd is 32.97."
```

```r
print(paste('The mean rank for high income:nonoecd is ',mean_rank_nonoecd,'.',sep=''))
```

```
## [1] "The mean rank for high income:nonoecd is 91.39."
```

#### 4. What does a colored scatterplot of GDP vs income group look like?

Because GDP values are large and have very right-skewed distributions by income group, the chart below presents GDP on a log-base-10 scale, colored by income group.  There is some visual evidence of variability both within each income group and across all income groups.  We did not conduct statistical analyses on the differences of any group means.


```r
gdp_scatter = ggplot(data=inc_gdp_filter,aes(Income_Group,log(GDP_2012,base=10))) + 
  geom_point(aes(color = Income_Group),size=3) +
  xlab('\n Income Group') + ylab('GDP (Log Base 10)\n') + 
  ggtitle(label='Total GDP in 2012 by Income Group') + theme(plot.title=element_text(hjust = .5), axis.text.x=element_blank(),axis.ticks.x=element_blank())
print(gdp_scatter)
```

![](Main_files/figure-html/unnamed-chunk-5-1.png)<!-- -->

#### 5. What does a two-way classification table of GDP quantiles and income look like?

We assume that the 5 quantiles desired are for GDP sorted in ascending order. This way, we can assume that the highest quantile is the group of countries with the highest GDP.


```r
#Cut the GDP ranks by 5 groups with equal number of ranks in each
inc_gdp_filter$RankGroup = cut(inc_gdp_filter$Rank,breaks=5,labels=c('GDP Q5','GDP Q4','GDP Q3','GDP Q2','GDP Q1'))
#Convert the ranks to a factor variable so that a two-way classification table can be created
inc_gdp_filter$Income_Group = as.factor(inc_gdp_filter$Income_Group)
quant_inc_table = table(inc_gdp_filter$RankGroup,inc_gdp_filter$Income_Group)
quant_inc_table
```

```
##         
##          High income: nonOECD High income: OECD Low income
##   GDP Q5                    4                18          0
##   GDP Q4                    5                10          1
##   GDP Q3                    8                 1          9
##   GDP Q2                    4                 1         16
##   GDP Q1                    2                 0         11
##         
##          Lower middle income Upper middle income
##   GDP Q5                   5                  11
##   GDP Q4                  13                   8
##   GDP Q3                  11                   9
##   GDP Q2                   9                   7
##   GDP Q1                  16                   9
```

#### 6. Which lower-middle income countries have a GDP that ranks among the 38 highest? 

Of the 38 countries with the highest GDP, there are 5 countries from the lower middle income category.


```r
#Sort the GDP ranks in descending order to get the top 38 highest GDPs
inc_gdp_filter = inc_gdp_filter[order(inc_gdp_filter$'GDP_2012',decreasing = TRUE),]

#Filter only on lower middle income countries
top_low_mid_inc = subset(x=inc_gdp_filter[1:38,],Income_Group == 'Lower middle income')

top_low_mid_inc[,1:4]
```

```
##     Country_Code Rank Short_Name_GDP_Table GDP_2012
## 37           CHN    2                China  8227103
## 91           IND   10                India  1841710
## 89           IDN   16            Indonesia   878043
## 196          THA   31             Thailand   365966
## 58           EGY   38     Egypt, Arab Rep.   262832
```


***
### Conclusion

***

To conclude, we were able to merge, clean and deliver the following answers, 1) that the 13th lowest GDP is St. Kitts and Nevis. 2) Utilizing GDP Rankings and the Income Group we found the average GDP ranks for the following income groups High Income for OECD = 32.97 and High Income for nonOECD = 91.39. To be able to visually draw data from GDP from 2012 versus Income Group, we delivered a scatterplot that took the Log10 data of GDP in comparison to High Income nonOECD, High Income OECD, Low Income, Lower Middle Income, and Upper Middle Income. And out of the 38 nations with the highest GPA, how many also fall in the Lower Middle Income quantile, we were able to deliver a table that showed 5 counties made that list: India, China, Indonesia, Thailand, and Egypt.
