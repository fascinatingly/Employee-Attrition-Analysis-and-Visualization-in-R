# Employee-Attrition-Analysis-and-Visualization-in-R
Data analysis of employee attrition dataset using R (preprocessing, validation, exploration, manipulation, transformation, and visualization)



# Data Exploration, and Visualization Results:

**Question 1:**

What helpful, actionable conclusions can be drawn from the relationships between job title and other variables?

_Analysis 1.1:_ length of service by job title.

Starting off, average length\_of\_service by job\_title is examined:

![image](https://user-images.githubusercontent.com/102264544/165544664-a1638c52-51ab-4a36-8b0c-b0ec0b2d0999.png)

![image](https://user-images.githubusercontent.com/102264544/165544723-60b1f7b1-b30f-453a-9eaa-2d39b79d07f9.png)

What can be seen from this is that cashiers, shelf stockers, diary people and bakers have the significantly shorter length of service in comparison to Vancouver-specific jobs which have 19 years of service or more on average.

Next, the same tibble is generated except without observations from Vancouver to see the average length of service in cities outside Vancouver and also to see whether average length of service for the Vancouver-unexclusive jobs is higher in Vancouver than outside Vancouver. This tibble will show outside Vancouver only for just the jobs outside Vancouver:

![image](RackMultipart20220427-1-mflwnv_html_25a8a9dfe36820b.png)

![image](RackMultipart20220427-1-mflwnv_html_c23ac1a7bb566d1a.png)

Cashier, shelf stocker and diary person show shorter length of service by around 1 in comparison. The jobs following baker show no significant difference. Overall, with and without Vancouver data, these three jobs show significantly less (almost three times less in the case of cashiers) length of service in comparison to Vancouver-specific jobs.

This very same process is also visualized in ggplot2 graphs and reiterated:

![image](RackMultipart20220427-1-mflwnv_html_7e91b6ea7b32ae23.png)

![image](RackMultipart20220427-1-mflwnv_html_14ff34d4f8b9f3b.png)

Here is the same graph but without Vancouver&#39;s records to see if how different the average length of service is without Vancouver. As previously seen in the table, the 3 jobs lowest in length of service have even less values than with Vancouver&#39;s records which means that employees in these jobs stay longer in Vancouver than in other cities.

![image](RackMultipart20220427-1-mflwnv_html_f9e0c6b2303fa796.png)

![image](RackMultipart20220427-1-mflwnv_html_2133f3bd230a579d.png)

It is clear from both graphs that cashier, shelf stocker, diary person, and baker all have significantly less average length of service than other jobs. This can be attributed to often having generally low growth in job prospects and career outlook working in these positions. If paired with high resignation from these four jobs, it is highly likely that there are reasons behind employees resigning from these jobs. HR can attempt to uncover and address these resignation reasons.

There seems to be a trend where job titles exclusive to Vancouver hold the highest length of service. One probable reason for this is that these employees like the CEO, VP employees, and executives have been around since the inception of the company.

The next analysis will cover termination reasons by job title.

_Analysis 2: Summary of termination reason percentages by job title_

This is quite a detailed analysis.

There are several things to explore and look into within this table:

1. Resignation percentage. (Following up on the previous analysis&#39;s findings)
2. Retirement percentage.
3. Layoff percentage.
4. Termination percentage.

What is crystal-clear from this data is that many jobs and positions simply are not being replaced. No turnover effort is being made. Stores cannot operate without anybody. There is no profit in having stores with no employees to do the job. A reasonable assumption would be that these stores closed down, but the majority of vacant positions are due to retirement, not layoff. There are many stores where retirement is occurring, it is highly unlikely that agreements were set and arrangements were made for certain stores to close down when the employees retired because this would require all of them to retire at the same time.

First and foremost, following up on the first analysis&#39;s findings before diving into this analysis, this is how much termination there is in the four job titles with lowest average length of service:

![image](RackMultipart20220427-1-mflwnv_html_58f7cf444e5e6258.png)

![image](RackMultipart20220427-1-mflwnv_html_3eb1022007942ce.png)

More dairy people and bakers seem to be retiring than being laid off. However, not a single resignation was made by employees from these jobs. This means there isn&#39;t something HR can address to lessen termination in the case of these four jobs. Nevertheless, employees often need to be replaced. As long as turnover occurs, a store can continue on running. However, the next table highlights something important.

![image](RackMultipart20220427-1-mflwnv_html_625d70d300f69cf8.png)

![image](RackMultipart20220427-1-mflwnv_html_5b8a69741824b59b.png)

This table has 471 rows and 11 columns. It is rather data-rich. This table showcases a plethora of stores and cities wherein jobs are left vacant upon retirement. 100% termination rate; 0 active employees for a series of jobs.

Before exploring further onto this 100% termination issue.

What HR can do is go over this particular table in descending order by termination percentage (which is the order it is already arranged in) and check which vacant, unreplaced job positions the company needs to or would benefit from filling in the future at some point and make note of those very positions. This table is helpful in going over specific job\_titles in a city one-by-one fashion as opposed to the next table which is not grouped by three columns including job title but only by store name and city name for a more broad view.

To check how the percentage of remaining employees regardless of job title by city and store; to see whether or not there are stores or even cities where there are no longer any active employees:

![image](RackMultipart20220427-1-mflwnv_html_3cf846916d3b2369.png)

![image](RackMultipart20220427-1-mflwnv_html_9ecd531eda5a69d.png)

Attempting to visualize all of either this or the next tibble&#39;s data in a plot could be reductionist if not done right to the very data-intensive nature of this analysis due to the sheer number of categorical variables intentionally put in these tables. These tables are information-savvy and more actionable in terms of accurate numbers for HR to utilize. A plot would require much faceting. It allows dealing with all of the data concurrently. Despite not visualized, the same conclusions and patterns are easily discernable all together in a singular table with arrange() and group\_by(). On the contrary, smaller numbers in the same comparison would be completely overshadowed and one would have to make the effort to get them into their own plot away from larger numbers just to visualize. The tibbles easily solved this. termreason\_desc, the four possible termination reasons can be compared by job title, but we can&#39;t have individual comparisons with the smaller values such as CEO and other Vancouver-exclusive jobs with 1 or very few employees. ![](RackMultipart20220427-1-mflwnv_html_c77a542ae2b648d0.png)

![image](RackMultipart20220427-1-mflwnv_html_4e68f9803b92d305.png)

The sheer number of possible job titles prevent the ability to position\_dodge() termreason\_desc instead of faceting by termreason\_desc.) As seen in the plot below, facets drastically hinder the possibility of comparing termreason\_desc by job\_title. Even still, larger values such as meat cutters and cashiers shorten the bars of the other job titles. It is for these reasons and the data frames&#39; quick and easy fix to these issues that they were used and recommended for analysis as opposed to these two plots. Plotting is still usable in any case but in this case, time-wise and effort-wise, the tibbles reign supreme. (After future improvement in data visualization in R with ggplot2, I have come to realize that, while 1 tibble still remains more information-driven than 3 separate graphs, using position\_fill() instead of position\_dodge() as it would show the ratios between percentages effectively. Both plots and tables work) As aforementioned, HR can use the tibbles to clearly identify what to address in the future when possible in terms of turnover and which positions to prioritize refilling as soon as possible.

![image](RackMultipart20220427-1-mflwnv_html_12e8f8176e6ea4ea.png)

**Question 2:**

What potentially helpful, actionable conclusions can be drawn from the relationship between gender and other variables, namely termination?

_Analysis 1:_

![image](RackMultipart20220427-1-mflwnv_html_41c7e89c2ca7ffdf.png)

![image](RackMultipart20220427-1-mflwnv_html_87eb7b48143f2bf1.png)

From this graph, we can see that women are noticeably more likely to resign than men.

The exact resignation ratio is derived as follows:

![image](RackMultipart20220427-1-mflwnv_html_f2d8dfc2e48a64eb.png)

![image](RackMultipart20220427-1-mflwnv_html_10f51d1d3c6585c6.png)

Women are 21% more likely to resign than men.

A possible reason – out of many – for this is the unavailability of maternity leave, something necessitated by women or simply by personal reasons. This is not enough to work on but female employees&#39; need for maternity leave is something to consider because offering that would reduce turnover as the trained, experienced female employee needs not resign due to maternity leave being unavailable.

Another reason could be the nature of the job itself being a reason. A good example of this is how a number of job titles have more men employed than women:

![image](RackMultipart20220427-1-mflwnv_html_857a85801197b881.png) ![](RackMultipart20220427-1-mflwnv_html_cecd9431529e1a17.png)

This is the position\_stack() version.

![image](RackMultipart20220427-1-mflwnv_html_539f6d397be3f95b.png)

This is the position\_dodge() version.

![image](RackMultipart20220427-1-mflwnv_html_7305660f06e0e6a3.png)

This is the position\_fill() version.

The position\_fill version of the plot is more effective at showcasing a ratio between female employees to male employees for all job\_titles regardless of a job title&#39;s frequency. (CEO is one male so it isn&#39;t overshadowed by the higher number of records in other job titles. position\_dodge(), while compromising by barely, if at all, showing the relationships of job titles such as CEO.

From these plots, we can see that it is actually not the case that a certain job would have more males than females. In fact, some jobs have more females than males such as meat cutters – by an astounding rate in the case of meat cutters – and produce clerks. Shelf stockers are the only job with numerous more males than females. Nevertheless, none of this is sufficient for inferences about specific jobs to be made, a table that showcases the exact values along with sums and percentages would be more effective, but there still would be barely any difference for meaningful, actionable inferences. Termination will be compared next.

The next plot will be used as analysis material for both this question and the question that follows because it is very relevant to managerial positions as well as this question. To keep the focus on non-Vancouver jobs which usually have only 1 employee without excluding records of employees in Vancouver that work in jobs unexclusive to Vancouver:

![image](RackMultipart20220427-1-mflwnv_html_6e0378178e59145c.png)

![image](RackMultipart20220427-1-mflwnv_html_5d3861e7d9898781.png)

In a number of managerial jobs, more female managers retire than male managers. Retirement is essentially due to age, not gender, so gender differences in retirement are to be ignored. In the case of resignation, more female dairy people resign than males, but the most noticeable case of higher female than male resignation is in the shelf stocker facet, the same job that is more predominantly male. In order to reduce turnover, the company may benefit from employing more employing more male shelf stockers than females in the future, as they resign less.

**Question 3:**

What potentially helpful, actionable conclusions can be drawn from the current status of managers?

_Analysis 1:_ Termination reasons by job titles unexclusive to Vancouver.

Including Vancouver-exclusive jobs would increase the facets by a multifold and the majority of those jobs have 1 employee only like VP jobs, executives, and CEO, so they are excluded for much more effective visualization. Only the Vancouver-exclusive jobs are excluded, not the Vancouver records of employees in the Vancouver-unexclusive jobs. This eliminates reductionism and keeps accuracy.

![](RackMultipart20220427-1-mflwnv_html_4bd9996fb557c0df.png)

![](RackMultipart20220427-1-mflwnv_html_5d3861e7d9898781.png)

This plot holds a plethora of data, but here are some crucial inferences made which are relevant to the question for which the analysis is made:

1. No active diary managers. By finding where this diary manager was, termination status years can be checked to see if terminations increased in that city after the manager&#39;s termination. This could possibly hint to things being worse without the manager.
2. Moreover, only 1 diary manager was employed to begin with meaning other cities never had diary managers. There are over 800 active diary people in the company with not a single diary manager.

![](RackMultipart20220427-1-mflwnv_html_f410064eecfea9f.png) ![](RackMultipart20220427-1-mflwnv_html_af88328675006f61.png)

1. Managers are clearly leaving the company. Across all managerial jobs, more voluntary terminations occur than involuntary ones. The plot even shows, across all managerial positions, more terminated managers than active ones. It is important to point out that these are majorly retirements and not resignations. This also applies to the sole dairy manager; they retired. It is probably time for the company to hire a new batch.

![](RackMultipart20220427-1-mflwnv_html_3aa5ff26879b31e5.png) ![](RackMultipart20220427-1-mflwnv_html_83839f4cd8538dff.png)By checking for the average age of managers, we can see that managers are, by average, at the age of retirement. This is all managers, not just the ones who are terminated. It is clear from this that this is an ageing batch of managers who have either retired or are on the road to. Maybe it is time for a new batch of managers to be hired by way of new employees or promotions of existing employees. Generally, managers are a crucial part of the workplace and it is often very lucrative for a company to assign managers to a group of employees when cost-effective or when the number of employees necessitates it. One thing is for sure, it is important that this is looked into and decisions are made about the future of managers in the company. The company should make priorities on which cities and stores to provide managers to first and which stores need no managers for the time being.

Conclusion

What was concluded from the analysis towards finding answers to the 3 questions was as follows:

1. A high number of employees are retiring. Many terminated employees&#39; job positions are not being replaced. HR must identify which jobs are to be refilled by priority and which are no longer necessitated, this full-scale check per position is to be applied across all stores especially where the termination reason was retirement or resignation. Laid off employee positions ought also be checked as well because many employees were laid off and many stores have literally no more employees of that job for several jobs.
2. The most noticeable case of higher female than male resignation is in the shelf stocker facet, the same job that is more predominantly male. In order to reduce turnover, the company may benefit from employing more employing more male shelf stockers than females in the future, as they resign less.
3. Managers are leaving the company, mostly due to retirement, it is most probably time to hire a new batch of managers. Nearly all employees are currently without managers. All dairy people across all cities have no manager, and all except for one store has ever had a dairy manager. HR needs to decide where to hire managers and order new managerial turnover by priority in stores.




