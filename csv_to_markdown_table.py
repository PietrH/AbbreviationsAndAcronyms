# -*- coding: utf-8 -*-
"""
Created on Mon Nov 18 16:54:21 2019

@author: pieterhuy
"""

import pandas as pd
import numpy as np

# Read the source data
df = pd.read_csv('Abbreviations_and_Acronyms.csv', quotechar='"')

# get the domain name from the links
## function to format the reference link into markdown links
def format_reference(link):
   if not str(link)=="nan" or not str(link)=="---":
       return "[reference]"+"("+str(link)+")"
## apply function
df["Reference_Link"]=list(map(format_reference,df["Reference_Link"]))
# append a numpy array with n times the header seperator, with n being the
# number of columns then store this array as a pandas dataframe with setting the
# header to the original header
df = pd.DataFrame(
    np.insert(df.values, 0, values=['---'] * len(df.columns), axis=0),
    columns=df.columns)
# Replace None with nan so the markdown table will parse
df.fillna(value=pd.np.nan, inplace=True)
# write this to a markdown file using the csv parser and setting the seperator
# to pipes, we do not care about the index
df.to_csv('README.md', sep='|', index=False)
