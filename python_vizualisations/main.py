import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

data = "C:\\Users\\artjo\\.vscode\\SQL Data Analysis\\csv_files\\top_paying_data_analyst_job_skills.csv"

df = pd.read_csv(data)

skills_arr = np.asarray(df['skills'])

unique, frequency = np.unique(skills_arr, return_counts=True)
skills_dict = dict(zip(unique, frequency))
sorted_skills_dict = dict(sorted(skills_dict.items(), key=lambda item: item[1], reverse=False))
unique = np.asarray(list(sorted_skills_dict.keys()))
frequency = np.asarray(list(sorted_skills_dict.values()))

x = unique
y = frequency
fig, ax = plt.subplots(figsize=(12, 8), layout='constrained')
ax.barh(x, y)
ax.set_xlabel('Frequency')
ax.set_ylabel('Skills')

plt.show()