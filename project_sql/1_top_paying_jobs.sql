/*
Question: What are the top-paying data analyst jobs?
- Identify the top highest-paying Data Analyst roles that are available remotely.
- Focuse on job postings with specified salaries
- Why? Aims to highlight the top-paying opportunities for Data Analysts, offering insights into employment options and location flexibility.
*/
WITH top_paying_data_analyst_jobs AS (
    SELECT
        postings.job_id,
        companies.name AS company_name,
        postings.job_title,
        postings.salary_year_avg
    FROM
        job_postings_fact AS postings
        LEFT JOIN company_dim AS companies ON postings.company_id = companies.company_id
    WHERE
        job_title_short = 'Data Analyst' AND
        job_location LIKE '%Anywhere%' AND
        salary_year_avg IS NOT NULL
    ORDER BY
        salary_year_avg DESC
    LIMIT 10
)

SELECT 
    top_paying_data_analyst_jobs.*,
    skills_dim.skills
FROM
    top_paying_data_analyst_jobs
    INNER JOIN skills_job_dim ON top_paying_data_analyst_jobs.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
    salary_year_avg DESC