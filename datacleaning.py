#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed May 16 21:08:15 2018

@author: neo
"""

import pandas as pd
import numpy as np

data = pd.read_csv("./data/origindata.txt",header=None)


#获取缺失块的索引范围
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

#验证截取缺失数据块是否有错误
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


#将索引范围转换成索引项的list
def getindex(lose):
    
    index = []
    
    for i in lose: 
        start,end = i
        index.append(list(range(start,end+1)))
        
    return index

#提取填充数据的索引项的list
def getfindex(lose):
    findex = []
    
    for i in lose:
        start,end = i
        size = end - start+1
        findex.append(list(range(start-size,end+1-size)))
    return findex

#提取填充数据的索引项的list
def getrfindex(lose):
    rfindex = []
    
    for i in lose:
        start,end = i
        size = end - start+1
        rfindex.append(list(range(end+1-size,start-size)))
    return rfindex


#缺失数据块进行填充
def filling():
    pass

#缺失数据块进行反向填充
def reverse_filling():
    pass


if __name__ == "__main__":
    
    lose = getloseindex(data)
    index = getindex(lose)