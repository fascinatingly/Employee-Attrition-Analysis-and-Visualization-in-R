#Data Analysis and Visualization of Employee_Attrition.csv Dataset using R and RStudio - (includes Preprocessing, exploration, manipulation, transformation, and visualization)




install.packages("rio")
install.packages("ggplot")
install.packages("magrittr")
install.packages("dplyr")
install.packages("ggplot2")
install.packages("stringr")
require(rio)
require(dplyr)
require(magrittr)
require(ggplot2)
require(stringr)
require(facetscales)


# import the employee_attrition.csv file through rio
#df <- import("C:/Users/user/Documents/_RStudio/employee_attrition.csv")
setwd("C:/Users/amal/Documents/_RStudio/Bleed2")
df <- read.csv("employee_attrition.csv")
# summary(df)
# Another way of importing this csv file would utilize double backslashes
###df <- import("C:\\Users\\user\\Documents\\_RStudio\\employee_attrition.csv")


# We have four objectives to fulfill:
## I- Data Exploration
## II- Data Manipulataion
## III- Data Transformation
## IV- Data Visualization



#data cleaning

## 

df1 <- data.frame(df)
#Currently the data has numerous records of the same id but from different record dates.
#It appears an entirely new row is added instead of updating an employee's existing row.


#The simplest way to acheive deduplication by id would be removing all rows with duplicated ids 
#EXCEPT the last row with that id
#The last row needs to be the most recent one.
#in order to ensure the last row is, indeed, the most updated one, we first sort the data frame by id and age (years_of_service can be used instead of age)

df1 <- arrange(df1, EmployeeID, length_of_service)

j = 0
k = 0
indices_of_out_of_date_emp_records <- NULL
for (i in 1:length(df1$EmployeeID)) {
  j = i + 1
  #Something interesting about R is the comparison between NULL and anything else
  #NULL is considered a 0-length object, 
  #R documentation states that any and all comparisons and operations (arithmetic or otherwise) 
  #with a 0-length object return a 0-length object
  #Thus, with j being i + 1 (the next element after i), the last j element is NULL because it's outside the
  #df1$EmployeeID value range
  #if(df1$EmployeeID[i] == df1$EmployeeID[j]) needs to be performed after checking that j isn't beyond column length
  if(i == length(df1$EmployeeID)) { # j would be outside EmployeeID range and, thus, NULL
    break 
  }
  if(df1$EmployeeID[i] == df1$EmployeeID[j]) {
    k = k + 1
    indices_of_out_of_date_emp_records[k] <- i
  }
}
length(indices_of_out_of_date_emp_records)
#Remove all but 1 row with the same IDs.
df1 <- df1[-indices_of_out_of_date_emp_records,]

## 1.2 - Full-scale data validation

df2 <- data.frame(df1)
#Note about df, df1, df2, df3....
#Whilst writing this code, it occured to me
#It is by no means the brightest method but it fully served its purpose. 
#All memory they take up will be freed henceforth upon new dataframe variable definition.
df1 <- NULL
#I see no real reason to mass-replace all back into df (df1,df2,df3 > df) and it is a simple ctrl+f shortcut away.
#Thus, naming shall remain this way until a valid reason emerges.

#A real benefit of keeping this dataframe naming is being able to quickly and concurrently work with 
#different versions of the data frame during visualization and analysis;
#One can swiftfly obtain all out-of-date record rows from df (all 49653 rows are storable in it) without hassle.
#The same goes for df1 and df2, all versions easily returned to with no compromise.
#If all were named df, one would need copy the desired process and replace df with another variable name before
#being able to concurrently work with df and the current, most-modified version

#DATA VALIDATION OBJECTIVES TO BE DONE:

#TODOCOMPLETE-1: Why on Earth is store_name column numeric? What is it referring to?
#TODOCOMPLETE-2: KEEP IN MIND termreason_desc and termtype_desc both have Not Applicable instead of NA. This makes sense due to both columns describing something about termination and, as such, use character as type.
#TODOCOMPLETE-2.2: termreason_desc and termtype_desc can be checked for mutual consistency.
#TODOCOMPLETE-5: check length_of_service consistency with orighiredate_key
#TODOCOMPLETE-7: a question that is applicable to every city: did we fire all our <job_title>? Are we out of <job_title>s? This is acceptable if an entire department in a city is terminated as there are valid reasons to support that (closing down the branch in a certain city and such)
#TODOCOMPLETE-8: the same question is applicable on a general scale larger than individually by city: collect thoroughly descriptive statistics of job_title and job_department (active-to-terminated ratio, job-to-job ratio, department-to-department ratio, )

#TODOCOMPLETE-6: iterate through termreason_desc and termtype_desc to check every row for mutual consistency (i.e. Layoff - Involuntary, Retirement - Voluntary, Not Applicable - Not Applicable)
count_of_terminated_emp_with_consistent_termreason_and_termtype = 0
count_of_terminated_emp_with_inconsistent_termreason_and_termtype = 0
indices_of_terminated_emp_with_consistent_termreason_and_termtype = NULL
indices_of_terminated_emp_with_inconsistent_termreason_and_termtype = NULL
for (i in 1:length(df2$termreason_desc)) {
  if ((df2$termreason_desc[i] == "Layoff" & df2$termtype_desc[i] == "Involuntary" | df2$termreason_desc[i] == "Resignation" & df2$termtype_desc[i] == "Voluntary" | df2$termreason_desc[i] == "Retirement" & df2$termtype_desc[i] == "Voluntary" | df2$termreason_desc[i] == "Not Applicable" & df2$termtype_desc[i] == "Not Applicable")) {
    count_of_terminated_emp_with_consistent_termreason_and_termtype = count_of_terminated_emp_with_consistent_termreason_and_termtype + 1
    indices_of_terminated_emp_with_consistent_termreason_and_termtype[count_of_terminated_emp_with_consistent_termreason_and_termtype] = i
    temp <- df2$termreason_desc[indices_of_terminated_emp_with_consistent_termreason_and_termtype]
    temp2 <- df2$termreason_desc

  }
  else {
    count_of_terminated_emp_with_inconsistent_termreason_and_termtype <- count_of_terminated_emp_with_inconsistent_termreason_and_termtype + 1
    indices_of_terminated_emp_with_inconsistent_termreason_and_termtype[count_of_terminated_emp_with_inconsistent_termreason_and_termtype] <- i
  }
}
#to check if 100% consistency has been achieved...actually overall consistency percentage:
#this would only work if no duplicate rows exist, which is the case in all versions of this data frame 
#because even df with its out-of-date columns has no duplicate rows.
consistency_count <- length(temp)
for(i in length(temp)) {
  for (j in length(temp2)) {
    if(temp[i] == temp2[j]) {
      consistency_count <- consistency_count - 1
      #continue #would prevent us from seeing if this goes beyond length(temp) which it shouldn't so we run all iterations
    }
  }
}
consistency_percentage <- consistency_count / (length(temp) - 1) * 100
consistency_percentage


count_of_terminated_emp_with_consistent_termreason_and_termtype
count_of_terminated_emp_with_inconsistent_termreason_and_termtype
#indices_of_terminated_emp_with_consistent_termreason_and_termtype
#indices_of_terminated_emp_with_inconsistent_termreason_and_termtype


(cbind(df2$termreason_desc[indices_of_terminated_emp_with_inconsistent_termreason_and_termtype], df2$termtype_desc[indices_of_terminated_emp_with_inconsistent_termreason_and_termtype]))
#Oh, there's a spelling error (resignaton should be resignation) These incorrectly-spelled indices shall be modified.
df2$termreason_desc[indices_of_terminated_emp_with_inconsistent_termreason_and_termtype] = "Resignation"
#To check if this spelling error persists across the entire column in addition to these indices_of_terminated_emp_with_inconsistent_termreason_and_termtype
length(df2[df2$termreason_desc %in% "Resignaton"]) #or length(df2$termreason_desc[df2$termreason_desc == "Resignaton"])
#no other "Resignaton" occurences.

#Now, by resetting the variable values and rerunning the previous loop, inconsistencies found go down are zero.




#TODOCOMPLETE-3 loop through gender_short and gender_full, check that they are mutually consistent per row
{ 
nrow(df2)
str(df2$gender_short)
str(as.factor(df2$gender_short))


temp = NULL
for (i in 1:nrow(df2)) {
  if (df2$gender_short[i] == 'M') {
    if (df2$gender_full[i] == 'Male') {
      temp[i] = TRUE
    }
  }
  else if (df2$gender_short[i] == 'F') {
    if (df2$gender_full[i] == 'Female') {
      temp[i] = TRUE
    }
  }
  else {temp[i] = FALSE}
}

(cbind(df2$gender_full[!temp], df2$gender_short[!temp])) #using View(), length(), str(), or nothing would still show an empty container (matrix)

#Such consistency, much wow.


#Another way to do this that requires less lines of code but the same logic:
for ( i in 1:nrow(df2)) {
  if ((df2$gender_short[i] == 'M' & df2$gender_full[i] == 'Male') | (df2$gender_short[i] == 'F' & df2$gender_full[i] == 'Female')) {
    temp[i] = TRUE
  }
  else {temp[i] = FALSE}
}
typeof(temp)
#Temp was once returned as a character vector, to ensure we are always dealing with a logical vector:
temp <- as.logical(temp)

if (sum(!is.na(df2$gender_short[temp])) == nrow(df2)) {
  cat("All rows seem to have consistent gender values in both gender_short and gender_full columns.")
}

}


  

#IMPORTANT
#Custom abbrevations utilized for easier readability:
#los: length_of_service (edit: so far, los has not been used for variable naming.) (might be used a lot when comparing with year_diff(terminationdate_key, orighiredate_key) output for consistency)
#emp: employee
# i, j, and k are used as incremental (or decremental) indices for for-loops. 




#as.Date(df2$recorddate_key, format = "%m/%d/%Y")
#Since the defaults in R won't do my bidding,

year_diff <- function(date1, date2) {
  #date formatting first
  #all dates in the dataset are in the format %m/%d/%Y (recorddate_key 
  #has time as well but since all other dates have no time, timex operations 
  #would be irrelevant for date calculation.{we will never get a negative time that will 
  #decrement day which might decrement month -> decrement year 
  #because only 1 column with time; no other column with time to subtract from it})  
  #TODOCOMPLETE: Additionally, it is always set to 0:00, making it redundant)
  date1 <- as.Date(date1, "%m/%d/%Y")
  date2 <- as.Date(date2, "%m/%d/%Y")
  #cat("\n date1 = ", date1)
  #cat("\n date2 = ", date2)
  
  d1 <- as.numeric(c(format(date1, "%d"), format(date1, "%m"), format(date1, "%Y")))
  d2 <- as.numeric(c(format(date2, "%d"), format(date2, "%m"), format(date2, "%Y")))
  #part-by-part simple subtraction second
  #cat("\n",d1, " -> d1\n")
  #cat("\n",d2, " -> d2\n")
  
  
  result <- as.numeric(d1) - as.numeric(d2)
  if (result[1] < 0) {
    result[2] <- result[2] - 1
    result[1] <- result[1] + 30 #30-ish days in a month (function's real task is fullfuilled regardless of adjustment to every month's length)
    #This is reductionist because there 27/28 days in February as well as 31 days in certain months 
    #but such functionality is utterly irrelevant to the task this function achieves.
  }
  if (result[2] < 0) {
    result[3] <- result[3] - 1
    result[2] <- result[2] + 12 #12 months in a year
  }
  
  #the resulting year is returned here instead of cat()
  #it has to be one or the other, NOT both.
  #cat(d1, " - ", d2, " = ", result)
  
  result[3]
}



###after getting tempv

#In order to get a better display of what exactly year_diff() is doing, another function print_year_diff, will be created to show the under-the-hood process year_diff() goes through per pair of arguments entered to it.
print_year_diff <- function(date1, date2) {
  date1 <- as.Date(date1, "%m/%d/%Y")
  date2 <- as.Date(date2, "%m/%d/%Y")
  #cat() functions can be uncommented for troubleshooting with the function. They're quite helpful for debugging.
  #cat("\n date1 = ", date1)
  #cat("\n date2 = ", date2)
  
  d1 <- as.numeric(c(format(date1, "%d"), format(date1, "%m"), format(date1, "%Y")))
  d2 <- as.numeric(c(format(date2, "%d"), format(date2, "%m"), format(date2, "%Y")))
  #part-by-part simple subtraction second
  #cat("\n",d1, " -> d1\n")
  #cat("\n",d2, " -> d2\n")
  
  result <- as.numeric(d1) - as.numeric(d2)
  if (result[1] < 0) {
    result[2] = result[2] - 1 
    result[1] <- result[1] +30 #30-ish days in a month
  }
  if (result[2] < 0) {
    result[3] = result[3] - 1
    result[2] <- result[2] + 12 #12 months in a year
  }
  
  #cat() is returned instead of result,
  #It has to be one or the other, NOT both.
  cat(d1, " - ", d2, " = ", result)
  
  #result[3]
  
}
#(making this a seperate function was necessitated due to a later issue arising when attempting to return a single value, result[3], after cat(). This way, it's conveniently available whenever necessary.)


#what requires year_diff()?

###COMPARE AGE WITH RECORDDATE_KEY,BIRTHDATE_KEY
#TODO-4: loop through birthdate_key and extract age, compare that extracted age with age column

is_consistent_with_age = NULL
consistent_age_indices = NULL
inconsistent_age_indices = NULL
j = 1
k = 1
for (i in 1:nrow(df2)) {
  if (year_diff(df2$recorddate_key[i], df2$birthdate_key[i]) == df2$age[i]) {
    is_consistent_with_age[i] = TRUE
    consistent_age_indices[j] <- i
    j = j + 1
  }
  else {
    is_consistent_with_age[i] = 
    inconsistent_age_indices[k] = i
    k = k + 1
  }
}
sum(!is.na(inconsistent_age_indices))
#consistent_age_indices
#inconsistent_age_indices
#__________________________________________________________________________________________________
#prerequisite: inconsistent_age_indices having logical values of the df2 rows where year_diff(df2$recorddate_key[inconsistent_age_indices[i]], df2$birthdate_key[inconsistent_age_indices[i]]) is inconsistent with df2$age[inconsistent_age_indices[i]]
tempv <- NULL
tempv <- which(!temp)
sum(temp[tempv])



length(tempv)
tempv

sum(!temp)
for(i in 1:length(inconsistent_age_indices)) {
  cat(year_diff(df2$recorddate_key[inconsistent_age_indices[i]], df2$birthdate_key[inconsistent_age_indices[i]]), " & ", df2$age[inconsistent_age_indices[i]], "\n")
}
#These seem to be merely 1-year differences. (length_of_service is greater than the year_diff() result by 1)
#To confirm,
one_year_difference <- 0
for(i in 1:length(inconsistent_age_indices)) {
  if(year_diff(df2$recorddate_key[inconsistent_age_indices[i]], df2$birthdate_key[inconsistent_age_indices[i]]) == df2$age[inconsistent_age_indices[i]] - 1) {
    one_year_difference <- one_year_difference + 1
  }
}
one_year_difference
one_year_difference == length(inconsistent_age_indices)
#all of them are 1-year differences
#Again, could be attributed to a rounding up mechanism or other plausible causes.
#For the sake of utmost precision and consistency, these +1 differences will be subtracted 1 from to match the rest of the rows.
for(i in 1:length(inconsistent_age_indices)) {
  if(year_diff(df2$recorddate_key[inconsistent_age_indices[i]],df2$birthdate_key[inconsistent_age_indices[i]]) + 1 == df2$length_of_service[inconsistent_age_indices[i]]) {
    df2$age[inconsistent_age_indices[i]] <- df2$age[inconsistent_age_indices[i]] + 1
  }
}

#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^



#By using the following loop structure and reinitializations, I concluded from the output that the value from year_diff() is the more accurate representation of age rather than what is in the age column in df2.
for (i in 1:length(inconsistent_age_indices)) { #temv here stands for all indices of rows in which age is inconsistent with year_diff(recorddate_key, birthdate_key)
  cat(year_diff(df2$recorddate_key[inconsistent_age_indices[i]], df2$birthdate_key[inconsistent_age_indices[i]]), df2$age[inconsistent_age_indices[i]],"\n")
}
#I can think of two reasons for this: 
#1st is that age was rounded off for these employees. 
#2nd is that employees considered their age 1 upon birth and thus gave a year_diff()+1 value for their age when they first joined the company 
#(this is unlikely to be the same reason for terminationdate_key year_diff(), that from previously is likely a cause of rounding values)  
#actually, let's test the same form of loop structure on the year_diff(terminationdate_key, orighiredate_key) consistency with length_of_service


updated_age_count <- 0
tempv <- inconsistent_age_indices
for(i in 1:length(tempv)) {
  if(year_diff(df2$recorddate_key[tempv[i]],df2$birthdate_key[tempv[i]]) == df2$age[tempv[i]] - 1) {
    df2$age[tempv[i]] <- df2$age[tempv[i]] - 1
    updated_age_count <- updated_age_count + 1 #counter of how many times successful change occured. 
  }
} #add 1 to all inconsistent age column rows, getting them by tempv
updated_age_count
updated_age_count <- NULL

updated_age_count <- 0
for(i in 1:length(inconsistent_age_indices)) {
  if(df2$age[inconsistent_age_indices[i]] != year_diff(df2$recorddate_key[inconsistent_age_indices[i]], df2$birthdate_key[inconsistent_age_indices[i]])) {
    df2$age[inconsistent_age_indices[i]] <- year_diff(df2$recorddate_key[inconsistent_age_indices[i]], df2$birthdate_key[inconsistent_age_indices[i]])
    updated_age_count <- updated_age_count + 1
  }
}
updated_age_count
updated_age_count <- NULL
#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

consistent_count = 0
inconsistent_count = 0
not_terminated_count = 0
#is_inconsistent_with_los <- as.vector(as.logical()) #no need for as.vector() because variables in R already have vector properties. Additionally, an empty as.logical() returns an empty logical vector. 
is_inconsistent_with_los <- as.logical()
for(i in 1:length(df2$STATUS_YEAR)) {
  if(df2$terminationdate_key[i] == "1/1/1900") {
    not_terminated_count = not_terminated_count + 1
    #something's happening here and I don't know what it is
    next
  }
  temp <- year_diff(df2$terminationdate_key[i], df2$orighiredate_key[i])
  cat("\nlos = ", df2$length_of_service[i], " & year_diff = ", temp)
  if (df2$length_of_service[i] == temp) {
    is_inconsistent_with_los[i] <- FALSE #los = length_of_service (df2$length_of_service)
    consistent_count <- consistent_count + 1
  }
  else {
    is_inconsistent_with_los[i] <- TRUE
    inconsistent_count = inconsistent_count + 1
  }
} #initialize tempv as an empty logical vector, add to is_inconsistent_with_los true if yeardiff(terminationdate_key, orighiredate_key) = los[i] and cat() los & year_diff()
#counts true and false in consistent_count and inconsistent_count



# I don't understand how length_of_service would be 0, less than/greater than year_diff after all this
# This is a discrepancy.
j = 1
tempv = NULL
for(i in 1:length(df2$length_of_service)) {
  if(df2$length_of_service[i] == 0) {
    # append(tempv[j],i)
    tempv[j] <- i
    j = j + 1
  }
} #get and view all los that equal 0
length(tempv)
inconsistent_count
consistent_count
not_terminated_count
tempv
for(i in 1:length(tempv)) {
  cat(print_year_diff(df2$terminationdate_key[tempv[i]], df2$orighiredate_key[tempv[i]]),"|||",df2$length_of_service[tempv[i]], "\n")
}
#View(df2[tempv,])
#From this cat() loop and View(), we can see that rows with values 0 in length_of_service were terminated before being employed for an entire year. Thus, length_of_service = 0

#TODO: oh....why would someone be terminated so early? If the termtype_desc was layoff, then there likely is a problem.

count = 0
for(i in 1:length(df2$length_of_service)) { 
  if(!is.na(tempv[i])) {
    if(tempv[i] != FALSE) { 
      cat("\nlos = ", df2$length_of_service[i], " & year_diff = ", year_diff(df2$terminationdate_key[i], df2$orighiredate_key[i]))
      count = count + 1
    }
  }
} #ensure tempv is not na and then cat(los & year_diff(df2$terminationdate_key & df2$orighiredate_key))



#______________________________________________________________________








#INCONSISTENT los and orighiredate & termdate year_diff() are examined here by 
#getting them and then viewing a data frame that includes them.

j = 1
k = 1
unterminated_emp_indices = NULL
terminated_emp_indices_with_inconsistent_length_of_service = NULL
inconsistent_length_of_service_indices = NULL
inconsistent_year_diff_v = NULL
for(i in 1:length(df2[,1])) {
  if(df2$terminationdate_key[i] != "1/1/1900") {
    if(year_diff(df2$terminationdate_key[i], df2$orighiredate_key[i]) != df2$length_of_service[i]) {
      terminated_emp_indices_with_inconsistent_length_of_service[j] = i
      inconsistent_length_of_service_indices[j] <- i
      inconsistent_year_diff_v[j] <- year_diff(df2$terminationdate_key[i], df2$orighiredate_key[i])
      j = j + 1
    }
  }
  else {
    unterminated_emp_indices[k] <- i
    k = k + 1
  }
}
length(terminated_emp_indices_with_inconsistent_length_of_service)
length(inconsistent_length_of_service_indices)

for( i in 1:length(inconsistent_length_of_service_indices)) {
  cat(df2$length_of_service[inconsistent_length_of_service_indices[i]], inconsistent_year_diff_v[i], "\n")
}
for(i in 1:nrow(df2)) {
  if(df2$terminationdate_key[i] != "1/1/1900") {
    if(year_diff(df2$terminationdate_key[i], df2$orighiredate_key[i]) != df2$length_of_service[i]) {
      print_year_diff(df2$terminationdate_key[i], df2$orighiredate_key[i])
      cat("  VERSUS   ", df2$length_of_service[i], " \n")
    }
  }
}
#It's starting to seem to me like length_of_service is incremented when the month from orighiredate_key is passed instead of the day.


print_year_diff(df2$terminationdate_key[i], df2$orighiredate_key[i])
#what we can see from this is:
#Rows with length_of_service of 0 are valid rows as they simply have not yet passed the 1 year mark.
#That means they are valid.
#TODOCOMPLETE-A: 4800 entries have not been terminated, corresponding to 4800 employees.
#SOLUTION: Without a valid termination date, one can utilize recorddate_key.
#TODOCOMPLETE-B: Most, if not all 800 different pairs of length_of_service and year_diff() outputs are in a margin of one. 
#This could be inaccurate input to table or an issue with year_diff() [year_diff() will be tested later and turn out to correctly serve its purpose with no issues causing this] 
#or by way of a mechanism of rounding to the nearest year.
#These will be addressed after checking the consistency of the unterminated 4800 employees.

#Next, we work on A-(the 4800 rows of unterminated employees) and then B-(800 rows with 1-year difference)
#To work around b where 4800 entries have not been terminated, 
#the difference between recorddate_key and orighiredate_key is compared with length_of_service
is_consistent_in_length_of_service = NULL
active_emp_indices_with_consistent_length_of_service = NULL
active_emp_indices_with_inconsistent_length_of_service = NULL
terminated_emp_indices <- NULL
terminated_emp_count <- 0
one_year_difference <- 0

j = 1
k = 1
l = 1
for (i in 1:length(df2$recorddate_key)) {
  if (df2$terminationdate_key[i] == "1/1/1900") {
    if (year_diff(df2$recorddate_key[i],df2$orighiredate_key[i]) == df2$length_of_service[i]) {
      active_emp_indices_with_consistent_length_of_service[j] = i
      is_consistent_in_length_of_service[i] = TRUE
      j = j + 1
    }
    else {
      is_consistent_in_length_of_service[i] = FALSE
      active_emp_indices_with_inconsistent_length_of_service[k] = i
      k = k + 1
      cat(year_diff(df2$recorddate_key[i],df2$orighiredate_key[i]), " vs ", df2$length_of_service[i], "\n")
      if (year_diff(df2$recorddate_key[i],df2$orighiredate_key[i]) == df2$length_of_service[i] - 1 | year_diff(df2$recorddate_key[i],df2$orighiredate_key[i]) == df2$length_of_service[i] + 1) {
        one_year_difference <- one_year_difference + 1
      }
    }
  } else {
    is_consistent_in_length_of_service[i] = FALSE
    terminated_emp_indices[l] <- i
    l = l + 1
    terminated_emp_count = terminated_emp_count + 1
  }
} #loop through active employees and check for los consistency
length(active_emp_indices_with_consistent_length_of_service)
length(active_emp_indices_with_inconsistent_length_of_service)
terminated_emp_count

temp <- length(active_emp_indices_with_consistent_length_of_service) + length(active_emp_indices_with_inconsistent_length_of_service) + terminated_emp_count
temp == nrow(df2)

#all unterminated employees have length_of_service values consistent with year_diff() between recorddate_key and orighiredate_key


# is_consistent_in_length_of_service may not be of use right now, 
#but it is good to collected now that we are given the chance for possible later viability.


#Next, B (the 800 rows with length_of_service being 1 year greater than year_diff())

df3 <- data.frame(df2)
#Let's subtract 1 from everything first
df3$length_of_service[terminated_emp_indices_with_inconsistent_length_of_service] <- df3$length_of_service[terminated_emp_indices_with_inconsistent_length_of_service] - 1

#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
#________________________________________________________________________________________

for(i in 1:length(terminated_emp_indices_with_inconsistent_length_of_service)) {
  cat(year_diff(df3$terminationdate_key[terminated_emp_indices_with_inconsistent_length_of_service[i]], df3$orighiredate_key[terminated_emp_indices_with_inconsistent_length_of_service[i]]), " vs. ", df3$length_of_service[terminated_emp_indices_with_inconsistent_length_of_service[i]], "\n")
}
#length_of_service validation complete.


#As previously stated in year_diff() function definition, 0:00 in the rows in recorddate_key column are all to be removed;
#all dates in the dataset are in the format %m/%d/%Y (recorddate_key 
#has time as well but since all other dates have no time, timex operations 
#would be irrelevant for date calculation.{we will never get a negative time that will 
#decrement day which might decrement month -> decrement year 
#because only 1 column with time; no other column with time to subtract from it})  
#TODOCOMPLETE: Additionally, it is always set to 0:00, making it redundant)

#first check if 0:00 exists in every single row in recorddate_key column
df3 %>%
  filter(grepl("0:00", recorddate_key)) %>%
  nrow() == length(df3$recorddate_key)
#remove the last 5 characters from each row in recorddate_key 
nchar(" 0:00")
df3$recorddate_key <- str_sub(df3$recorddate_key, 1, nchar(df3$recorddate_key) - 5)




#Preliminary Data exploration

#TODO: people analytics
#TODO: hr analytics

#TODO: Find possible reasons for employee loss
#get the ratio of terminated people 
termination_ratio <- length(df2$STATUS[df2$STATUS == "TERMINATED"]) / length(df2$STATUS)
termination_ratio 
#Find the departments in which terminations happened:
#Note: 1:length(df2$STATUS) is the same as any 1:length(df2[,x]) where x is a valid column index number for df2

#to identify all departments individually:
#(Note: the same method of looping through factor will be applied to find all job roles later on)

#a- create a factor from df2$department_name column
dept_f <- factor(df2$department_name)
#b- copy that factor's levels into a simple vector dept_v
dept_v <- levels(dept_f)

#c- create a matrix with 1 row having the department names for dimnames. This matrix will be used to count how many employees in each department.
empty_vector = c(1:nlevels((dept_f)))*0
empty_vector
dept_matrix <- matrix(empty_vector, nrow = 2, ncol = nlevels(dept_f), byrow = F, dimnames = list(c("emp_count", "terminated_count"),levels(dept_f)))

dept_matrix %>% t()

dept_matrix[,2]

dept_matrix[2,4]
dimnames(dept_matrix)
#d- loop through df2$any_column_at_all and increment in matrix counting how many times each dept exists in the column
for (i in 1:length(df2$department_name)) {
  
  j = 1
  for (j in 1:ncol(dept_matrix)) {
    if (df2$department_name[i] == dimnames(dept_matrix)[[2]][j]) {
      dept_matrix[1,j] = dept_matrix[1,j] + 1
      if (df2$STATUS[i] == "TERMINATED") {
        dept_matrix[2,j] = dept_matrix[2,j] + 1
      }
    }
  }
}

dept_matrix
# A simple check shows us that the sum of the values in the matrix is equal to what is expected (total employees + total terminated)
sum(dept_matrix) - length(df2$STATUS[df2$STATUS == "TERMINATED"]) - length(df2$department_name)



#
# A get_count() function to generate such results seems worthy to me now in early Oct, 
#but cost-effectiveness of implementing a function so column-universal is unjustifiable. 


#factor out all termination reasons by utilizing a factor
tr_f <- factor(df2$termreason_desc)
tr_v <- levels(tr_f)

#create a matrix

empty_vector <- as.numeric(1:nlevels(tr_f)*0)
tr_m <- matrix(empty_vector, nrow = 1, ncol = length(tr_v), byrow = F, dimnames = list(c("term_count"), levels(tr_f)))

i = 1
for (i in 1:length(df2$termreason_desc)) {
  j = 1
  for (j in 1:ncol(tr_m)) {
    if (df2$termreason_desc[i] == dimnames(tr_m)[[2]][j]) {
      tr_m[1,j] = tr_m[1,j] + 1
    }
    
  }
}

tr_m

# a singular unified function that calculates the statistics we want from the following columns would prove invaluable.
# Nevertheless, each task has diverse columns with different data types as well as different requests to be calculated

length(df2)
length(df2[,1])
length(df2$STATUS)

tempv






#######





temp <- ggplot(data = df3, mapping = aes(y = job_title)) + geom_bar()
ggplot(data = df3, mapping = aes(x = city_name, y = job_title)) + geom_point()
ggplot(data = df3, mapping = aes(y = job_title)) + geom_bar() + geom_point(data = df3, mapping = aes(x = city_name, y = job_title))
#Two conclusions can be made from this data:
#1- Vancouver is somewhat of an HQ, it has accountants, analysts, directors, executives, etc.
#One can assume that such jobs are only necessitated in Vancouver, not in other cities.
#This means that there is no reason to measure ratio of executives to produce clerk or other job with higher observation frequency in vancouver.
#If other cities would benefit from an analyst/executive/director then 


#This plot supports the previous assumptions:
ggplot(df3, mapping = aes(y = job_title, fill = city_name)) + geom_bar() 
#On it's own, this one's practically useless but it's really beautiful.
#ggplot(df3[!(df3$city_name %in% "Vancouver")], aes(y = job_title))

# ?scale_fill_viridis()


#ggplot(data = df3, aes(y = city_name)) + geom_bar()
#deselect factor level with largest count of observations 
#(Knowing Vacouver is already well-over 1500, we can treat it as an outlier.
#This gives us more precise representations of cities with minimal employees - which are 
#the target of this plot)

#TODOCOMPLETE: get city_name without Vancouver and make plots without it.

subset(df3, city_name != "Vancouver") %>% 
  ggplot(aes(x = job_title, fill = city_name)) + 
  geom_bar() +
  coord_flip()
  #scale_fill_viridis_b(discrete = TRUE)
  # facet_wrap(~city_name)







#Create a function that finds employment statistics by city:
#Pre-requisites: df3 <- as.factor(df3) #[this will increase efficiency in several parts of the function]
#Also, the function will be made to work with levels

# data frame without vancouver observations.
no_vancouver_df3 <- data.frame(df3[!(df3$city_name %in% "Vancouver"),])


levels(no_vancouver_df3$job_title)


#Store Manager
#Produce Manager
#Customer Service Manager
#Bakery Manager
#Processed Foods Manager
#Meats Manager


#TODO: select all levels that are not JUST in Vancouver (any job title that is just in vancouver and not in other cities is deselected)
#Put this selection into a variable (column of its own)

#Plot factor(df3$job_title) without vancouver and the other outliers
#It's not enough to make an argument that certain cities have more of a job_title than the others.
#A valid argument is that certain cities lack certain job_titles either fully (have no unterminated emp of that job_title) or partially***
#***Partially can go two ways: 
#city has some emp but not the avg amount (reductionist)
#city has some emp but below emp-to-manager ratio(DOESN'T HAVE TO BE MANAGER) (optimal)



#Shelf Stocker
#Produce Clerk
#Diary Person
#Cashier
#Baker
#Meat Cutter

#TODO: CHECK IF BAKER IS EMPLOYED WITHOUT BAKER MANAGER AND VICE VERSA
#It would be a lot worse if a baker manager is employed without bakers.
#This applies to other managerial job_titles and the job_title they manage
#FIND ALL OF THEM.


#TODO:
#
#Record job_title vacancy (0 active emp of that job_title) per city_name
#
# + geom_point that shows the average job_title count in a city_name (aside from vancouver and such outliers)





for(i in nrow(df3)) {}


df3 <- data.frame(df2)

#TODO:
#How does gender come into play in terminations?
#A- Is a certain gender terminated noticably more frequently from certain job_titles than others?
for(i in length(df3$terminationdate_key[(df3$terminationdate_key != "1/1/1900")])) {
  
}
length(terminated_emp_indices) == length(df3$terminationdate_key[(df3$terminationdate_key != "1/1/1900")])

df2[terminated_emp_indices] %>%
  group_by(gender_short)

subset(df2, terminationdate_key != "1/1/1900") %>%
  count() -> data1


ggplot(data1, aes(job_title)) + geom_col() + coord_flip() + facet_grid(df2$gender_short)

subset(data1, gender_short == "M") %>%
  ggplot(aes(gender_short, )) + geom_bar()

subset(data1)
  
df3$terminationdate_key == "1/1/1900"




#B- Are certain job_titles predominantly male/female?
#One of two arguments can be made: 
#This only applies where there aren't many terminations of the less common gender and thus applicable only where there are no obvious/inferrable reasons for predominance of a particular gender
### Employing more of the less predominant gender might prove fruitful.
### Employing less of the less predominant gender might prove fruitful.
#####I don't like either of these arguments without using termination stats as evidence.



View(df)




df3 %>%
  select(age, terinationdate_key) %>% filter(termtype_desc == "Voluntary")

df2 %>%
  subset(termtype_desc == "Voluntary") %>%
  arrange(age) %>%
  ggplot(aes(age)) + geom_bar(width = 5) + labs(y = "emp count") facet_wrap(gender_short)

df2 %>%
  filter(termtype_desc == "Involuntary") %>% print()

install.packages("maps")
require(maps)
df2 %>%
  ggplot(aes(job_title, STATUS_YEAR)) + geom_count(color = "blue") + coord_flip() -> temp_map

df2 %>%
  subset(terminationdate_key == "1/1/1900") %>%
  ggplot(aes(job_title, terminationdate_key)) + geom_count(color = "red") + 

temp_map

df2 %>%
  ggplot(aes(STATUS_YEAR)) + geom_histogram(color = "blue") + coord_flip() + facet_wrap(~df2$job_title)


#TODO: plot length_of_service with facet_wrap job_title

df2 %>%
  subset(df2$STATUS == "ACTIVE") %>%
  ggplot(aes(x = length_of_service)) + geom_histogram() + facet_wrap(~subset(df2, df2$STATUS == "ACTIVE")$job_title)



df3 %>% View





df %>% 
  mutate(isTerminated = ifelse(STATUS == "ACTIVE", F, T)) %>%
  mutate(isLaidOff = ifelse(termreason_desc == "Layoff",T, F)) %>%
  group_by(store_name, city_name, STATUS_YEAR) %>% 
  summarise(total = n(), active = sum(!isTerminated), term = sum(isTerminated), term_percentage = as.integer(sum(isTerminated) / total * 100), layoff_percentage = as.integer(sum(isLaidOff) / total * 100)) %>%
  View()


#DATA ANALYSIS AND VISUALISATION:

#Q1: What helpful, actionable conclusions can be inferred from the relationships between job title and other variables?
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^   Analysis 1   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

length(unique(df3$job_title))
df3 %>%
  group_by(job_title) %>%
  summarize(los = mean(length_of_service)) %>%
  arrange(los) %>% View(title ="average length of service by job_title (including Vancouver records)")



no_vancouver_df3 %>%
  group_by(job_title) %>%
  summarize(los = mean(length_of_service)) %>%
  arrange(los) %>%
  # t() %>% #Though it takes less space, transposed View() is very small and difficult
  #to read and optimize in MS Word portrait A4 paper with 1-inch page indents
  View()
#View("average length of service by job_title (EXCLUDING Vancouver records)")

#


df3 %>%
  group_by(store_name, STATUS) %>%
  summarize(status = n(), term_percentage = mean(STATUS == "TERMINATED")) %>% View

df3 %>% group_by(store_name) %>% View

df3 %>% 
  mutate(isTerminated = ifelse(STATUS == "ACTIVE", F, T)) %>%
  mutate(isLaidOff = ifelse(termreason_desc == "Layoff", T, F)) %>%
  group_by(store_name, city_name) %>% 
  summarise(total = n(), active = sum(!isTerminated), term = sum(isTerminated), term_percentage = sum(isTerminated) / total * 100, layoff_percentage = sum(isLaidOff) / total * 100) %>%
  View

df3 %>% 
  mutate(isTerminated = ifelse(STATUS == "ACTIVE", F, T)) %>%
  mutate(isLaidOff = ifelse(termreason_desc == "Layoff", T, F)) %>%
  group_by(store_name, city_name, STATUS_YEAR) %>% 
  summarise(total = n(), active = sum(!isTerminated), term = sum(isTerminated), term_percentage = sum(isTerminated) / total * 100, layoff_percentage = sum(isLaidOff) / total * 100) %>%
  View


df3$job_title <- as.factor(df3$job_title)
df3 %>%
  group_by(job_title) %>%
  summarize(los = mean(length_of_service)) %>%
  arrange(los) %>%
  ggplot(aes(reorder(job_title, desc(los)), los)) + geom_col() + ylim(0, 30) +
  coord_flip() +
  ggtitle("Average length_of_service by job_title (including Vancouver records)") +
  labs(y = "los (length_of_service)")

# Cashier, shelf stocker, diary person, and baker all have significantly less average length of service than others jobs
# This can be attributed to often having generally low job-prospects working in these positions.
# There seems to be a trend where job titles exclusive to vancouver hold the highest length of service. One likely reason for this is that these employees like the CEO, VP employees, and executives have been around since the inception of the company.
no_vancouver_df3 %>%
  group_by(job_title) %>%
  summarize(los = mean(length_of_service)) %>%
  ggplot(aes(reorder(job_title, desc(los)), los)) + 
  geom_col() + 
  coord_flip() +
  ggtitle("Average length_of_service by job_title (excluding Vancouver records)") +
  labs(y = "los (length_of_service)")


unique(df3$termreason_desc)

#NEXT ANALYSIS
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^   Analysis 2   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

#First analysis follow-up: resignation in the 4 job titles with lowest length of service:
df3 %>%
  subset(job_title %in% c("Cashier", "Shelf Stocker", "Dairy Person", "Baker")) %>%
  mutate(isTerminated = ifelse(STATUS == "ACTIVE", F, T)) %>%
  mutate(isLaidOff = ifelse(termreason_desc == "Layoff", T, F)) %>%
  mutate(hasResigned = ifelse(termreason_desc == "Resignation", T, F)) %>%
  mutate(hasRetired = ifelse(termreason_desc == "Retirement", T, F)) %>%
  group_by(job_title) %>%
  summarise(total = n(), active = sum(!isTerminated), term = sum(isTerminated), term_percentage = sum(isTerminated) / total * 100, avg_los = as.integer(mean(length_of_service)), resignation_percentage = sum(hasResigned) / total * 100, retirement_percentage = sum(hasRetired) / total * 100, layoff_percentage = sum(isLaidOff) / total * 100)



#Now to check termination statistics per job title.
#grouped by store_name, city_name, and job_title

df3 %>% 
  mutate(isTerminated = ifelse(STATUS == "ACTIVE", F, T)) %>%
  mutate(isLaidOff = ifelse(termreason_desc == "Layoff", T, F)) %>%
  mutate(hasResigned = ifelse(termreason_desc == "Resignation", T, F)) %>%
  mutate(hasRetired = ifelse(termreason_desc == "Retirement", T, F)) %>%
  group_by(store_name, city_name, job_title) %>% 
  summarise(total = n(), active = sum(!isTerminated), term = sum(isTerminated), term_percentage = sum(isTerminated) / total * 100, avg_los = as.integer(mean(length_of_service)), resignation_percentage = sum(hasResigned) / total * 100, retirement_percentage = sum(hasRetired) / total * 100, layoff_percentage = sum(isLaidOff) / total * 100) %>%
  arrange(desc(term_percentage)) %>%
  View



df3 %>%
  arrange(desc(termreason_desc)) %>%
  ggplot(aes(x = job_title, fill = termreason_desc)) + 
  geom_bar(position = position_stack()) +
  coord_flip()
# geom_bar(aes(y = (..count..)/sum(..count..)*100), position = position_stack())
# scale_y_continuous(labels = percent)

df3 %>%
  group_by(job_title, termreason_desc) %>%
  arrange(desc(termreason_desc)) %>%
  ggplot(aes(reorder(job_title, job_title), fill = termreason_desc)) + 
  geom_bar() + 
  facet_grid(~termreason_desc, scales = "free_x") + 
  coord_flip() 



#IMPORTANT: Another example of what difficult-to-read plot can be generated in another attempt to visualize multiple categorical variables.
#IMPORTANT: This plot is not an effective analysis and would only possibly be
#used for demonstration of why the summarization tibbles are better 
#alternatives in this case where we are trying to examine a multitude
#of categorical variables concurrently and quickly
#
# df3 %>% 
#   mutate(isTerminated = ifelse(STATUS == "ACTIVE", F, T)) %>%
#   mutate(isLaidOff = ifelse(termreason_desc == "Layoff", T, F)) %>%
#   mutate(hasResigned = ifelse(termreason_desc == "Resignation", T, F)) %>%
#   mutate(hasRetired = ifelse(termreason_desc == "Retirement", T, F)) %>%
#   group_by(store_name, city_name, job_title) %>% 
#   summarise(total = n(), active = sum(!isTerminated), term = sum(isTerminated), term_percentage = sum(isTerminated) / total * 100, avg_los = as.integer(mean(length_of_service)), resignation_percentage = sum(hasResigned) / total * 100, retirement_percentage = sum(hasRetired) / total * 100, layoff_percentage = sum(isLaidOff) / total * 100) %>%
#   arrange(desc(term_percentage)) %>%
#   ggplot(aes(x = job_title, y = city_name, fill = store_name)) + geom_col() + coord_flip()

#grouped by job_title only
df3 %>% 
  mutate(isTerminated = ifelse(STATUS == "ACTIVE", F, T)) %>%
  mutate(hasResigned = ifelse(termreason_desc == "Resignation", T, F)) %>%
  mutate(hasRetired = ifelse(termreason_desc == "Retirement", T, F)) %>%
  mutate(isLaidOff = ifelse(termreason_desc == "Layoff", T, F)) %>%
  group_by(job_title) %>% 
  summarise(total = n(), active = sum(!isTerminated), term = sum(isTerminated), term_percentage = sum(isTerminated) / total * 100, avg_los = as.integer(mean(length_of_service)), resignation_percentage = sum(hasResigned) / total * 100, retirement_percentage = sum(hasRetired) / total * 100, layoff_percentage = sum(isLaidOff) / total * 100) %>%
  View

#The first thing inferrable from this table is that several job titles exclusive to vancouver have all of their employees terminated and have no active employees whatsoever. What is more is that they every single employee of them retired - except one HRIS analyst who resigned. 
#This signals an issue exclusive to vancouver, to check how many of vancouver's exclusive job_titles still have active employees, we arrange the table by term_percentage:

#The other

#Retirement being the major cost of employee leave seems to be overall the most likely reason for termination
df3 %>%
  mutate(isTerminated = ifelse(STATUS == "ACTIVE", F, T)) %>%
  mutate(hasResigned = ifelse(termreason_desc == "Resignation", T, F)) %>%
  mutate(hasRetired = ifelse(termreason_desc == "Retirement", T, F)) %>%
  mutate(isLaidOff = ifelse(termreason_desc == "Layoff", T, F)) %>%
  summarise(total = n(), active = sum(!isTerminated), term = sum(isTerminated), term_percentage = sum(isTerminated) / total * 100, avg_los = as.integer(mean(length_of_service)), resignation_percentage = sum(hasResigned) / total * 100, retirement_percentage = sum(hasRetired) / total * 100, layoff_percentage = sum(isLaidOff) / total * 100)
#At 14%, retirement is the greatest termination driver, followed by resignation at 6% and layoff at 3%.
#Layoffs are terminations that are not due to the employee in any way.

unique(df3$job_title[!df3$job_title %in% no_vancouver_df3$job_title])
#To check only the job titles that are inexclusive to Vancouver:

df3[!df3$job_title %in% no_vancouver_df3$job_title,] %>% 
  mutate(isTerminated = ifelse(STATUS == "ACTIVE", F, T)) %>%
  mutate(hasResigned = ifelse(termreason_desc == "Resignation", T, F)) %>%
  mutate(hasRetired = ifelse(termreason_desc == "Retirement", T, F)) %>%
  mutate(isLaidOff = ifelse(termreason_desc == "Layoff", T, F)) %>%
  group_by(job_title) %>% 
  summarise(total = n(), active = sum(!isTerminated), term = sum(isTerminated), term_percentage = sum(isTerminated) / total * 100, avg_los = as.integer(mean(length_of_service)), resignation_percentage = sum(hasResigned) / total * 100, retirement_percentage = sum(hasRetired) / total * 100, layoff_percentage = sum(isLaidOff) / total * 100) %>%
  arrange(term_percentage) %>%
  View

#Only 11 out of 34, (nearly 33% of ) job_titles exclusive to vancouver have active employees.
#23 job titles remain without a single active employee.
#It is highly unlikely that all - if any at all - of these jobs are no longer necessitated. 
#Moreover, the employees retired, it wasn't layoff by the company which also reinforces that it wasn't

# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^   Further Analysis   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^



#Since we know which job_titles have 0 active employees and 100% retirement, we can attempt to gather more information about them.

#When did these retirements occur?
df3[!df3$job_title %in% no_vancouver_df3$job_title,] %>% 
  mutate(isTerminated = ifelse(STATUS == "ACTIVE", F, T)) %>%
  mutate(hasResigned = ifelse(termreason_desc == "Resignation", T, F)) %>%
  mutate(hasRetired = ifelse(termreason_desc == "Retirement", T, F)) %>%
  mutate(isLaidOff = ifelse(termreason_desc == "Layoff", T, F)) %>%
  group_by(job_title) %>% 
  summarise(total = n(), active = sum(!isTerminated), term = sum(isTerminated), term_percentage = sum(isTerminated) / total * 100, avg_los = as.integer(mean(length_of_service)), resignation_percentage = sum(hasResigned) / total * 100, retirement_percentage = sum(hasRetired) / total * 100, layoff_percentage = sum(isLaidOff) / total * 100) %>%
  arrange(-term_percentage) -> temp


df3[!df3$job_title %in% no_vancouver_df3$job_title,] %>% 
  mutate(isTerminated = ifelse(STATUS == "ACTIVE", F, T)) %>%
  mutate(hasResigned = ifelse(termreason_desc == "Resignation", T, F)) %>%
  mutate(hasRetired = ifelse(termreason_desc == "Retirement", T, F)) %>%
  mutate(isLaidOff = ifelse(termreason_desc == "Layoff", T, F)) %>%
  # group_by(job_title) %>%
  summarise(total = n(), active = sum(!isTerminated), term = sum(isTerminated), term_percentage = sum(isTerminated) / total * 100, avg_los = as.integer(mean(length_of_service)), resignation_percentage = sum(hasResigned) / total * 100, retirement_percentage = sum(hasRetired) / total * 100, layoff_percentage = sum(isLaidOff) / total * 100) 
# arrange(-term_percentage)


df3[df3$job_title %in% temp[temp$retirement_percentage == 100,]$job_title,] %>%
  group_by(STATUS_YEAR) %>%
  summarize(total = n())
df3[df3$job_title %in% temp[temp$retirement_percentage == 100,]$job_title,] %>%
  group_by(age) %>%
  summarize(total = n())

#No conclusions can be drawn from retirement by STATUS_YEAR or by age. Though, the dataframe can be tested to ensure records exist for the other years:
unique(df3$STATUS_YEAR) %>% sort()
#Records exist for all years from 2006 until 2015.
df3

#TODO: is the above really correct?

df3[!df3$job_title %in% no_vancouver_df3$job_title[no_vancouver_df3$job_title %in% temp[temp$retirement_percentage %in% 100,],],]


# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^   Question 2   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
#Q2: What potentially helpful, actionable conclusions can be drawn from the relationship between gender and other variables, namely termination?


#How does gender come into play in termination?
df3 %>%
  subset(termreason_desc %in% "Resignation") -> temp
temp %>%
  ggplot(aes(termreason_desc, fill = gender_short)) + geom_bar(position = position_dodge())

###From this graph, we can see that women are noticably more likely to resign than men.
###The exact resignation ratio is 
df3 %>% 
  subset(termreason_desc == "Resignation") -> temp
cat("Female employees resign more than males by ", as.integer((sum(temp$gender_short == "F") / sum(temp$gender_short == "M") - 1 ) * 100), "%")


###A possible reason for this is the unavailability of maternity leave, something necessitated by women.
###Another reason would be the nature of the job itself being a reason. A good example of this is how a number of job titles have more men employed than women:

df3 %>%
  ggplot(aes(job_title, termreason_desc, fill = gender_short)) + geom_col(position = position_stack(), width = 0.7) + coord_flip() -> temp
temp #+ stat_bin(df3, aes(gender_short))

df3 %>%
  ggplot(aes(x = job_title, fill = gender_short)) + geom_bar(position = position_dodge(), width = 0.7) + coord_flip() -> temp
temp #+ stat_bin(df3, aes(gender_short))


no_vancouver_df3 <- subset(df3, city_name != "Vancouver")
no_vancouver_df3 %>%
  ggplot(aes(gender_short, fill = termreason_desc)) + geom_bar(position = position_fill(), width = 1.7) + coord_flip() -> temp
temp + facet_grid(~no_vancouver_df3$job_title)

no_vancouver_df3 %>%
  ggplot(aes(termreason_desc, fill = gender_short)) + geom_bar(position = position_dodge()) + coord_flip() -> temp
temp + facet_wrap(~job_title, scales = "free_x")



install.packages("rtools")
install.packages("pacman")
install.packages("devtools", dependencies = TRUE)
require(Rtools)
require(devtools)

devtools::install_github("zeehio/facetscales")
library(g)
library(facetscales) #No longer needed. Turns out I can just use scales = "free_x"
# scales_x <- list(
#   "Accounting Clerk" = scale_x_continuous(limits = c(0,25), breaks = seq(0,25,5)),
#   "Accounts Payable Clerk" = scale_x_continuous(limits = c(0,25), breaks = seq(0,25,5)),
#   "Accounts Receivable Clerk" = scale_x_continuous(limits = c(0,25), breaks = seq(0,25,5)),
#   "Auditor" =scale_x_continuous(limits = c(0,25), breaks = seq(0,25,5))
# )


no_vancouver_df3$gender_full <- NULL
no_vancouver_df3$gender_short <- factor(no_vancouver_df3$gender_short)
no_vancouver_df3$city_name <- factor(no_vancouver_df3$city_name)
no_vancouver_df3$STATUS <- factor(no_vancouver_df3$STATUS)
no_vancouver_df3$termreason_desc <- factor(no_vancouver_df3$termreason_desc)
no_vancouver_df3$termtype_desc <- factor(no_vancouver_df3$termtype_desc)
no_vancouver_df3$job_title <- factor(no_vancouver_df3$job_title)

df3$gender_full <- NULL
df3$gender_short <- factor(no_vancouver_df3$gender_short)
df3$city_name <- factor(no_vancouver_df3$city_name)
df3$STATUS <- factor(no_vancouver_df3$STATUS)
df3$termreason_desc <- factor(no_vancouver_df3$termreason_desc)
df3$termtype_desc <- factor(no_vancouver_df3$termtype_desc)
df3$job_title <- factor(no_vancouver_df3$job_title)

vancouver_job_titles <- unique(no_vancouver_df3$job_title)
df3 %>%
  subset((job_title %in% no_vancouver_df3$job_title)) -> temp
unique(temp$job_title)
nrow(subset(temp, city_name == "Vancouver"))


temp %>% #vancouver-exclusive jobs are left out to focus on the vancouver-unexclusive job facets
  ggplot(aes(x =termreason_desc, fill = gender_short)) + 
  geom_bar(position = position_dodge()) + coord_flip() + 
  facet_wrap(~no_vancouver_df3$job_title, scales = "free_x")




# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^   Question 3   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
#Q3: What potentially helpful, actionable conclusions can be drawn from the current status of managers?

# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^   Analysis 1   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
temp %>% #vancouver-exclusive jobs are left out to focus on the vancouver-unexclusive job facets
  ggplot(aes(x =termreason_desc, fill = gender_short)) + 
  geom_bar(position = position_dodge()) + coord_flip() + 
  facet_wrap(~no_vancouver_df3$job_title, scales = "free_x")
df3 %>%
  subset(job_title %in% "Dairy Person") %>%
  subset(STATUS == "ACTIVE") %>%
  nrow() -> temp
df3 %>%
  subset(job_title %in% "Dairy Person") %>%
  nrow() -> total
cat(temp, "(", (temp / total * 100), "%)", "active dairy people exist in the company")
df3 %>%
  subset(job_title %in% "Dairy Person") %>%
  group_by(city_name, job_title) %>%
  summarize(total = n()) %>% 
  arrange(desc(total)) %>% View

df3 %>%
  filter(grepl("Manager", job_title)) %>%
  group_by(job_title) %>%
  summarize(average_age = mean(age))



#Two points can be concluded from meat cutter facet excluding vancouver: 
#Firstly, there are more female male cutters than there are males.
#Secondly, significantly more female meat cutters resign than their male counterparts.
#The second point also applies to diary person, to shelf stocker and somewhat to produce clerk

#Accounting for vancouver:
df3 %>% 
  ggplot(aes(termreason_desc, fill = gender_short)) + geom_bar(position = position_dodge()) + coord_flip() + facet_wrap(~df3$job_title)
#TODO: modify the ylim for the other facets
#The same conclusions can be made including data from vancouver.
#Vancouver-exclusive jobs have too few employees for numbered estimates to be made.

#Training employees costs money and time. Turnover is a costly endeavor. That being said, HR should look into reasons why female employees resign more from these certain job titles and, if possible, attempt to address those reasons - maternity leave being only one of many possible reasons.
#Another less efficient way to reduce resignation by female employees is to simply employ less females for those 3 job titles that have high female employee resignation. This is significantly less effective than addressing the root causes of high resignation, but it still would, based on the analysis of the graph, result in less resignations this way.

#TODO: Can we find where exactly did the resignations most happen?


#Layoff is the termination of an employee for reasons other than employee inadequacy. As such, 

