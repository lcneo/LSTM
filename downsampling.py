#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu May 17 00:43:01 2018

@author: neo
"""

import pandas as pd

#降采样间隔的系数
#ratio= {'oneh':oneh,'threeh':threeh,'sixh':sixh}
#,'twelveh':1200,'oned':10000,'threed':30000


#读取文件
def loaddata(path):
    data = pd.read_csv(path)
    return data


#通过groupby对每一个小时的数据进行降采样
def oneh(data):
    cdata = data
    cdata['time'] =cdata['time'] // 2*2
    grouped = cdata['value'].groupby(cdata['time'])
    return grouped
    
#三个小时间隔的数据降采样
def threeh(data):
    cdata = data
    cdata['time'] =cdata['time'] // 300*3
    grouped = cdata['value'].groupby(cdata['time'])
    return grouped

#六个小时间隔的数据降采样
def sixh(data):
    cdata = data
    cdata['time'] =cdata['time'] // 600*6
    grouped = cdata['value'].groupby(cdata['time'])
    return grouped

#十二个小时间隔的数据降采样
def twelveh(data):
    cdata = data
    cdata['time'] =cdata['time'] // 1200*12
    grouped = cdata['value'].groupby(cdata['time'])
    return grouped
#一天间隔的数据降采样
def oned(data):
    cdata = data
    cdata['time'] =cdata['time'] // 10000
    grouped = cdata['value'].groupby(cdata['time'])
    return grouped
#三天间隔的数据降采样
def threed(data):
    cdata = data
    cdata['time'] =cdata['time'] // 30000*3
    grouped = cdata['value'].groupby(cdata['time'])
    return grouped

def onew(data):
    cdata = data
    cdata['time'] =cdata['time'] // 120000*12
    grouped = cdata['value'].groupby(cdata['time'])
    return grouped

#将降采样函数存入词典中循环调用
ratio= {'oneh':oneh,'threeh':threeh,'sixh':sixh,'twelveh':twelveh,'oned':oned,'threed':threed}



#将groupby转换为DataFrom
def getdsdata(grouped):
    gmax = grouped.max()
    gmin = grouped.min()
    gmean = grouped.mean()
    gmedian = grouped.median()
    gtime = pd.Series(data=list(gmax.index),index=list(gmax.index),name='time')
    dsdata = pd.concat([gtime,gmax,gmin,gmean,gmedian],axis=1,ignore_index = True)
    dsdata.index = range(len(dsdata))
    dsdata.columns = ['time','max','min','mean','median']
    return dsdata

#存储结果文件
def savedsdata(filedata,filename):
    
    filedata.to_csv("data/ycqd/"+filename+".csv",index=False,encoding="utf-8")
    print("{0}文件写入成功!".format(filename+".csv"))

#完成一次降采样
def dwsamoling(path,name,foo,r=False):
    data = data = loaddata(path)
    grouped = foo(data)
    dsdata = getdsdata(grouped)
    if r == True:
        name = "r"+name
    savedsdata(dsdata,name)

#循环几个函数
def dwsamolingall(path,r=False):
    for i in ratio:
        dwsamoling(path,i,ratio[i],r=r)
#对填充文件进行多种降采样  
def ds():
    path = 'data/fillingdata.csv'
    dwsamolingall(path,r=False)

#对镜像补齐文件进行多种降采样
def rds():
    path = 'data/rfillingdata.csv'
    dwsamolingall(path,r=True)
    
if __name__ == "__main__":
    #ds()
    #rds()
    #path = 'data/pressure/fillingdata.csv'
    #dwsamoling(path,"onew",onew)
    path = "data/ycqd/fycqd.csv"
    dwsamoling(path,"twelveh",oneh)