# Introduction
Dive into the data job market! Focusing on data analyst roles, this project explores top-paying jobs, in-demand skills, and where high demand meets high salary in data analytics.

SQL queries: [project_sql folder](/project_sql/).
# Background
Driven by a quest to navigate the data analyst job market more effectively, this project was born from a desire to pinpoint top-paid and in-demand skills, streamlining others work to find optimal jobs.
# Questions I wanted to answer through my SQL queries were:
1. What are the top-paying data analyst jobs?
2. What skills are required for these top-paying jobs?
3. What skills are most in demand for data analysts?
4. What skills are associated with higher salaries?
5. What are the most optimal skills to learn?
# Tools I used
- **SQL:** The backbone of my analysis, allowing me to query the database and unearth critical insights.
 - **PostreSQL:** The chosen database management system, ideal for handling the job posting data.
 - **Python(Pandas, Numpy, Matplotlib):** A convenient tool for quick visualizations and insights based on it.
 - **Visual Studio Code:** My go-to for database management and executing SQL queries.
 - **Git & GitHub:** Essential for version control and sharing my SQL and Python scripts, analysis, ensuring collaboration and project tracking. 
# The Analysis
Each query for this project aimed at investigating specific aspects of the data analyst job market. Here's how I approached each question:
### 1. Top-Paying Data Analyst Jobs
To identify the highest-paying roles, I filtered data analyst postitons by average yearly salary and location, focusing on remote jobs. This query highlights the high paying opportunities in the field.

```sql
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
```
Here is the breakdown of the top data analyst jobs in 2023:
- **Wide Salary Range:** Top 10 paying data analyst roles span from $184,000 to $650,000, indicating significant salary potential in the field.
- **Diverse Employers:** Companies like SmartAsset, Meta and AT&T are among those interest offering high salaries, showing a abroad interest across different industries.
- **Job Title Variety:** There's high diversity in job titles, from Data Analyst to Director of Analytics, reflecting varied roles and specializations within data analytics.

### 2. Skills for Top-Paying Jobs
To understand what skills are required for the top-paying jobs, I joined the job postings with skills data, providing insights into what employers value for high-compensation roles.

```sql
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
```
Here is the breakdown of the most demanded skills for the top 10 highest paying data analyst jobs in 2023:
- **SQL** is leading with a bold count of 8.
- **Python** follows closely with a bold count of 7.
- **Tableau** is also highly sought after, with bold count of 6. Other skills like **R**, **Snowflake**, **Pandas** and **Excel** showing varying degrees of demand.

![Top skills for top-paying jobs](assets\Figure_1.png)

*Bar graph visualizing the top skills for top-paying jobs*

### 3. In-Demand Skills for Data Analysts
This query helped identify the skills most frequently requested in jobs postings, directing focus to areas with high demand.

```sql
SELECT
    skills_dim.skills,
    COUNT(job_postings_fact.job_id) AS num_postings
FROM
    skills_job_dim
    LEFT JOIN job_postings_fact ON skills_job_dim.job_id = job_postings_fact.job_id
        AND
        job_postings_fact.job_title_short = 'Data Analyst' AND
        job_postings_fact.job_location = 'Anywhere'
    LEFT JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
GROUP BY
    skills_dim.skills
ORDER BY
    COUNT(job_postings_fact.job_id) DESC
LIMIT 5;
```
Here is the breakdown of the most demanded skills for data analysts in 2023:
- **SQL** and **Excel** remain fundamental, emphasizing the need for strong foundational skills in data processing and spreadsheet manipulation.
- **Programming** and **Visualization Tools** like **Python**, **Tableau** and **Power BI** are essential, pointing towards the increasing importance of technical skills in data storytelling and desicion support.

| Skills   | Demand Count |
|----------|--------------|
| SQL      | 7291         |
| Excel    | 4611         |
| Python   | 4330         |
| Tableau  | 3745         |
| Power BI | 2609         |

### 4. Skills Based on Salary
Exploring the average salaries associated with different skills revealed which skills are the highest paying.
```sql
SELECT
    skills_dim.skills,
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
    skills_dim.skills
ORDER BY
    avg_salary DESC
LIMIT 25;
```
Here is the breakdown of the result for top paying skills for Data Analysts:
- **High-Paying Data Processing and Version Control Skills:** Pyspark stands out with the highest average salary of $208,172, indicating a strong demand for expertise in distributed data processing. Bitbucket also commands a significant salary of $189,155, reflecting the importance of version control and collaborative development environments.
- **Valuable Data Science and Cloud Platform Skills:** Tools like Pandas ($151,821), Jupyter ($152,777), and Numpy ($143,513) are essential for data analysis and numerical computing,highlighting their importance in the data analyst role. GCP ($122,500) and Kubernetes ($132,500) underscore the need for cloud platform and container orchestration skills.
- **Specialized and Collaboration Technologies:** Databricks ($141,907) and Microstrategy ($121,619) show the value of specialized analytics platforms. Collaboration tools like Atlassian ($131,162) and Notion ($125,000) are also crucial, emphasizing the role of project management and team collaboration in data analytics.

### 5. Most Optimal Skills to Learn
Combining insights from demand and salary data, this query aimed to pinpoint skills that are both in high demand and have high salaries, offering a strategic focus for skill development.
```sql
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
```
Here is the breakdown of the most optimal skills for Data Analysts in 2023:
- **High-Demand Programming Languages:** Python and R stand out of their demand, with demand counts of 236 and 148 respectively. Despite their high demand, their average salaries are around $101,397 for Python and $100,499 for R, indicating that proficiency in these languages is highly valued but also widely avalaible.
- **Cloud Tools and Technologies:** Tableau and Looker, with demand counts of 230 and 49 respectively, and average salaries around $99,288 and $103,795, highlight the critical role of data visualization and business intelligence in deriving actionable insights from data.
- **Database Technologies:** The demand for skills in traditional and NoSQL databases (Oracle, SQL server, NoSQL) with average salaries ranging from $97,786 to $104,534, reflects the enduring need for data storage, retireval management expertise 

# What I learned

Throughout this adventure, I've turbocharged my SQL toolkit with some serious firepower:
- **Complex Query Crafting:** Mastered the art of advanced SQL, merging tables like a pro and wielding WITH clauses for ninja-level temp table maneuvers.
- **Data Aggregation:** Got cozy with GROUP BY and turned aggregate functions like COUNT() and AVG() into my data-summarizing sidekicks.
- **Analytical Wizardry:** Leveled up my real-world puzzle-solving skills, turning questions unto actionable, insightful SQL queries.

# Conclusins
### Insights

1. **Top-Paying Data Analyst Jobs**: The highest-paying jobs for data analysts that allow remote work offer a wide range of salaries, the highest at $650,000!
2. **Skills for Top-Paying Jobs**: High-paying data analyst jobs require advanced proficiency in SQL, suggesting it's a critical skill for earning a top salary.
3. **Most In-Demand Skills:** SQL is also the most demanded skill in the data analyst job market, thus making it essential for job seekers.
4.  **Skills with Higher Salaries**: Specialized skills, such as SVN and Solidity, are associated with the highest average salaries, indicating a premium on niche expertise.
5. **Optimal Skills for Job Market Value:** SQL leads in demand and offers for a high average salary, postitioning it as one of the most optimal skills for data analysts to learn to maximize their market value

### Closing Thoughts

This project enchanced my SQL skills and provided valuable insights into the data analyst job market. The findings from the analysis serve as a guide to prioritizing skill development and job search efforts. Aspiring data analysts can better postition themselves in a competitive job market by focusing on high-demand, high-salary skills. This exploration highlights the importance of continuous learning and adaptaiton to emerging trends in the field of data analytics.