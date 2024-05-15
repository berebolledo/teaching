#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue May 14 14:10:21 2024

@author: boris
"""
import numpy as np
import pandas as pd

data = {"mic1" : [2,1,8], 
        "mic2" : [2, 0.5, 1], 
        "mic3" : [4, 2, 0.5], 
        "mic4" :[np.nan, 2, np.nan]}

df = pd.DataFrame(data)



def consistencia(fila):
    
    resultado = []
    x = fila.dropna().tolist()
    
    for i in x:
        for j in x:
            div = i/j
            resultado.append(div)
            
    truefalse = []
    for valor in resultado:
        if valor >= 0.5 and valor <= 2:
            truefalse.append(True)
        else:
            truefalse.append(False)
    
        
    return(len(truefalse) == sum(truefalse))

a = pd.Series([2,2,1,0.125])
consistencia(a)



df['consistencia'] = df.apply(consistencia, 1 )

df = pd.read_csv("FDC_Dataframe_07May.csv", encoding = 'latin-1')

list(df.columns).index('MIC 8')
#67, 69, 71, 73, 75, 77, 79, 81


mic = df.iloc[:, [67,69,71,73,75,77,79,81]]
mic_clean = mic.replace('<0,06', np.nan)
mic_clean_float = mic_clean.astype(float)

mic_clean_float['consistencia'] = mic_clean_float.apply(consistencia, 1 )

mic_clean_float['inconsistent MIC'] = df['inconsistent MIC']

mic_clean_float.to_csv("mic_clean_float", index = False)



