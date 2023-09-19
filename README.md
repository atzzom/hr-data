# hr data

this repository organization follows the [cookiecutter data science structure](https://drivendata.github.io/cookiecutter-data-science/) developing the questions below for HR sample data:

## data manipulation

use the data model to generate a well documented and functional Postgresql code that answer the following exercises: *(tip: will be useful to create the data model tables on a db for this and next module exercise)*

**table creation and data load**

the `references/tables creation.sql` script contains the statements to create the tables and set the proper relationships between them. Additionally, in the `references/data load.sql` script the data is loaded into each of the previously created tables in the database.

1. which was the first job of every candidate? (in case of a tie choose a random job, it is not necessary to clean all the data.)

```sql
select
	cpj.candidate_id as "candidate id"
	,cpj.job_id as "job id"
	,j.title
	,j.date_range as "date"
	,substring(j.date_range from '\d{4}') as "past jobs year"
	,first_value(j.title) over(
		partition by cpj.candidate_id
		order by substring(j.date_range from '\d{4}')
	) as candidate_first_job
from candidate_past_jobs as cpj
join jobs as j
on cpj.job_id = j.job_id
```
![candidates's first job](/references/query_01.png "candidate's first job")

2. calculate the total and running sum by years of experience, candidate and job, from the first one to the current one. (order by start_date from date_range, it is not necessary to clean all the data).

```sql
create temp table temp_running_sum as
select
	cast(substring(j.date_range from '\d{4}') as int) as past_job_year
	,sum(cast(substring(j.date_range from '\d{4}') as int)) over (
		order by cast(substring(j.date_range from '\d{4}') as int)
	) as running_sum
from jobs j

select * from temp_running_sum
```
![interim answer](/references/query_02.png "interim answer")

3. how would you calculate the tenure of the hires?

the following query extracts the latest hire year over a partition and subtracts it to the current year:

```sql
select
	ccj.*
	,j.title
	,j.date_range
	,cast(substring(j.date_range from '\d{4}') as int) as past_job_year
	,date_part('year', (select current_date)) as current_year
	,max(cast(substring(j.date_range from '\d{4}') as int)) over (
		partition by ccj.candidate_id
	) as latest_hire_year
	,date_part('year', (select current_date)) - max(cast(substring(j.date_range from '\d{4}') as int)) over (
		partition by ccj.candidate_id
	) as tenure_yrs
from candidate_current_jobs ccj
join jobs j
on ccj.job_id = j.job_id
order by candidate_id
```
![hires tenure](/references/query_03.png "hire's tenure")

## data modeling

1. using the following tables, ***re-draw*** a diagram of a dimensional data model based on these table. Identify facts, dimensions and relationships.

Entity Relationship Diagram (ERD) available at `references/nexton data modeling.jpg` and `references/nexton data modeling.drawio`

![HR database model](references/data_modeling.jpg "HR database entity relationship diagram")


## dashboard and business intelligence

use the previous data model to create an exploratory dashboard that helps the users to find the best talent to hire. Based on the given data, which would be your top 20 best candidtes to hire? Why? You can use any visualization tool of your choice and external data sources, but it needs to be shareable with a link. (Some examples are Tableau, Power BI, Google Data Studio).

extra points: add and external data source that connects through an API endpoint.

[link to dashboard report](https://lookerstudio.google.com/reporting/9cac680b-727f-4613-9cf1-aa2ff0c846bf/page/RTwcD)

### dashboard design

the dashboard ingests data from different sources, namely:
1.  google cloud bucket: via custom sql query calculating metrics for the candidates previous and current jobs, these are used later on in the dashboard to compare an especific candidate against the overall census, as shown below:
![big query custom sql](/references/big_query_custom_sql_query.png "big query custom sql query")
2. connected spreadsheets: raw data ![raw data from gsheets](/references/google_sheets_source.png "google sheets source")
3. local transformed files: resulting of the files contained in the `notebooks` and `scripts` folders,  simplify the obtention of complementary data such as the candidate's country, creating flags for candidates with at least one degree, getting the amount of education of each candidate, and additional information signalling a candidate's suitability. ![local import](/references/csv_import.png "local data source")
4. cloud bucket: as an additional exercise illustrating raw data ingestion from the cloud ![google cloud bucket ingestion](/references/google_cloud_bucke_raw_data.png "google cloud bucket raw data ingestion")

### conclusions

- the dashboard shows a talent concentration in Argentina, the United States and Brazil, more generally in latinamerica, this doesn't necessary means lack of talent in other regions but could rather reflect the focus of the company.
- ~4.8% of the talent is being selected for hire
- there's a strong correlation between having a degree and hiring; only 5 hired candidates out of 1913 didn't have a degree (0.03%)
- more cleaning useful, for example analysis by category, better visibility of especific roles under different naming conventions
- some data needs to be revisited, for example, assess the meaning of employees with more than one current job, skills, etc
