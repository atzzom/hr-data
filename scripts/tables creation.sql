-- table creation

-- drop table if exists candidate_current_jobs

create table candidate_current_jobs (
	candidate_id int
	,job_id int
)

create table candidate_past_jobs (
	candidate_id int
	,job_id int
);

create table candidates (
	candidate_id int
	,title varchar(255) -- title of the role for the present application
	,"location" varchar(255)
	,hire_flag bool
);

create table education (
	education_id int
	,title varchar(255) -- degree name
	,description varchar(255)
	,date_range varchar(255)
	,candidate_id int
);

create table jobs (
	job_id int
	,title varchar(255) -- past jobs
	,date_range varchar(255)
);

	-- adding foreign keys
alter table candidate_past_jobs
add constraint fk_candidate_id foreign key (candidate_id) references candidates(candidate_id);

alter table candidate_past_jobs
add constraint fk_job_id foreign key (job_id) references jobs(job_id);