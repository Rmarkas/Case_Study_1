##########
#merge_tidy.R, last updated 10/22/17
#This file merges the GDP and Income data frames before cleaning up certain columns
#This file must be sourced before any analysis is conducted.
##########

#1. merge GDP data with the income-by-country table by matching country codes in each table.
##  Drop values that do not match
inc_gdp = merge(x=gdp_data,y=inc_data,by.x='V1',by.y='CountryCode',incomparables=NA)

#Count all NAs
countNA =sapply(inc_gdp, function(x) sum(is.na(x)))

#2. Remove empty cols
colLen = dim(inc_gdp)[2]
for (i in colLen:1) {
  if (sum(is.na(inc_gdp[,i]))==length(inc_gdp[,i])) {
    inc_gdp[i] = NULL
  }
}

#3. Rename columns
names(inc_gdp)[1] = 'Country_Code'
names(inc_gdp)[2] = 'Rank'
names(inc_gdp)[3] = 'Short_Name_GDP_Table'
names(inc_gdp)[4] = 'GDP_2012'
names(inc_gdp)[7] = 'Income_Group'

#4. Delete column with blanks
inc_gdp[5] = NULL


#5. Replace any non-numeric GDP values with blanks
inc_gdp$GDP_2012 = gsub('[^0-9]+','',inc_gdp$GDP_2012)

#6. Filter out countries with no GDP
inc_gdp_filter = subset(inc_gdp,GDP_2012 != '')

#7. Remove world/regional aggregates which we are not interested in
inc_gdp_filter = subset(x=inc_gdp_filter,inc_gdp_filter$'WB-2 code' != '')