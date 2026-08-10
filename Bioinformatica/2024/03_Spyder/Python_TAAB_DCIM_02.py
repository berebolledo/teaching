#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu May  2 11:29:28 2024

@author: boris
"""
# FUNCIONES -------------------------------------------------------------------

def saludo():
    s = 'Hola, bienvenide'
    return(s)


def saludo(nombre):
    s = 'Hola ' + nombre + ', bienvenide'
    return(s)


def saludo(nombre = 'Antonio'):
    s = 'Hola ' + nombre + ', bienvenide'
    return(s)

def sumar(a, b):
    resultado = a + b 
    return(resultado)

# PANDAS ----------------------------------------------------------------------
import pandas as pd
df = pd.read_csv("FDC_Dataframe_nonCP_genome_05Abril.csv")

df.shape
df.info()
df.head()
df.tail()

# Acceso a columnas
df['TOTAL_SUM']
df.columns


listado = list(df.columns)
rango = range(len(listado))

columnas_numeradas = list(zip(rango, listado))

for t in columnas_numeradas:
    if t[1] == 'SHV_SUM':
        print(t[0])


column_indexes = {col: idx for idx, col in enumerate(df.columns)}
column_indexes
column_indexes['SHV_SUM']



df[['NARROW_SUM', 'TOTAL_SUM']]

# Acceso a filas con indice numerico
df.iloc[0]
df.iloc[0:2]

# ¿Cual es el indice de las columnas NARROW_SUM y TOTAL_SUM?
list(df.columns).index('NARROW_SUM')
list(df.columns).index('TOTAL_SUM')

df.iloc[0:2, [101, 102]]
df.iloc[0:2, 101:102]

# Indice por nombre de fila y columna
df.loc[0,['NARROW_SUM', 'TOTAL_SUM']]
df.loc[0:2,['NARROW_SUM', 'TOTAL_SUM']]


# OPERACIONES -----------------------------------------------------------------

df = pd.read_csv("09_csv_format_example.csv")

# Filtrar por una condicion
malignos = df['Diagnosis'] == "M"

df[malignos]

filtro2 = df['Radius_mean'] > 20


df[malignos & filtro2][['Diagnosis', 'Radius_mean']]
df[malignos | filtro2][['Diagnosis', 'Radius_mean']]


# Reemplazar valores
df['Diagnosis2'] = df['Diagnosis'].replace({'M': 'Malignant', 'B': 'Benign'})

# Concatenacion
df1 = df.head()
df2 = df.tail()
df_concatenado = pd.concat([df1, df2])

# Guardar
df_concatenado.to_csv("output.csv", index = False)


# Operaciones matematicas por columnas
df['Diagnosis'].value_counts()

df['Radius_mean'].mean()
df['Radius_mean'].median()

df.loc[:,['Radius_mean', 'Radius_se']].mean()

df.groupby('Diagnosis')["Radius_mean"].mean()
df.groupby('Diagnosis')[['Radius_mean', 'Radius_se']].mean()

df.groupby('Diagnosis').mean()
df.groupby('Diagnosis').mean()['Radius_mean']

df.groupby('Diagnosis')['Perimeter_mean'].agg(['min', 'max', 'mean'])


# Generar otra columna a partir de la operacion de columnas
df_corto = df.loc[:,['Diagnosis', 'Radius_mean', 'Radius_se']]

df_corto['Radius_cv'] = df_corto['Radius_se'] / df_corto['Radius_mean']

# Ordenar de menor a mayor
df_corto.sort_values(by = 'Radius_cv', ascending = True)
df_corto.sort_values(by = ['Radius_cv', 'Diagnosis'], ascending = True)


# PLOTS -----------------------------------------------------------------------

import seaborn as sns
import matplotlib.pyplot as plt

sns.histplot(data=df_corto, x="Radius_cv", bins=20, kde=True, color="green")
plt.xlabel("Radious CV")
plt.ylabel("Frequency")

sns.boxplot(data = df, x = "Diagnosis", y="Radius_mean" )


sns.scatterplot(x='Radius_mean', y='Area_mean', hue='Diagnosis', data=df)
plt.title('Relación entre Radio Medio y Área Media por Diagnóstico')
plt.xlabel('Radio Medio')
plt.ylabel('Área Media')


-------------------------------------------------------------------------------


bd = {'estudiante': {'nombre':'camila', 'nacto':1995}, 
      'profesor':{'nombre': 'boris', 'nacto':1986}}

for key in bd.keys():
    bd[key]['edad'] = 




