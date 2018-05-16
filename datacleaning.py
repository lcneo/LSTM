#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed May 16 21:08:15 2018

@author: neo
"""

import pandas as pd
import numpy as np

data = pd.read_csv("./data/origindata.txt",header=None)

def getloseindex(data):
    loselist = list(data[data[1] == 999999].index)
    start,end,lose = loselist[0],loselist[0],[]
    
    for i in loselist:
        if((i == end) | (i == end +1)):
            end = i
        else:
            lose.append([start,end])
            start,end = i,i
        if(i == loselist[-1]):
            lose.append([start,end])
    return lose

def main():
    pass

def check(lose):
    temp,l = [0,0],[]
    
    for i in lose:
        if(temp[1]<i[0]):
            pass
        else:
            print("false")
        if(i[0] == i[1]):
            l.append(i)
        temp = i
    print(l)
    return l
if __name__ == "__main__":
    main()
    lose = getloseindex(data)
    l = check(lose)