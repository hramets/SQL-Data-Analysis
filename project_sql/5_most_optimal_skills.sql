/*
Question: What are the most optimal skills to learn 
    (aka it's in high demand and a high-paying skill)?
- Identify skills in high demand and associated with high average salaries for Data Analyst roles.
- Concentrates on remote postitons with specified salaries.
- Why? Targets skills that offer job security (high demand) and financial benefits (high salaries),
    offering strategic insights for career development in data analysis.
*/

WITH top_paying_skills AS (
    SELECT
        skills_job_dim.skill_id,
        skills_dim.skills AS skills,
        ROUND(AVG(job_postings_fact.salary_year_avg), 0) AS avg_salary
    FROM
        skills_job_dim
        INNER JOIN job_postings_fact ON skills_job_dim.job_id = job_postings_fact.job_id
            AND
            job_postings_fact.job_title_short = 'Data Analyst' AND
            job_postings_fact.job_location = 'Anywhere' AND
            job_postings_fact.salary_year_avg IS NOT NULL
        INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    GROUP BY
        skills_dim.skills,
        skills_job_dim.skill_id
),

the_most_demand_skills AS (
    SELECT
        skills_job_dim.skill_id,
        skills_dim.skills AS skills,
        COUNT(job_postings_fact.job_id) AS num_postings
    FROM
        skills_job_dim
        LEFT JOIN job_postings_fact ON skills_job_dim.job_id = job_postings_fact.job_id
            AND
            job_postings_fact.job_title_short = 'Data Analyst' AND
            job_postings_fact.job_location = 'Anywhere' AND
            job_postings_fact.salary_year_avg IS NOT NULL
        LEFT JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    GROUP BY
        skills_dim.skills,
        skills_job_dim.skill_id
)

SELECT
    top_paying_skills.skills,
    top_paying_skills.avg_salary,
    the_most_demand_skills.num_postings
FROM 
    top_paying_skills
    INNER JOIN the_most_demand_skills ON top_paying_skills.skill_id = the_most_demand_skills.skill_id
WHERE
    the_most_demand_skills.num_postings > 10
ORDER BY
    avg_salary DESC,
    num_postings DESC
LIMIT 25;
