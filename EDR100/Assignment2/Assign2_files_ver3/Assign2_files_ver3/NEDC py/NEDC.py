import pandas as pd
df = pd.read_csv('clean_nedc.csv',index_col=0)
lst = []
lstv = []
lstt = []
rows = len(df.index)
name = str("NEDC.csv")
for i in range(1,rows):
    lst.append(df.time[i] - df.time[i -1])

for k in range(len(lst)):
    for j in range(lst[k]):
        lstv.append(df.velocity[k])
for g in range(len(lstv)):
    lstt.append(g)

df = pd.DataFrame({'time':[],'velocity[m/s]':[]})
df.to_csv(name,mode='a',index=False, header=True)
for i in range(len(lstt)):
    df = pd.DataFrame({'time':[lstt[i]],'velocity[m/s]':[lstv[i]]})
    df.to_csv(name,mode='a',index=False, header=False)
