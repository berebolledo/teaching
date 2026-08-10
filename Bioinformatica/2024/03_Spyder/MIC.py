#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed May  8 19:13:47 2024

@author: boris
"""

import numpy as np
import pandas as pd
labels = ["mic"+str(i) for i in range(1,9)]
value1 = [1, 0.5, 2, np.nan, np.nan, np.nan, np.nan, np.nan,] 
value2 = [1, 0.5, 0.125, 0.5, np.nan, np.nan, np.nan, np.nan,] 

df = pd.DataFrame([value1,value2])
df.columns = labels

df

def myfunction(s):
    result = s.sum()
    return(result)

df.apply(myfunction, 1)
