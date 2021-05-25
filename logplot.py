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
plt.plot(x, y,'-o',lw=2,color="blue")
plt.ylabel("Cp [F]", fontsize=16, color="blue")
plt.xlabel("Bias [V]", fontsize=16)
#plt.ylim(0, 1.2e-10)
plt.xscale("log")
plt.yscale("log")
plt.show()

#plt.plot(x,y, 'o', label='Line')
#plt.plot(x,z, 'o', lw=2, color="darkgreen")
#plt.xlabel('Bias [V]')
#plt.ylabel('Cp [F]')
#plt.title('101 logSteps')
#plt.legend()
#plt.show()

