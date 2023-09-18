/*
 * Which was the first job of every candidate?
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