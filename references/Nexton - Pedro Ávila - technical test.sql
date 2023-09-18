/*
 * all the answers to the BI and Data Analysist technical test can be found in the following link:
 * https://github.com/atzzom/hr-data/tree/main
 * database creation and data load scripts can be found in the "scripts" folder of the above repository
 */

/*
 * 1. which was the first job of every candidate?
 * (in case of a tie choose a random job, it is not necessary to clean all the data.)
 */

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

/*
 * 2. calculate the total and running sum by years of experience, candidate and job,
 * from the first one to the current one. (order by start_date from date_range,
 * it is not necessary to clean all the data).
 */

create temp table temp_running_sum as
select
	cast(substring(j.date_range from '\d{4}') as int) as past_job_year
	,sum(cast(substring(j.date_range from '\d{4}') as int)) over (
		order by cast(substring(j.date_range from '\d{4}') as int)
	) as running_sum
from jobs j

select * from temp_running_sum

/*
 * 3. data model available at folder references/nexton data modeling.jpg
 * of the https://github.com/atzzom/hr-data/tree/main repository
 *
 * 4. link to corresponding dashboard:
 * https://lookerstudio.google.com/reporting/9cac680b-727f-4613-9cf1-aa2ff0c846bf/page/RTwcD
 */

