import pandas as pd
import matplotlib.pyplot as plt
import csv

x = []
y = []
z = []

with open('/home/nils/Desktop/5khz_0-50V_100stps_log.csv','r') as csvfile:
    plots = csv.reader(csvfile, delimiter=' ')
    next(plots)#headers
    for row in plots:
        x.append(float(row[5]))
        y.append(float(row[1]))
        z.append(float(row[3]))

fig, ax1 = plt.subplots(figsize=(3, 5))
ax1.plot(x, y,'-o',lw=2,color="blue")
ax1.set_ylabel(r"Cp [F]", fontsize=16, color="blue")
ax1.set_xlabel(r"Bias [V]", fontsize=16)
plt.ylim(0, 1.2e-10)
for label in ax1.get_yticklabels():
    label.set_color("blue")
ax2 = ax1.twinx()
ax2.plot(x, z,'-o',lw=2.0, color="darkgreen")
ax2.set_ylabel(r"D", fontsize=16, color="darkgreen")
plt.ylim(0, 2)
for label in ax2.get_yticklabels():
    label.set_color("darkgreen")
plt.grid(True)
plt.show()

#plt.plot(x,y, 'o', label='Line')
#plt.plot(x,z, 'o', lw=2, color="darkgreen")
#plt.xlabel('Bias [V]')
#plt.ylabel('Cp [F]')
#plt.title('101 logSteps')
#plt.legend()
#plt.show()
