#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon May 27 15:36:38 2024

@author: boris
"""

import seaborn as sns
import pandas as pd
import matplotlib.pyplot as plt

sns.set_theme()
sns.set(font="Verdana")

data = pd.read_csv("09_csv_format_example.csv")

sortdata = data.sort_values(by = 'Diagnosis').reset_index()
sortdata.Radius_mean
sortdata.index

# Create a line plot for 'Radius_mean'
plt.figure(figsize=(10, 6))
sns.lineplot(data=sortdata, x=sortdata.index, y='Radius_mean')
plt.title('Line Plot of Radius Mean')
plt.xlabel('Index')
plt.ylabel('Radius Mean')
plt.show()

# Scatter plot
plt.figure(figsize=(10, 6))
sns.scatterplot(data=data, x='Radius_mean', y='Texture_mean', hue='Diagnosis', legend = 'full')
plt.title('Scatter Plot of Radius Mean vs Texture Mean')
plt.xlabel(r'$\log_{10}(x)$')
plt.xlabel(r'FDC ($\mu$g/mL)')


# Histogram
plt.figure(figsize=(10, 6))
sns.histplot(data=data, x='Area_mean', kde=True)
plt.title('Histogram of Area Mean')
plt.show()

# Box plot
plt.figure(figsize=(10, 6))
sns.boxplot(data=data, x='Diagnosis', y='Compactness_mean')
plt.title('Box Plot of Compactness Mean by Diagnosis')
plt.show()

# Heatmap
plt.figure(figsize=(20, 20))
corr = data.iloc[:,2:].corr()
sns.heatmap(corr, annot=True, cmap='coolwarm')
plt.title('Correlation Heatmap')
plt.show()


# Create a bar plot for the 'Diagnosis' column
plt.figure(figsize=(10, 6))
sns.countplot(data=data, x='Diagnosis', hue = 'Diagnosis')
plt.title('Bar Plot of Diagnosis')
plt.xlabel('Diagnosis')
plt.ylabel('Count')
plt.show()


# Create a strip plot for 'Radius_mean' grouped by 'Diagnosis'
plt.figure(figsize=(10, 6))
sns.stripplot(data=data, x='Diagnosis', y='Radius_mean', jitter=True)
plt.title('Strip Plot of Radius Mean by Diagnosis')
plt.xlabel('Diagnosis')
plt.ylabel('Radius Mean')
plt.show()

# Create a FacetGrid for 'Diagnosis' with scatter plots of 'Radius_mean' vs 'Texture_mean'
g = sns.FacetGrid(data, col='Diagnosis', height=6, aspect=1.2)
g.map(sns.scatterplot, 'Radius_mean', 'Texture_mean')

# Add titles and labels
g.fig.suptitle('FacetGrid of Radius Mean vs Texture Mean by Diagnosis', y=1.05)
g.set_axis_labels('Radius Mean', 'Texture Mean')

plt.show()



#plt.title('Title')
#plt.xlabel('X-axis Label')
#plt.ylabel('Y-axis Label')
