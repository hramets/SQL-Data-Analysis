/*
Question: What skills are required for the top-paying data analyst jobs?
- Use the top highest-paying Data Analyst jobs from the first query.
- Add the specific skills required for these roles.
- Why? It provides a detailed look at which high-paying jobs demand certain skills,
    helping job seekers understand which skills to develop that align with top salaries.
*/


    SELECT
        postings.job_id AS job_id,
        companies.name AS company_name,
        postings.job_title,
        postings.job_location,
        postings.job_schedule_type,
        postings.salary_year_avg,
        postings.job_posted_date
    FROM
        job_postings_fact AS postings
        LEFT JOIN company_dim AS companies ON postings.company_id = companies.company_id
    WHERE
        job_title_short = 'Data Analyst' AND
        job_location LIKE '%Anywhere%' AND
        salary_year_avg IS NOT NULL
    ORDER BY
        salary_year_avg DESC
    LIMIT 10;



