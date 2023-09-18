/*
 * calculate the total and running sum by years of experience, candidate and job, form the first one to the current one.
 * (order by start_date from date_range, it is not ncessary to clean all the data.)
 */

create temp table temp_running_sum as
select
	cast(substring(j.date_range from '\d{4}') as int) as past_job_year
	,sum(cast(substring(j.date_range from '\d{4}') as int)) over (
		order by cast(substring(j.date_range from '\d{4}') as int)
	) as running_sum
from jobs j

select * from temp_running_sum