
import pandas as pd
import matplotlib.pyplot as plt
import csv
import numpy as np

x = []
y = []
z = []
with open('/home/nils/Desktop/LCR_PY_PLOT/testfile.csv','r') as csvfile:
    plots = csv.reader(csvfile, delimiter=' ')
    next(plots)#headers
    for row in plots:
        x.append(float(row[5]))
        y.append(float(row[1]))
        z.append(float(row[3]))
print("Cp")
print(x)
f=np.array(x)
k=np.delete(f,0)
print("popcp:",k)
d=np.array(y)
h=np.diff(d)
print("dAbleitung:")
print(len(d))
print (h)
print(np.diff(d))
print(k)





plt.plot(k, np.diff(d),'-o',color="blue")
plt.ylabel("Cp [F]", fontsize=16, color="blue")
plt.xlabel("Bias [V]", fontsize=16)
plt.ylim(-2.0e-15, -1.0e-12)
#plt.xscale("log")
#plt.yscale("log")
plt.grid(True)
plt.show()

#plt.plot(x,y, 'o', label='Line')
#plt.plot(x,z, 'o', lw=2, color="darkgreen")
#plt.xlabel('Bias [V]')
#plt.ylabel('Cp [F]')
#plt.title('101 logSteps')
#plt.legend()
#plt.show()
